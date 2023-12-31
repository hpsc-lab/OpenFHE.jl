module TestCKKS

using Test

@testset verbose=true showtiming=true "CCParams" begin
    @test_nowarn CCParams{CryptoContextCKKSRNS}()
    parameters = CCParams{CryptoContextCKKSRNS}()

    @test_nowarn SetMultiplicativeDepth(parameters, multDepth)

    @test_nowarn SetScalingModSize(parameters, scaleModSize)

    @test_nowarn SetBatchSize(parameters, batchSize)
end

end # module
