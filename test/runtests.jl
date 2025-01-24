using Test, Pkg
# rebuild packages to ensure the change in NATIVEINT
Pkg.build()

@time @testset verbose=true showtiming=true "OpenFHE.jl tests" begin
    include("test_auxiliary.jl")
    include("test_bfv.jl")
    include("test_bgv.jl")
    include("test_ckks.jl")
    include("test_convenience.jl")
    include("test_examples.jl")
end

# set NATIVEINT = 128 for the next run
using OpenFHE
OpenFHE.set_native_int!(128)
# exit julia to reenter
exit()
