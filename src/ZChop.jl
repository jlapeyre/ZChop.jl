"""
The `ZChop` module provides the functions `zchop` and `zchop!`, which replace
numbers that are close to zero with zero. These functions act recursivley on
collections.
"""
module ZChop

export zchop, zchop!

"""
    zeps::Float64

The default lower threshold for a number to be replaced by zero.
"""
const zeps = 1e-14

"""
    zchop(x::T, eps::Real = zeps)

Replace `x` by zero if `abs(x) < eps`. `zchop` acts recursively on
mappable objects. Objects that cannot be sensibly compared to a real
number are passed unaltered.
"""
zchop(x::Real, eps::Real = zeps) = abs(x) > eps ? x : zero(typeof(x))
zchop(x::Complex, eps::Real = zeps) = complex(zchop(real(x), eps), zchop(imag(x), eps))
# Following is not type stable
zchop(x::Irrational, eps::Real = zeps) = zchop(float(x), eps)
# Do not iterate over strings
zchop(x::Union{AbstractString,AbstractChar}, eps::Real = zeps) = x

"""
    zchop!(x::T, eps::Real = zeps)

Perform `zchop` in place.
"""
function zchop!(a::AbstractArray, eps::Real = zeps)
    @inbounds for i in firstindex(a):lastindex(a)
        a[i] = zchop(a[i], eps)
    end
    return a
end

zchop(a::AbstractArray, eps::Real = zeps) = zchop!(copy(a), eps)
zchop(a::Base.Generator, eps::Real = zeps) = zchop!(collect(a), eps)
zchop(a::Tuple, eps::Real = zeps) = zchop.(a, eps)
zchop(x::Expr, eps::Real = zeps) = Expr(x.head, zchop(x.args)...)
zchop(x, eps::Real) = Base.isiterable(typeof(x)) ? map((x)->zchop(x, eps), x) : x
zchop(x) = Base.isiterable(typeof(x)) ? map(zchop, x) : x
zchop(x::Number) = x

end # module ZChop
