# Faster to not load precompiled
#  __precompile__()
module ZChop

export zchop, zchop!

const zeps = 1e-14

zchop(x::T, eps=zeps) where {T<:Real} =
    abs(x) > convert(T,eps) ? x : zero(T)

zchop(x::T, eps=zeps) where {T<:Integer} =
    abs(x) > eps ? x : zero(T)

zchop(x::T, eps=zeps) where {T<:Complex} =
    complex(zchop(real(x),eps),zchop(imag(x),eps))

zchop(a::T, eps=zeps) where {T<:AbstractArray} =
    (b = similar(a); @inbounds for i in 1:length(a) b[i] = zchop(a[i],eps) end ; b)

zchop!(a::T, eps=zeps) where {T<:AbstractArray} =
    (@inbounds for i in 1:length(a) a[i] = zchop(a[i],eps) end ; a)

zchop(x::T,eps=zeps) where {T<:Union{AbstractString,Char}} = x
zchop(x::T,eps=zeps) where {T<:Irrational} = zchop(float(x),eps)
zchop(x::Expr,eps=zeps) = Expr(x.head,zchop(x.args)...)
zchop(x,eps) =  applicable(start,x) ? map((x)->zchop(x,eps),x) : x
zchop(x) = applicable(start,x) ? map(zchop,x) : x

end # module ZChop
