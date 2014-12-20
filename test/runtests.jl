using ZChop
using Base.Test

z1 = complex(1,1e-15)
zz1 = complex(1,0.0)
z2 = complex(1e-15,1)
zz2 = complex(0.0,1)
za = [z1,z2]
zza = [zz1,zz2]

@test zchop(1.0) == 1.0
@test zchop(1e-15) == 0.0
@test zchop(z1) == zz1
@test zchop(z2) == zz2
@test zchop(za) == zza
t = (za,za)
@test zchop( t ) == (zza,zza)
@test zchop( [za za] ) == [zza zza]
@test zchop(BigFloat[1e-15,1]) == BigFloat[0,1]
@test zchop(1//10^15) == 0//1
@test zchop([1e-16,"cat"]) == [ 0.0, "cat"]
r = r"cat"
@test zchop(r) == r
@test zchop(1) == 1
@test zchop(1,3) == 0
@test zchop(Int) == Int
@test zchop([true,false]) == [true,false]
@test zchop('x') == 'x'
@test zchop(STDOUT) == STDOUT
@test zchop(Base.pi) == Base.pi
@test zchop(Base.pi,4) == 0.0
@test zchop(BigInt(1)) == BigInt(1)
@test zchop(BigInt(1),3) == BigInt(0)
m = [[1.0,2.0,1e-16] [3.0,4.0,5.0]]
@test zchop(m) == [[1.0,2.0,0.0] [3.0,4.0,5.0]]
@test zchop(:a) == :a
@test zchop(:(1+1)) == :(1+1)
@test zchop(:(1+1e-16)) == :(1+0.0)
@test zchop(:( "cat" + [1e-16,2.0] )) == :( "cat" + [0.0,2.0] )

b = [1:100] * 1e-15
c = zchop(b)
zchop!(b)
@test c == b
