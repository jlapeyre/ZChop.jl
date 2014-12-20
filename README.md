# ZChop

[![Build Status](https://travis-ci.org/jlapeyre/ZChop.jl.svg?branch=master)](https://travis-ci.org/jlapeyre/ZChop.jl)

```zchop(x)``` return 0 if abs(x) is smaller than 1e-14, and x otherwise.

```zchop(x,eps)``` use eps rather than 1e-14

zchop works on complex and rational numbers, arrays, and some other structures. The idea
is for zchop to descend into structures, chopping numbers, and acting as the
the identity on anything that can't be sensibly compared to eps.

## Example
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
