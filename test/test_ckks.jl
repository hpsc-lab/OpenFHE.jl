module TestCKKS

using Test
using OpenFHE

@testset verbose=true showtiming=true "test_ckks.jl" begin

multDepth = 1
scaleModSize = 50
batchSize = 8

@testset verbose=true showtiming=true "CCParams" begin
    @test_nowarn CCParams{CryptoContextCKKSRNS}()
    parameters = CCParams{CryptoContextCKKSRNS}()

    @test_nowarn SetMultiplicativeDepth(parameters, multDepth)
    @test_nowarn SetScalingModSize(parameters, scaleModSize)
    @test_nowarn SetBatchSize(parameters, batchSize)
end

parameters = CCParams{CryptoContextCKKSRNS}()
SetMultiplicativeDepth(parameters, multDepth)
SetScalingModSize(parameters, scaleModSize)
SetBatchSize(parameters, batchSize)

@testset verbose=true showtiming=true "CryptoContext" begin
    @test_nowarn GenCryptoContext(parameters)
    cc = GenCryptoContext(parameters)

    @test_nowarn Enable(cc, PKE)
    @test_nowarn Enable(cc, KEYSWITCH)
    @test_nowarn Enable(cc, LEVELEDSHE)

    @test GetRingDimension(cc) == 16384
end

end # @testset "test_ckks.jl"

end # module
