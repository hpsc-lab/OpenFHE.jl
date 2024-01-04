using OpenFHE

multDepth = 1
scaleModSize = 50
batchSize = 8

parameters = CCParams{CryptoContextCKKSRNS}()
SetMultiplicativeDepth(parameters, multDepth)
SetScalingModSize(parameters, scaleModSize)
SetBatchSize(parameters, batchSize)

cc = GenCryptoContext(parameters)
Enable(cc, PKE)
Enable(cc, KEYSWITCH)
Enable(cc, LEVELEDSHE)
println("CKKS scheme is using ring dimension ", Int(GetRingDimension(cc)))
println()

keys = KeyGen(cc)
privkey = OpenFHE.private_key(keys)
pubkey = OpenFHE.public_key(keys)
EvalMultKeyGen(cc, privkey)

EvalRotateKeyGen(cc, privkey, [1, -2])

x1 = [0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0]
x2 = [5.0, 4.0, 3.0, 2.0, 1.0, 0.75, 0.5, 0.25]

ptxt1 = MakeCKKSPackedPlaintext(cc, x1)
ptxt2 = MakeCKKSPackedPlaintext(cc, x2)

println("Input x1: ", ptxt1)
println("Input x2: ", ptxt2)

c1 = Encrypt(cc, pubkey, ptxt1)
c2 = Encrypt(cc, pubkey, ptxt2)

cAdd = EvalAdd(cc, c1, c2);

cSub = EvalSub(cc, c1, c2);

cScalar = EvalMult(cc, c1, 4.0);

cMul = EvalMult(cc, c1, c2);

cRot1 = EvalRotate(cc, c1, 1);
cRot2 = EvalRotate(cc, c1, -2);

result = Plaintext()

println()
println("Results of homomorphic computations: ")

Decrypt(cc, privkey, c1, result)
SetLength(result, batchSize)
print("x1 = ", result)
println("Estimated precision in bits: ", round(GetLogPrecision(result), sigdigits=8))

Decrypt(cc, privkey, cAdd, result)
SetLength(result, batchSize)
print("x1 + x2 = ", result)
println("Estimated precision in bits: ", round(GetLogPrecision(result), sigdigits=8))

Decrypt(cc, privkey, cSub, result)
SetLength(result, batchSize)
println("x1 - x2 = ", result)

Decrypt(cc, privkey, cScalar, result)
SetLength(result, batchSize)
println("4 * x1 = ", result)

Decrypt(cc, privkey, cMul, result)
SetLength(result, batchSize)
println("x1 * x2 = ", result)

Decrypt(cc, privkey, cRot1, result)
SetLength(result, batchSize)
println()
println("In rotations, very small outputs (~10^-10 here) correspond to 0's:")
println("x1 rotate by 1 = ", result)

Decrypt(cc, privkey, cRot2, result)
SetLength(result, batchSize)
println("x1 rotate by -2 = ", result)
