module ZChop
using Compat
export zchop, zchop!

const zeps = 1e-14
@inline zchop{T<:Real}(x::T, eps=zeps) = abs(x) > convert(T,eps) ? x : zero(T)
@inline zchop{T<:Integer}(x::T, eps=zeps) = abs(x) > eps ? x : zero(T)
@inline zchop{T<:Complex}(x::T, eps=zeps) = complex(zchop(real(x),eps),zchop(imag(x),eps))
@inline zchop(a::AbstractArray, eps=zeps) =
        (b = similar(a); for i in 1:length(a) b[i] = zchop(a[i],eps) end ; b)
@inline zchop!(a::AbstractArray, eps=zeps) = (for i in 1:length(a) a[i] = zchop(a[i],eps) end ; a)
@inline zchop(x::Union(String,Char),eps=zeps) = x
@inline zchop(x::MathConst,eps=zeps) = zchop(float(x),eps)
zchop(x::Expr,eps=zeps) = Expr(x.head,zchop(x.args)...)
zchop(x,eps=zeps) =  applicable(start,x) ? map((x)->zchop(x,eps),x) : x
zchop(x) = applicable(start,x) ? map(zchop,x) : x

end # module ZChop
