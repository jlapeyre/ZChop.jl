# ZChop

`zchop(x)` replaces numbers in `x` that are close to zero with zero.

```zchop(x)``` returns 0 if abs(x) is smaller than 1e-14, and x otherwise.

```zchop(x,eps)``` uses eps rather than 1e-14

```zchop!(a,eps)``` works inplace on Array a.

Examples:

```julia
julia> res = real(ifft(fft([2,1,1,0,0,0,0])))
7-element Array{Float64,1}:
  2.0        
  1.0        
  1.0        
  7.8904e-17 
  4.79786e-17
 -1.26883e-16
 -6.34413e-17

julia> zchop(res)
7-element Array{Float64,1}:
 2.0
 1.0
 1.0
 0.0
 0.0
 0.0
 0.0
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

zchop works on complex and rational numbers, arrays, and some other structures.
The idea is for zchop to descend into structures, chopping numbers, and acting as the
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
