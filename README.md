# ZChop

*Replace small numbers with zero, or round numbers*

[![Build Status](https://github.com/jlapeyre/ZChop.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/jlapeyre/ZChop.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/jlapeyre/ZChop.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jlapeyre/ZChop.jl)
[![codecov.io](http://codecov.io/github/jlapeyre/ZChop.jl/coverage.svg?branch=master)](http://codecov.io/github/jlapeyre/ZChop.jl?branch=master)

Linux, OSX: [![Build Status](https://travis-ci.org/jlapeyre/ZChop.jl.svg)](https://travis-ci.org/jlapeyre/ZChop.jl)
&nbsp;
Windows: [![Build Status](https://ci.appveyor.com/api/projects/status/github/jlapeyre/ZChop.jl?branch=master&svg=true)](https://ci.appveyor.com/project/jlapeyre/zchop-jl)
&nbsp; &nbsp; &nbsp;
[![Coverage Status](https://coveralls.io/repos/jlapeyre/ZChop.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jlapeyre/ZChop.jl?branch=master)
[![codecov.io](http://codecov.io/github/jlapeyre/ZChop.jl/coverage.svg?branch=master)](http://codecov.io/github/jlapeyre/ZChop.jl?branch=master)


### `zchop`

```zchop(x)``` replaces numbers in `x` that are close to zero with zero.

```zchop(x)``` returns 0 if abs(x) is smaller than 1e-14, and x otherwise.

```zchop(x,eps)``` uses eps rather than 1e-14

```zchop!(a,eps)``` works inplace on Array a.

### `nchop`

The interface and implementation of `nchop` was done November 16, 2021 and may change.

```nchop(x, args...; kwargs...)``` round `x` using `round`. If `x` is a container or nested container, round numbers in the
   containers.

```nchop!``` a mutating version of `nchop`.

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

### Details

The type of the numbers is preserved.  For instance, complex numbers
with imaginary part near zero are not replaced with real numbers.

zchop works on complex and rational numbers, arrays, and some other structures.
The idea is for zchop to descend into structures, chopping numbers, and acting as the
the identity on anything that can't be sensibly compared to eps.

### Example
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
