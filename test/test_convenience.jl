module TestConvenience

using Test
using OpenFHE

@testset verbose=true showtiming=true "test_convenience.jl" begin

@testset verbose=true showtiming=true "show" begin
    show(CCParams{CryptoContextCKKSRNS}())
    println()

    show(CryptoContextCKKSRNS())
    println()

    show(CryptoContext{DCRTPoly}())
    println()

    show(Ciphertext{DCRTPoly}())
    println()

    show(Plaintext())
    println()

    show(PublicKey{DCRTPoly}())
    println()

    show(PrivateKey{DCRTPoly}())
    println()
end

end # @testset "test_convenience.jl"

end # module
