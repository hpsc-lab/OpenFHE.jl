module TestBFV

using Test
using OpenFHE

# Note: Much of the basic CCParams/CryptoContext functionality is already tested in
#       test_ckks.jl.
@testset verbose=true showtiming=true "test_bfv.jl" begin

plaintext_modulus = 65537
multiplicative_depth = 2

@testset verbose=true showtiming=true "CCParams" begin
    @test_nowarn CCParams{CryptoContextBFVRNS}()
    parameters = CCParams{CryptoContextBFVRNS}()

    @test_nowarn SetPlaintextModulus(parameters, plaintext_modulus)
    @test_nowarn SetMultiplicativeDepth(parameters, multiplicative_depth)
end

parameters = CCParams{CryptoContextBFVRNS}()
SetPlaintextModulus(parameters, plaintext_modulus)
SetMultiplicativeDepth(parameters, multiplicative_depth)

cc = GenCryptoContext(parameters)
Enable(cc, PKE)
Enable(cc, KEYSWITCH)
Enable(cc, LEVELEDSHE)

keys = KeyGen(cc)
privkey = OpenFHE.private_key(keys)
pubkey = OpenFHE.public_key(keys)
EvalMultKeyGen(cc, privkey)

EvalRotateKeyGen(cc, privkey, [1, 2, -1, -2])

vectorOfInts1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
vectorOfInts2 = [3, 2, 1, 4, 5, 6, 7, 8, 9, 10, 11, 12]
vectorOfInts3 = [1, 2, 5, 2, 5, 6, 7, 8, 9, 10, 11, 12]

@testset verbose=true showtiming=true "MakePackedPlaintext" begin
    @test MakePackedPlaintext(cc, vectorOfInts1) isa Plaintext
    @test MakePackedPlaintext(cc, Int32[1, 2, 3]) isa Plaintext
end

end # @testset "test_bfv.jl"

end # module
