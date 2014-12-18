module ZChop

export zchop

const zchopeps = 1e-14

function zchop{T<:Real}(x::T, eps=zchopeps)
    abs(x) > eps ? x : zero(T)
end

function zchop{T<:Complex}(x::T, eps=zchopeps)
    rx = real(x)
    ix = imag(x)
    complex(zchop(rx,eps),zchop(ix,eps))
end

function zchop{T<:Number}(a::AbstractArray{T}, eps=zchopeps)
    b = similar(a)
    for i in 1:length(a)
        av = a[i]
        b[i] =  zchop(av,eps)
    end
    b
end

zchop(x,eps=zchopeps) = map((x)->zchop(x,eps),x)

end # module ZChop

