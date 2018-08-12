# ZChop

*Replace small numbers with zero*

Linux, OSX: [![Build Status](https://travis-ci.org/jlapeyre/ZChop.jl.svg)](https://travis-ci.org/jlapeyre/ZChop.jl)
&nbsp;
Windows: [![Build Status](https://ci.appveyor.com/api/projects/status/github/jlapeyre/ZChop.jl?branch=master&svg=true)](https://ci.appveyor.com/project/jlapeyre/zchop-jl)
&nbsp; &nbsp; &nbsp;
[![Coverage Status](https://coveralls.io/repos/jlapeyre/ZChop.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/jlapeyre/ZChop.jl?branch=master)
[![codecov.io](http://codecov.io/github/jlapeyre/ZChop.jl/coverage.svg?branch=master)](http://codecov.io/github/jlapeyre/ZChop.jl?branch=master)

[![ZChop](http://pkg.julialang.org/badges/ZChop_0.6.svg)](http://pkg.julialang.org/?pkg=ZChop)
[![ZChop](http://pkg.julialang.org/badges/ZChop_0.7.svg)](http://pkg.julialang.org/?pkg=ZChop)
[![ZChop](http://pkg.julialang.org/badges/ZChop_1.0.svg)](http://pkg.julialang.org/?pkg=ZChop)


`zchop(x)` replaces numbers in `x` that are close to zero with zero.

```zchop(x)``` returns 0 if abs(x) is smaller than 1e-14, and x otherwise.

```zchop(x,eps)``` uses eps rather than 1e-14

```zchop!(a,eps)``` works inplace on Array a.

The following examples use out-of-date syntax. See
this [Jupyter notebook](https://github.com/jlapeyre/ZChop.jl/blob/master/Notebooks/ZChop.ipynb)
for up-to-date examples.

Examples:


```julia
julia> res = ifft(fft([2,1,1,0,0,0,0]))
7-element Array{Complex{Float64},1}:
          2.0+0.0im
          1.0+0.0im
          1.0+0.0im
   7.8904e-17+0.0im
  4.79786e-17+0.0im
 -1.26883e-16+0.0im
 -6.34413e-17+0.0im

julia> zchop(res)
7-element Array{Complex{Float64},1}:
 2.0+0.0im
 1.0+0.0im
 1.0+0.0im
 0.0+0.0im
 0.0+0.0im
 0.0+0.0im
 0.0+0.0im
```

```julia
julia> res = exp(linspace(1,4,4) * pi * im)
4-element Array{Complex{Float64},1}:
 -1.0+1.22465e-16im
  1.0-2.44929e-16im
 -1.0+3.67394e-16im
  1.0-4.89859e-16im

julia> zchop(res)
4-element Array{Complex{Float64},1}:
 -1.0+0.0im
  1.0+0.0im
 -1.0+0.0im
  1.0+0.0im
```

```julia
julia> a = sparse([ [1.0,1e-16]  [1e-16, 1.0]])
2x2 sparse matrix with 4 Float64 entries:
        [1, 1]  =  1.0
        [2, 1]  =  1.0e-16
        [1, 2]  =  1.0e-16
        [2, 2]  =  1.0

julia> zchop(a)
2x2 sparse matrix with 2 Float64 entries:
        [1, 1]  =  1.0
        [2, 2]  =  1.0
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
