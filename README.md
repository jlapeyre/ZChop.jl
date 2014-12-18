# ZChop

[![Build Status](https://travis-ci.org/jlapeyre/ZChop.jl.svg?branch=master)](https://travis-ci.org/jlapeyre/ZChop.jl)

```zchop(x)``` return 0 if abs(x) is smaller than 1e-14, and x otherwise.

```zchop(x,eps)``` use eps rather than 1e-14

zchop works on complex and rational numbers, arrays, and some other structures. The idea
is for zchop to be the identity on anything that can't be sensibly compared to eps.
