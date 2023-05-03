using ZChop
using Aqua: Aqua

@testset "aqua deps compat" begin
    Aqua.test_deps_compat(ZChop)
end

# This often gives false positive
@testset "aqua project toml formatting" begin
    Aqua.test_project_toml_formatting(ZChop)
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

@testset "aqua piracy" begin
    Aqua.test_piracy(ZChop)
end

@testset "aqua project extras" begin
    Aqua.test_project_extras(ZChop)
end

@testset "aqua state deps" begin
    Aqua.test_stale_deps(ZChop)
end
