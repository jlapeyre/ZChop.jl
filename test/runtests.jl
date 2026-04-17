using ZChop
using Test

if VERSION >= v"1.7" && VERSION < v"1.11"
    include("jet_test.jl")
end

include("zchop_test.jl")
include("aqua_test.jl")
