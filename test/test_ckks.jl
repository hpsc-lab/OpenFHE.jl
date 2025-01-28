module TestCKKS

using Test
using OpenFHE

@testset verbose=true showtiming=true "test_ckks.jl" begin

multDepth = 1
scaleModSize = 50
scaleModSize_int128 = 71
batchSize = 8

@testset verbose=true showtiming=true "CCParams" begin
    @test_nowarn CCParams{CryptoContextCKKSRNS}()
    parameters = CCParams{CryptoContextCKKSRNS}()

    @test_nowarn SetMultiplicativeDepth(parameters, multDepth)
    @test_nowarn SetScalingModSize(parameters, scaleModSize)
    @test_nowarn SetBatchSize(parameters, batchSize)
end

@testset verbose=true showtiming=true "get_native_int" begin
    parameters = CCParams{CryptoContextCKKSRNS}()
    @test_nowarn SetScalingModSize(parameters, scaleModSize_int128)
    if get_native_int() == 128
        @test_nowarn GenCryptoContext(parameters)
    elseif get_native_int() == 64
        @test_throws "" GenCryptoContext(parameters)
    end
end

parameters = CCParams{CryptoContextCKKSRNS}()
SetMultiplicativeDepth(parameters, multDepth)
if get_native_int() == 128
    SetScalingModSize(parameters, scaleModSize_int128)
elseif get_native_int() == 64
    SetScalingModSize(parameters, scaleModSize)
end
SetBatchSize(parameters, batchSize)

@testset verbose=true showtiming=true "CryptoContext" begin
    @test_nowarn GenCryptoContext(parameters)
    cc = GenCryptoContext(parameters)

    @test_nowarn Enable(cc, PKE)
    @test_nowarn Enable(cc, KEYSWITCH)
    @test_nowarn Enable(cc, LEVELEDSHE)
    @test_nowarn Enable(cc, ADVANCEDSHE)
    @test_nowarn Enable(cc, FHE)

    @test GetRingDimension(cc) == 16384
end

cc = GenCryptoContext(parameters)
Enable(cc, PKE)
Enable(cc, KEYSWITCH)
Enable(cc, LEVELEDSHE)
Enable(cc, ADVANCEDSHE)
Enable(cc, FHE)

@testset verbose=true showtiming=true "Key generation" begin
    @test KeyGen(cc) isa KeyPair
    keys = KeyGen(cc)

    @test OpenFHE.private_key(keys) isa PrivateKey
    @test OpenFHE.public_key(keys) isa PublicKey
    @test_nowarn EvalMultKeyGen(cc, OpenFHE.private_key(keys))
    @test_nowarn EvalRotateKeyGen(cc, OpenFHE.private_key(keys), [1, -2])
    @test_nowarn EvalSumKeyGen(cc, OpenFHE.private_key(keys))
end

keys = KeyGen(cc)
privkey = OpenFHE.private_key(keys)
pubkey = OpenFHE.public_key(keys)
EvalMultKeyGen(cc, privkey)
EvalRotateKeyGen(cc, privkey, [1, -2])
EvalSumKeyGen(cc, privkey)

x1 = [0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0]
x2 = [5.0, 4.0, 3.0, 2.0, 1.0, 0.75, 0.5, 0.25]

@testset verbose=true showtiming=true "MakeCKKSPackedPlaintext" begin
    @test MakeCKKSPackedPlaintext(cc, x1) isa Plaintext
end

ptxt1 = MakeCKKSPackedPlaintext(cc, x1)
ptxt2 = MakeCKKSPackedPlaintext(cc, x2)

@testset verbose=true showtiming=true "Encrypt" begin
    @test Encrypt(cc, pubkey, ptxt1) isa Ciphertext
end

c1 = Encrypt(cc, pubkey, ptxt1)
c2 = Encrypt(cc, pubkey, ptxt2)

@testset verbose=true showtiming=true "Plaintext" begin
    @test Plaintext() isa Plaintext
end

