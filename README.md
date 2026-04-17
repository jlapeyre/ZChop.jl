# ZChop

*Replace tiny numbers with zero, or round numbers*

[![Build Status](https://github.com/jlapeyre/ZChop.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jlapeyre/ZChop.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/jlapeyre/ZChop.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jlapeyre/ZChop.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![](https://img.shields.io/badge/%F0%9F%9B%A9%EF%B8%8F_tested_with-JET.jl-233f9a)](https://github.com/aviatesk/JET.jl)

&nbsp; &nbsp; &nbsp;

## Installation

```julia
pkg> add ZChop
```

Requires Julia 1.x.

## Exports

- zchop(x, eps=ZEPS)
- zchop!(x, eps=ZEPS)
- nchop(x; digits=NDIGITS, sigdigits=nothing, kwargs...)
- nchop!(x; digits=NDIGITS, sigdigits=nothing, kwargs...)

Defaults:
- ZEPS = 1e-14
- NDIGITS = 14

## What it does

- zchop: replaces numbers with |x| ≤ eps by zero.
- NaN is preserved (remains NaN).
- Complex numbers: real and imag parts processed independently.
- Works recursively on:
  - AbstractArray, Tuple, NamedTuple
  - AbstractDict
  - Base.Generator
  - Expr
- Leaves non-numeric “atoms” unchanged (strings, symbols, chars, types).
- Irrational constants (e.g. pi) are converted to Float64 before processing.

nchop/nchop!: recursively rounds using Base.round with digits or sigdigits.

## Mutation and copying

- zchop returns a transformed copy; does not mutate input (mutable children are copied appropriately).
- zchop! mutates arrays and dicts in place; returns transformed tuples/generators while mutating any contained mutable arrays/dicts.

### Comments

* `zchop` trims noise only from numbers that should be zero.
* `nchop` trims noise from non-zero numbers as well.
* `zchop` is often more than 10 time faster than `nchop`.
* `zchop` and `nchop` are meant to be used at the command line or notebook for convenience
* `zchop` is also meant to be efficient at trimming zeros after creating, but before returning, objects in functions.

### Implementing methods for `zchop` and `nchop` for your types

It should be enough to implement a method for `ZChop.applyf!`

### Examples `zchop`

See also this [Jupyter notebook](https://github.com/jlapeyre/ZChop.jl/blob/master/Notebooks/ZChop.ipynb)
for more examples.

```julia
julia> using ZChop

julia> zchop(1e-15)
0.0

julia> zchop(complex(1.0, 1e-15))
1.0 + 0.0im

julia> zchop((a = 1e-15, b = 2.0))
(a = 0.0, b = 2.0)

julia> zchop(Dict(0 => 1e-15, 1 => 1e-8))
Dict(0 => 0.0, 1 => 1.0e-8)

julia> zchop(:(1 + 1e-16))
:(1 + 0.0)

julia> g = (i + 1e-15 for i in 1:3); collect(zchop(g))
[1.0, 2.0, 3.0]

julia> zchop(pi), zchop(pi, 4)
(3.141592653589793, 0.0)
```

```julia
julia> using FFTW

julia> using ZChop

julia> res = ifft(fft([2,1,1,0,0,0,0]))
7-element Vector{ComplexF64}:
                    2.0 + 0.0im
                    1.0 + 0.0im
                    1.0 + 0.0im
  1.527827807198305e-17 + 0.0im
  5.727136726909545e-18 + 0.0im
                    0.0 + 0.0im
 -6.344131569286608e-17 + 0.0im

julia> zchop(res)
7-element Vector{ComplexF64}:
 2.0 + 0.0im
 1.0 + 0.0im
 1.0 + 0.0im
 0.0 + 0.0im
 0.0 + 0.0im
 0.0 + 0.0im
 0.0 + 0.0im
```

```julia
julia> res = exp.((1:4) * im * pi)
4-element Vector{ComplexF64}:
 -1.0 + 1.2246467991473532e-16im
  1.0 - 2.4492935982947064e-16im
 -1.0 + 3.6739403974420594e-16im
  1.0 - 4.898587196589413e-16im

julia> zchop(res)
4-element Vector{ComplexF64}:
 -1.0 + 0.0im
  1.0 + 0.0im
 -1.0 + 0.0im
  1.0 + 0.0im
```

```julia
julia> using SparseArrays

julia> a = sparse([ [1.0,1e-16]  [1e-16, 1.0]])
2×2 SparseMatrixCSC{Float64, Int64} with 4 stored entries:
 1.0      1.0e-16
 1.0e-16  1.0

julia> zchop(a)
2×2 SparseMatrixCSC{Float64, Int64} with 4 stored entries:
 1.0  0.0
 0.0  1.0
```

```julia
julia> a = Any[ [1e-15, "dog", (BigFloat(10.0))^-15, complex(1e-15,1), 1 // 10^15],
         [[2,3] [4,1e-15]] ];

julia> zchop(a)
2-element Array{Any,1}:
 {0.0,"dog",0e+00 with 256 bits of precision,0.0 + 1.0im,0//1}
 2x2 Array{Float64,2}:
 2.0  4.0
 3.0  0.0
```

### Examples `nchop`

```julia
julia> x = [7.401486830834377e-17 + 3.700743415417188e-17im
    8.26024732898714e-17 + 7.020733317042351e-17im
      0.9999999999999997 + 1.0000000000000002im
 -1.0177044392397268e-16 - 6.476300976980079e-17im
                     0.0 - 7.401486830834377e-17im
 -4.5595039135699516e-17 - 2.1823706978711105e-16im
  1.2952601953960158e-16 + 0.0im
 -2.1079998571544233e-16 + 5.303212320736824e-17im
                     0.0 - 7.401486830834377e-17im
  -6.476300976980079e-17 + 2.498001805406602e-16im
   7.401486830834377e-17 - 1.4802973661668753e-16im
   1.7379255156127046e-16 + 2.0982745100975517e-17im]

julia> nchop(x)
12-element Vector{ComplexF64}:
  0.0 + 0.0im
  0.0 + 0.0im
  1.0 + 1.0im
 -0.0 - 0.0im
  0.0 - 0.0im
 -0.0 - 0.0im
  0.0 + 0.0im
 -0.0 + 0.0im
  0.0 - 0.0im
 -0.0 + 0.0im
  0.0 - 0.0im
  0.0 + 0.0im
```

## Notes and edge cases

- Rational, BigInt, BigFloat are supported.
- Bool, Regex, strings, symbols, chars, types are unchanged.
- Passing a type as the first argument to round (e.g. round(Int, ...)) is not supported via nchop/nchop!.
- The type of the numbers is preserved.  For instance, complex numbers
with imaginary part near zero are not replaced with real numbers.

## Testing and QA

```julia
pkg> test ZChop
```

The test suite includes Aqua and JET checks on supported Julia versions.

## License

MIT
