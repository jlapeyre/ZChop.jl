using ZChop
using Test

@testset "basic" begin
    @test zchop(1.0) == 1.0
    @test zchop(1e-15) == 0.0
    @test zchop(1) == 1
    @test zchop(1, 3) == 0
end

@testset "complex" begin
    z1 = complex(1, 1e-15)
    zz1 = complex(1, 0.0)
    @test zchop(z1) == zz1

    z2 = complex(1e-15, 1)
    zz2 = complex(0.0, 1)
    @test zchop(z2) == zz2

    za = [z1, z2]
    zza = [zz1, zz2]
    @test zchop(za) == zza
    t = (za, za)
    @test zchop(t) == (zza, zza)
    @test zchop([za za]) == [zza zza]
end

@testset "big" begin
    @test zchop(BigFloat[1e-15, 1]) == BigFloat[0, 1]
    if Int != Int32 @test zchop(1//10^15) == 0//1 end
    @test zchop(BigInt(1)) == BigInt(1)
    @test zchop(BigInt(1), 3) == BigInt(0)
end

@testset "misc types" begin
    r = r"cat"
    @test zchop(r) == r
    @test zchop(Int) == Int
    @test zchop([true, false]) == [true, false]
    @test zchop('x') == 'x'
    # deepcopy(stdout) != stdout, so we can't test zchop this way here
    @test zchop!(stdout) == stdout
    @test zchop(Base.pi) == float(Base.pi)
    @test zchop(Base.pi, 4) == 0.0
    @test zchop(:a) == :a
    @test zchop(:(1+1)) == :(1+1)
    @test zchop(:(1+1e-16)) == :(1+0.0)
end

@testset "collections" begin
    @test zchop([1e-16, "cat"]) == [0.0, "cat"]
    m = [[1.0, 2.0, 1e-16] [3.0, 4.0, 5.0]]
    @test zchop(m) == [[1.0, 2.0, 0.0] [3.0, 4.0, 5.0]]
    @test zchop(:("cat" + [1e-16, 2.0])) == :("cat" + [0.0, 2.0])
    b = collect(1:5) * 1e-15
    c = zchop(b)
    zchop!(b)
    @test c == b
    d = (m[:, 1]...,)
    @test zchop(d) == (1.0, 2.0, 0.0)
    @test isa(zchop(d), Tuple)
    @test isa(zchop((x for x in d)), Base.Generator)
    @test (zchop((x for x in d))...,) == zchop(d)
end

struct NumberSubtype <: Number
end

@testset "Number" begin
    x = NumberSubtype()
    @test x === zchop!(x)
    @test x == zchop(x)
end

@testset "error" begin
    @test zchop((1e-15, 1, 1)) == (0.0, 1, 1)
    @test_throws MethodError zchop()
end

@testset "nested arrays" begin
    x = [1e-15, 2.0]
    y = [2e-16, 3.0]
    m = [x, y]

    x1 = [0.0, 2.0]
    y1 = [0.0, 3.0]
    m1 = [x1, y1]

    zchop!(m)
    @test x == x1
    @test y == y1
    @test m == m1

    x = [1e-15, 2.0]
    y = [2e-16, 3.0]
    m = [x, y]
    zchop(m)
    @test x != x1
    @test y != y1
    @test m != m1
end

@testset "array in tuple" begin
    x = [1e-15, 2.0]
    y = [2e-16, 3.0]
    m = (x, y)
    x1 = [0.0, 2.0]
    y1 = [0.0, 3.0]
    m1 = (x1, y1)
    zchop!(m)
    @test x == x1
    @test y == y1
    @test m == m1
end

@testset "nchop basic" begin
    @test nchop(1.0) == 1.0
    @test nchop(1.0 + 1e-16) == 1.0
    @test nchop(1e-16) == 0.0
    @test nchop((1., 2., 3. + 1e-16)) == (1., 2., 3.)
end

@testset "nchop nested mutation" begin
    x = [1.0 + 1e-15, 2.0 - 1e-16]
    y = [1e4 + 1e-15, 3e4 - 1e-16]
    m = [x, y]

    x1 = [1.0, 2.0]
    y1 = [1e4, 3e4]
    m1 = [x1, y1]

    @test nchop(m) == m1
    @test m != m1

    @test nchop!(m) == m1
    @test m == m1
end

@testset "nchop exotic" begin
    @test nchop(:(1 + 2.000000000000001)) == :(1.0 + 2.0)
    gen = nchop(i + 1e-15 for i in 1:3)
    @test isa(gen, Base.Generator)
    @test collect(gen) == [1., 2., 3.]
end

@testset "nchop Number" begin
    x = NumberSubtype()
    @test x == nchop(x)
    @test x === nchop!(x)
end

@testset "nchop fractional" begin
    x = 0.34950394582398472374294723
    @test nchop(x; digits=3) == 0.35
    @test nchop(x; digits=4) == 0.3495
end

@testset "Dict" begin
    d = Dict(0 => 1e-15, 1 => 1e-8)
    @test zchop(d) == Dict(0 => 0.0, 1 => 1e-8)
end
