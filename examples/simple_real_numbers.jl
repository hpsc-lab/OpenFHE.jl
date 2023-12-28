using OpenFHE: OpenFHE

multDepth = 1
scaleModSize = 50
batchSize = 8

parameters = OpenFHE.Parameters(multDepth, scaleModSize, batchSize)
context = OpenFHE.Context(parameters)

println("CKKS scheme is using ring dimension ", Int(OpenFHE.GetRingDimension(context)))
println()

keys = OpenFHE.KeyGen(context)
privkey = OpenFHE.private_key(keys)
pubkey = OpenFHE.public_key(keys)

OpenFHE.EvalMultKeyGen(context, privkey)

OpenFHE.EvalRotateKeyGen(context, privkey, [1, -2])

x1 = [0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0]
x2 = [5.0, 4.0, 3.0, 2.0, 1.0, 0.75, 0.5, 0.25]

ptxt1 = OpenFHE.MakeCKKSPackedPlaintext(context, x1)
ptxt2 = OpenFHE.MakeCKKSPackedPlaintext(context, x2)

println("Input x1: ", ptxt1)
println("Input x2: ", ptxt2)

c1 = OpenFHE.Encrypt(context, pubkey, ptxt1)
c2 = OpenFHE.Encrypt(context, pubkey, ptxt2)

cAdd = OpenFHE.EvalAdd(context, c1, c2);

cSub = OpenFHE.EvalSub(context, c1, c2);

cScalar = OpenFHE.EvalMult(context, c1, 4.0);

cMul = OpenFHE.EvalMult(context, c1, c2);

cRot1 = OpenFHE.EvalRotate(context, c1, 1);
cRot2 = OpenFHE.EvalRotate(context, c1, -2);

result = OpenFHE.Plaintext()

println()
println("Results of homomorphic computations: ")

OpenFHE.Decrypt(context, privkey, c1, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result, batchSize)
print("x1 = ", result)
println("Estimated precision in bits: ", round(OpenFHE.GetLogPrecision(result), sigdigits=8))

OpenFHE.Decrypt(context, privkey, cAdd, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result, batchSize)
print("x1 + x2 = ", result)
println("Estimated precision in bits: ", round(OpenFHE.GetLogPrecision(result), sigdigits=8))

OpenFHE.Decrypt(context, privkey, cSub, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result, batchSize)
println("x1 - x2 = ", result)

OpenFHE.Decrypt(context, privkey, cScalar, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result, batchSize)
println("4 * x1 = ", result)

OpenFHE.Decrypt(context, privkey, cMul, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result, batchSize)
println("x1 * x2 = ", result)

OpenFHE.Decrypt(context, privkey, cRot1, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result, batchSize)
println()
println("In rotations, very small outputs (~10^-10 here) correspond to 0's:")
println("x1 rotate by 1 = ", result)

OpenFHE.Decrypt(context, privkey, cRot2, OpenFHE.CxxPtr(result))
OpenFHE.SetLength(result, batchSize)
println("x1 rotate by -2 = ", result)
