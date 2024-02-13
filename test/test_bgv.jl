module TestBGV

using Test
using OpenFHE

# Note: Much of the basic CCParams/CryptoContext functionality is already tested in
#       test_ckks.jl and test_bfv.jl.
@testset verbose=true showtiming=true "test_bgv.jl" begin

plaintext_modulus = 65537
multiplicative_depth = 2

@testset verbose=true showtiming=true "CCParams" begin
    @test_nowarn CCParams{CryptoContextBGVRNS}()
    parameters = CCParams{CryptoContextBGVRNS}()

    @test_nowarn SetPlaintextModulus(parameters, plaintext_modulus)
    @test_nowarn SetMultiplicativeDepth(parameters, multiplicative_depth)
end

end # @testset "test_bgv.jl"

end # module
