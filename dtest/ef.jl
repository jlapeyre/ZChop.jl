# Inlining calls to zchop for reals into zchop for complex
# improves efficiency in this case, by about .5 %
# Profile shows that Julia does not inline the calls.

# Julia v0.4 was not inlining the call to zchop with complex args
# forcing inline increased speed in loop by 30%

using ZChop

const zeps = 1e-14

zchop2{T<:Real}(x::T, eps=zeps) = abs(x) > convert(T,eps) ? x : zero(T)

function zchop2{T<:Real}(x::Complex{T}, eps=zeps)
    rex = real(x)
    iex = imag(x)
    rex =  abs(rex) > convert(T,eps) ? rex : zero(T)
    iex =  abs(iex) > convert(T,eps) ? iex : zero(T)
    complex(rex,iex)
end

zchop2(a::AbstractArray, eps=zeps) = (b = similar(a); for i in 1:length(a)  b[i] = zchop2(a[i],eps) end ; b)
zchop2(x,eps=zeps) = map((x)->zchop2(x,eps),x)

const n = 10^6
const z = Array(Complex{Float64},n)
for i in 1:n z[i] = complex(.1,.1) end

function testzchop()
    m = 500
    sum = 0
    for i in 1:m
        sum += @elapsed zchop(z)
    end
    println("call ", sum/m)
end

function testzchop2()
    m = 500
    sum = 0
    for i in 1:m
        sum += @elapsed zchop2(z)
    end
    println("expl ", sum/m)
end

function runalt()
    for j in 1:100
        testzchop()
        testzchop2()
    end
end

# Return a tuple of n copies of x. copy of bits that is.
# n limited to about 10^5
function mktuple(n,x)
    ex = Expr(:tuple,)
    a = ex.args
    for i in 1:n
        push!(a,x)
    end
    eval(ex)
end

true
