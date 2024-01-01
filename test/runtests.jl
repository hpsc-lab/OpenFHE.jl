using Test

@time @testset verbose=true showtiming=true "OpenFHE.jl tests" begin
    include("test_ckks.jl")
end

