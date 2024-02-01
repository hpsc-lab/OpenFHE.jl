module TestConvenience

using Test
using OpenFHE

@testset verbose=true showtiming=true "test_convenience.jl" begin

@testset verbose=true showtiming=true "show" begin
    @test_nowarn show(CCParams{CryptoContextCKKSRNS}())
    println()

    @test_nowarn show(CryptoContextCKKSRNS())
    println()

    @test_nowarn show(CryptoContext{DCRTPoly}())
    println()

    @test_nowarn show(Ciphertext{DCRTPoly}())
    println()

    @test_nowarn show(Plaintext())
    println()

    @test_nowarn show(PublicKey{DCRTPoly}())
    println()

    @test_nowarn show(PrivateKey{DCRTPoly}())
    println()

    @test_nowarn show(DecryptResult())
    println()

    @test_nowarn show(EncodingParams())
    println()
end

end # @testset "test_convenience.jl"

end # module
