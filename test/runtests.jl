using Test

@time @testset verbose=true showtiming=true "OpenFHE.jl tests" begin
    include("test_auxiliary.jl")
    include("test_bfv.jl")
    include("test_bgv.jl")
    include("test_ckks.jl")
    include("test_convenience.jl")
    include("test_examples.jl")
end

