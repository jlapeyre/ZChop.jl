using ZChop
using Aqua: Aqua

@testset "aqua deps compat" begin
    Aqua.test_deps_compat(ZChop)
end

@testset "aqua unbound_args" begin
    Aqua.test_unbound_args(ZChop)
end

@testset "aqua undefined exports" begin
    Aqua.test_undefined_exports(ZChop)
end

# Perhaps some of these should be fixed. Some are for combinations of types
# that make no sense.
@testset "aqua test ambiguities" begin
    Aqua.test_ambiguities([ZChop, Core, Base])
end

@testset "aqua piracies" begin
    Aqua.test_piracies(ZChop)
end

@testset "aqua project extras" begin
    Aqua.test_project_extras(ZChop)
end

@testset "aqua state deps" begin
    Aqua.test_stale_deps(ZChop)
end
