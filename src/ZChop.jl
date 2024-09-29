"""
The `ZChop` module provides the functions `zchop`, `zchop!`, `nchop`, and `nchop!`.
"""
module ZChop


export zchop, zchop!
export nchop, nchop!

const PassAtom = Union{AbstractString, AbstractChar, Symbol, Number}

#### _copy

_copy(x) = deepcopy(x)
_copy(x::PassAtom) = x
_copy(x::Array{<:Number}) = copy(x)

#### applyf!

function applyf!(func, a::AbstractArray, args...; kwargs...)
    @inbounds for i in eachindex(a)
        a[i] = applyf!(func, a[i], args...; kwargs...)
    end
    return a
end

function applyf!(func, dict::Dict, args...; kwargs...)
    for k in keys(dict)
        index = Base.ht_keyindex2!(dict, k)
        @inbounds index > 0 && (dict.vals[index] = applyf!(func, dict.vals[index], args...; kwargs...))
    end
    return dict
end

applyf!(func, x::Union{Real, Complex}, args...; kwargs...) = func(x, args...; kwargs...)
applyf!(func, x::PassAtom, args...; kwargs...) = x
applyf!(func, x::Expr, args...; kwargs...) = Expr(x.head, applyf!(func, x.args, args...; kwargs...)...)
applyf!(func, x::Tuple, args...; kwargs...) = Tuple(applyf!(func, y, args...; kwargs...) for y in x)
applyf!(func, x::Base.Generator, args...; kwargs...) = (applyf!(func, y, args...; kwargs...) for y in x)
applyf!(func, x, args...; kwargs...) = Base.isiterable(typeof(x)) ? map(y -> applyf!(func, y, args...; kwargs...) , x) : x
applyf!(func, x::Irrational, args...; kwargs...) = applyf!(func, float(x), args...; kwargs...)

"""
    ZEPS::Float64

The default lower threshold for a number to be replaced by zero.
"""
const ZEPS = 1e-14 # for zchop
const NDIGITS = 14 # for nchop

"""
    zchop!(x::T, eps::Real = ZEPS)

Perform `zchop` in place.
"""
zchop!(x, eps::Real=ZEPS) = applyf!(_zchop!, x, eps)
_zchop!(x::Real, eps::Real = ZEPS) = abs(x) > eps ? x : zero(x)
_zchop!(x::Complex, eps::Real = ZEPS) = complex(_zchop!(real(x), eps), _zchop!(imag(x), eps))

"""
    zchop(x, eps::Real = ZEPS)

Replace `x` by zero if `abs(x) < eps`.

`zchop` acts recursively on mappable objects. `zchop` acts
independently on each part of a complex number.
Objects whose components cannot be sensibly compared to a real
number are passed unaltered.

See also `zchop!`, `nchop`, and `nchop!`.
"""
zchop(x::Any, eps::Real=ZEPS) = zchop!(_copy(x), eps)

## nchop, nchop!

"""
    nchop!(x, args...; digits=14, kwargs...)

Mutating version of `nchop`.

See also `zchop` and `zchop!`.
"""
function nchop!(x, args...; digits=NDIGITS, sigdigits=nothing, kwargs...)
    if sigdigits != nothing
        digits = nothing
    end
    return applyf!(round, x, args...; digits=digits, sigdigits=sigdigits, kwargs...)
end

"""
    nchop(x, args...; digits=14, kwargs...)

Round `x` if it is a number, or elements in `x` if it is a, possibly nested, container.
`args` and `kwargs` are passed to `round`. `nchop` does not modify the input `x`.

Passing a type, for example `Int` as the first argument to `round` is not supported.

See also `zchop`, `zchop!`, and `nchop!`.
"""
nchop(x, args...; digits=NDIGITS, kwargs...) = nchop!(_copy(x), args...; digits=digits, kwargs...)

end # module ZChop
