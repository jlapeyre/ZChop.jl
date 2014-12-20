module ZChop

export zchop, zchop!

const zeps = 1e-14
zchop{T<:Real}(x::T, eps=zeps) = abs(x) > convert(T,eps) ? x : zero(T)
zchop{T<:Integer}(x::T, eps=zeps) = abs(x) > eps ? x : zero(T)
zchop{T<:Complex}(x::T, eps=zeps) = complex(zchop(real(x),eps),zchop(imag(x),eps))
zchop(a::AbstractArray, eps=zeps) = (b = similar(a); for i in 1:length(a) b[i] = zchop(a[i],eps) end ; b)
zchop!(a::AbstractArray, eps=zeps) = (for i in 1:length(a) a[i] = zchop(a[i],eps) end ; a)
zchop(x::Union(String,Char),eps=zeps) = x
zchop(x::MathConst,eps=zeps) = zchop(float(x),eps)
zchop(x::Expr,eps=zeps) = Expr(x.head,zchop(x.args)...)
zchop(x,eps=zeps) =  applicable(start,x) ? map((x)->zchop(x,eps),x) : x

end # module ZChop
