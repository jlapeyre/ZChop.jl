"""
The `ZChop` module provides the functions `zchop` and `zchop!`, which replace
numbers that are close to zero with zero. These functions act recursivley on
collections.
"""
module ZChop

export zchop, zchop!

"""
    ZEPS::Float64

The default lower threshold for a number to be replaced by zero.
"""
const ZEPS = 1e-14

"""
    zchop(x, eps::Real = ZEPS)

Replace `x` by zero if `abs(x) < eps`.

`zchop` acts recursively on mappable objects. `zchop` acts
independently on each part of a complex number.
Objects whose components cannot be sensibly compared to a real
number are passed unaltered.
"""
zchop(x::Real, eps::Real = ZEPS) = abs(x) > eps ? x : zero(typeof(x))
zchop(x::Complex, eps::Real = ZEPS) = complex(zchop(real(x), eps), zchop(imag(x), eps))
# Following is not type stable
zchop(x::Irrational, eps::Real = ZEPS) = zchop(float(x), eps)
# Do not iterate over strings
zchop(x::Union{AbstractString,AbstractChar}, eps::Real = ZEPS) = x

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

zchop!(x::Any, eps=ZEPS) = zchop(x, eps)

zchop(a::AbstractArray, eps::Real = ZEPS) = zchop!(copy(a), eps)
zchop(a::Base.Generator, eps::Real = ZEPS) = (zchop(x, eps) for x in a)
zchop(a::Tuple, eps::Real = ZEPS) = zchop.(a, eps)
zchop(x::Expr, eps::Real = ZEPS) = Expr(x.head, zchop(x.args)...)
zchop(x, eps::Real) = Base.isiterable(typeof(x)) ? map((x)->zchop(x, eps), x) : x
zchop(x) = Base.isiterable(typeof(x)) ? map(zchop, x) : x
zchop(x::Number) = x

end # module ZChop
