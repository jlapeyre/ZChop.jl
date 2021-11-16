"""
The `ZChop` module provides the functions `zchop` and `zchop!`, which replace
numbers that are close to zero with zero. These functions act recursivley on
collections.
"""
module ZChop

export zchop, zchop!
export nround!, nchop, nchop!

"""
    ZEPS::Float64

The default lower threshold for a number to be replaced by zero.
"""
const ZEPS = 1e-14

zchop!(x::Real, eps::Real = ZEPS) = abs(x) > eps ? x : zero(x)
zchop!(x::Complex, eps::Real = ZEPS) = complex(zchop!(real(x), eps), zchop!(imag(x), eps))
zchop!(x::Irrational, eps::Real = ZEPS) = zchop!(float(x), eps)
zchop!(x::Union{AbstractString,AbstractChar}, eps::Real = ZEPS) = x

"""
    zchop!(x::T, eps::Real = ZEPS)

Perform `zchop` in place.
"""
function zchop!(a::AbstractArray, eps::Real = ZEPS)
    @inbounds for i in eachindex(a)
        a[i] = zchop!(a[i], eps)
    end
    return a
end

zchop!(a::Base.Generator, eps::Real = ZEPS) = (zchop!(x, eps) for x in a)
zchop!(a::Tuple, eps::Real = ZEPS) = zchop!.(a, eps)
zchop!(x::Expr, eps::Real = ZEPS) = Expr(x.head, zchop!(x.args)...)
zchop!(x, eps::Real) = Base.isiterable(typeof(x)) ? map((x)->zchop!(x, eps), x) : x
zchop!(x) = Base.isiterable(typeof(x)) ? map(zchop!, x) : x
zchop!(x::Number, eps::Real=ZEPS) = x

# TODO: This is slightly wasteful for, say, Array{Float64}. We might want a method
# just for arrays of some kinds of numbers. It is not clear to me what
# the intended symantic difference is between deepcopy(Array{Float64})
# and copy(Array{Float64}).
# For example, we could introduce a function _deepcopy that specializes many cases to
# copy or identity.
"""
    zchop(x, eps::Real = ZEPS)

Replace `x` by zero if `abs(x) < eps`.

`zchop` acts recursively on mappable objects. `zchop` acts
independently on each part of a complex number.
Objects whose components cannot be sensibly compared to a real
number are passed unaltered.
"""
zchop(x::Any, eps::Real=ZEPS) = zchop!(deepcopy(x), eps)

#### applyf!

function applyf!(func, a::AbstractArray, args...; kwargs...)
    @inbounds for i in eachindex(a)
        a[i] = applyf!(func, a[i], args...; kwargs...)
    end
    return a
end

applyf!(func, x::Number, args...; kwargs...) = func(x, args...; kwargs...)
applyf!(func, x::Union{AbstractString, AbstractChar, Symbol}, args...; kwargs...) = x
applyf!(func, x::Expr, args...; kwargs...) = Expr(x.head, applyf!(func, x.args, args...; kwargs...)...)

nround!(x::Number, args...; kwargs...) = round(x, args...; kwargs...)
_myround!(x::Number, args...; kwargs...) = nround!(x, args...; kwargs...)
_myround!(x, args...; kwargs...) = applyf!(nround!, x, args...; kwargs...)

"""
    nchop(x, args...; digits=12, kwargs...)

Round `x` if it is a number, or elements in `x` if it is a, possibly nested, container.
`args` and `kwargs` are passed to `round`. `nchop` does not modify the input `x`.
"""
nchop(x, args...; digits=12, kwargs...) = nchop!(deepcopy(x), args...; digits=digits, kwargs...)

"""
    nchop!(x, args...; digits=12, kwargs...)

Mutating version of `nchop`.
"""
nchop!(x, args...; digits=12, kwargs...) = _myround!(x, args...; digits=digits, kwargs...)

end # module ZChop

# xx = [  7.401486830834377e-17 + 3.700743415417188e-17im
#     8.26024732898714e-17 + 7.020733317042351e-17im
#       0.9999999999999997 + 1.0000000000000002im
#  -1.0177044392397268e-16 - 6.476300976980079e-17im
#                      0.0 - 7.401486830834377e-17im
#  -4.5595039135699516e-17 - 2.1823706978711105e-16im
#   1.2952601953960158e-16 + 0.0im
#  -2.1079998571544233e-16 + 5.303212320736824e-17im
#                      0.0 - 7.401486830834377e-17im
#   -6.476300976980079e-17 + 2.498001805406602e-16im
#    7.401486830834377e-17 - 1.4802973661668753e-16im
#   1.7379255156127046e-16 + 2.0982745100975517e-17im ]
