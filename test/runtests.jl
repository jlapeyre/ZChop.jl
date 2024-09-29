using ZChop
using Test

if VERSION >= v"1.7" && VERSION < v"1.11"
    include("jet_test.jl")
end

include("aqua_test.jl")
include("zchop_test.jl")
