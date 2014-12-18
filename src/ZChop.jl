module ZChop

export zchop

const zeps = 1e-14
zchop{T<:Real}(x::T, eps=zeps) = abs(x) > convert(T,eps) ? x : zero(T)
zchop{T<:Complex}(x::T, eps=zeps) = complex(zchop(real(x),eps),zchop(imag(x),eps))
zchop(a::AbstractArray, eps=zeps) = (b = similar(a); for i in 1:length(a)  b[i] = zchop(a[i],eps) end ; b)
zchop(x,eps=zeps) = map((x)->zchop(x,eps),x)

end # module ZChop
