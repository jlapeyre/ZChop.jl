# ZChop

*Replace small numbers with zero, or round numbers*

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

The interface and implementation of `nchop` is not finished.

```nchop(x, args...; kwargs...)``` round `x` using `round`. If `x` is a container or nested container, round numbers in the
   containers.

```nchop!``` a mutating version of `nchop`.

### Performance

`zchop` trims noise only from numbers that should be zero. `nchop` trims noise from non-zero numbers as well.
But, `zchop` is several times faster than `nchop`.

### Examples

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
