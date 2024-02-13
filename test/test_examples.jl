module TestExamples

using Test
using OpenFHE

@testset verbose=true showtiming=true "test_examples.jl" begin

@testset verbose=true showtiming=true "examples/simple_integers.jl" begin
    @test_nowarn include("../examples/simple_integers.jl")
end

@testset verbose=true showtiming=true "examples/simple_integers_bgvrns.jl" begin
    @test_nowarn include("../examples/simple_integers_bgvrns.jl")
end

@testset verbose=true showtiming=true "examples/simple_real_numbers.jl" begin
    @test_nowarn include("../examples/simple_real_numbers.jl")
end

@testset verbose=true showtiming=true "examples/simple_ckks_bootstrapping.jl" begin
    @test_nowarn include("../examples/simple_ckks_bootstrapping.jl")
end

end # @testset "test_examples.jl"

end # module
