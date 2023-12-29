using OpenFHE: OpenFHE

multDepth = 1
scaleModSize = 50
batchSize = 8

parameters = OpenFHE.CCParams{OpenFHE.CryptoContextCKKSRNS}()
OpenFHE.SetMultiplicativeDepth(parameters, multDepth)
OpenFHE.SetScalingModSize(parameters, scaleModSize)
OpenFHE.SetBatchSize(parameters, batchSize)

cc = OpenFHE.GenCryptoContext(parameters)
OpenFHE.Enable(cc[], OpenFHE.PKE)
OpenFHE.Enable(cc[], OpenFHE.KEYSWITCH)
OpenFHE.Enable(cc[], OpenFHE.LEVELEDSHE)
println("CKKS scheme is using ring dimension ", Int(OpenFHE.GetRingDimension(cc[])))
println()

keys = OpenFHE.KeyGen(cc[])
privkey = OpenFHE.private_key(keys)
pubkey = OpenFHE.public_key(keys)
OpenFHE.EvalMultKeyGen(cc[], privkey)

OpenFHE.EvalRotateKeyGen(cc[], privkey, [1, -2])

x1 = [0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0]
x2 = [5.0, 4.0, 3.0, 2.0, 1.0, 0.75, 0.5, 0.25]

ptxt1 = OpenFHE.MakeCKKSPackedPlaintext(cc[], x1)
ptxt2 = OpenFHE.MakeCKKSPackedPlaintext(cc[], x2)

println("Input x1: ", ptxt1)
println("Input x2: ", ptxt2)

c1 = OpenFHE.Encrypt(cc[], pubkey, ptxt1)
c2 = OpenFHE.Encrypt(cc[], pubkey, ptxt2)

cAdd = OpenFHE.EvalAdd(cc[], c1, c2);

cSub = OpenFHE.EvalSub(cc[], c1, c2);

cScalar = OpenFHE.EvalMult(cc[], c1, 4.0);

cMul = OpenFHE.EvalMult(cc[], c1, c2);

cRot1 = OpenFHE.EvalRotate(cc[], c1, 1);
cRot2 = OpenFHE.EvalRotate(cc[], c1, -2);

result = OpenFHE.Plaintext()

println()
println("Results of homomorphic computations: ")

OpenFHE.Decrypt(cc[], privkey, c1, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result[], batchSize)
print("x1 = ", result)
println("Estimated precision in bits: ", round(OpenFHE.GetLogPrecision(result[]), sigdigits=8))

OpenFHE.Decrypt(cc[], privkey, cAdd, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result[], batchSize)
print("x1 + x2 = ", result)
println("Estimated precision in bits: ", round(OpenFHE.GetLogPrecision(result[]), sigdigits=8))

OpenFHE.Decrypt(cc[], privkey, cSub, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result[], batchSize)
println("x1 - x2 = ", result)

OpenFHE.Decrypt(cc[], privkey, cScalar, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result[], batchSize)
println("4 * x1 = ", result)

OpenFHE.Decrypt(cc[], privkey, cMul, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result[], batchSize)
println("x1 * x2 = ", result)

OpenFHE.Decrypt(cc[], privkey, cRot1, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result[], batchSize)
println()
println("In rotations, very small outputs (~10^-10 here) correspond to 0's:")
println("x1 rotate by 1 = ", result)

OpenFHE.Decrypt(cc[], privkey, cRot2, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result[], batchSize)
println("x1 rotate by -2 = ", result)
