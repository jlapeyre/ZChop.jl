module ZChop

export zchop

const zchopeps = 1e-14

zchop{T<:Real}(x::T, eps=zchopeps) = abs(x) > convert(T,eps) ? x : zero(T)
zchop{T<:Complex}(x::T, eps=zchopeps) = complex(zchop(real(x),eps),zchop(imag(x),eps))
zchop(a::AbstractArray, eps=zchopeps) = (b = similar(a); for i in 1:length(a)  b[i] = zchop(a[i],eps) end ; b)
zchop(x,eps=zchopeps) = map((x)->zchop(x,eps),x)

end # module ZChop