@testset verbose=true showtiming=true "Decrypt" begin
    result = Plaintext()
    @test Decrypt(cc, privkey, c1, result) isa OpenFHE.DecryptResult
end

result = Plaintext()
Decrypt(cc, privkey, c1, result)

@testset verbose=true showtiming=true "GetRealPackedValue" begin
    @test GetRealPackedValue(result) ≈ x1
end

@testset verbose=true showtiming=true "EvalAdd" begin
    @test EvalAdd(cc, c1, c2) isa Ciphertext
    result_enc = EvalAdd(cc, c1, c2)
    result_dec = Plaintext()
    Decrypt(cc, privkey, result_enc, result_dec)
    @test GetRealPackedValue(result_dec) ≈ x1 + x2
end

@testset verbose=true showtiming=true "EvalSub" begin
    @test EvalSub(cc, c1, c2) isa Ciphertext
    result_enc = EvalSub(cc, c1, c2)
    result_dec = Plaintext()
    Decrypt(cc, privkey, result_enc, result_dec)
    @test GetRealPackedValue(result_dec) ≈ x1 - x2
end

@testset verbose=true showtiming=true "EvalMult (cipher * constant)" begin
    constant = 4.0
    @test EvalMult(cc, c1, constant) isa Ciphertext
    result_enc = EvalMult(cc, c1, constant)
    result_dec = Plaintext()
    Decrypt(cc, privkey, result_enc, result_dec)
    @test GetRealPackedValue(result_dec) ≈ x1 * constant
end

@testset verbose=true showtiming=true "EvalMult (cipher1 * cipher2)" begin
    @test EvalMult(cc, c1, c2) isa Ciphertext
    result_enc = EvalMult(cc, c1, c2)
    result_dec = Plaintext()
    Decrypt(cc, privkey, result_enc, result_dec)
    @test GetRealPackedValue(result_dec) ≈ x1 .* x2
end

@testset verbose=true showtiming=true "EvalRotate" begin
    shift = -2
    @test EvalRotate(cc, c1, shift) isa Ciphertext
    result_enc = EvalRotate(cc, c1, shift)
    result_dec = Plaintext()
    Decrypt(cc, privkey, result_enc, result_dec)
    # Note: Julia's `circshift` rotates in the opposite direction as `EvalRotate`
    @test GetRealPackedValue(result_dec) ≈ circshift(x1, -shift)
end

@testset verbose=true showtiming=true "EvalSum" begin
    @test EvalSum(cc, c1, batchSize) isa Ciphertext
    result_enc = EvalSum(cc, c1, batchSize)
    result_dec = Plaintext()
    Decrypt(cc, privkey, result_enc, result_dec)
    @test GetRealPackedValue(result_dec) ≈ [sum(x1) for _ in range(1, batchSize)]
end

@testset verbose=true showtiming=true "GetCryptoContext" begin
    @test GetCryptoContext(c1) isa CryptoContext
end

@testset verbose=true showtiming=true "GetEncodingParameters" begin
    @test GetEncodingParameters(c1) isa EncodingParams
end

@testset verbose=true showtiming=true "GetFullContextByDeserializedContext" begin
    @test GetFullContextByDeserializedContext(cc) isa CryptoContext
end

@testset verbose=true showtiming=true "GetAllContexts" begin
    @test GetAllContexts() isa
      OpenFHE.CxxWrap.CxxWrapCore.ConstCxxRef{OpenFHE.CxxWrap.StdLib.StdVector{CryptoContext{DCRTPoly}}}
end

ReleaseAllContexts()

@testset verbose=true showtiming=true "GetContextCount" begin
    @test GetContextCount() == 0
end

ClearEvalMultKeys("42")
ClearEvalMultKeys(cc)
ClearEvalMultKeys()

ClearEvalSumKeys("42")
ClearEvalSumKeys(cc)
ClearEvalSumKeys()

ClearEvalAutomorphismKeys("42")
ClearEvalAutomorphismKeys(cc)
ClearEvalAutomorphismKeys()

end # @testset "test_ckks.jl"

end # module
