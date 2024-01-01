module TestCKKS

using Test
using OpenFHE

@testset verbose=true showtiming=true "CCParams" begin
    multDepth = 1
    scaleModSize = 50
    batchSize = 8

    @test_nowarn CCParams{CryptoContextCKKSRNS}()
    parameters = CCParams{CryptoContextCKKSRNS}()

    @test_nowarn SetMultiplicativeDepth(parameters, multDepth)

    @test_nowarn SetScalingModSize(parameters, scaleModSize)

    @test_nowarn SetBatchSize(parameters, batchSize)
end

end # module
