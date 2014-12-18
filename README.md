# ZChop

[![Build Status](https://travis-ci.org/jlapeyre/ZChop.jl.svg?branch=master)](https://travis-ci.org/jlapeyre/ZChop.jl)

```zchop(x)``` return 0 if abs(x) is smaller than 1e-14, and x otherwise.

```zchop(x,eps)``` use eps rather than 1e-14

zchop works on complex numbers, arrays, and some other structures.

I think there is something like this already in Julia, so
zchop is not neccessary. But, I was unable to find it.
