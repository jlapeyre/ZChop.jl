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
