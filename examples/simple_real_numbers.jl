using OpenFHE

multiplicative_depth = 1
scaling_modulus = 50
batch_size = 8

parameters = CCParams{CryptoContextCKKSRNS}()
SetMultiplicativeDepth(parameters, multiplicative_depth)
SetScalingModSize(parameters, scaling_modulus)
SetBatchSize(parameters, batch_size)

cc = GenCryptoContext(parameters)
Enable(cc, PKE)
Enable(cc, KEYSWITCH)
Enable(cc, LEVELEDSHE)
println("CKKS scheme is using ring dimension ", GetRingDimension(cc))
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

ct_add = EvalAdd(cc, c1, c2);

ct_sub = EvalSub(cc, c1, c2);

ct_scalar = EvalMult(cc, c1, 4.0);

ct_mult = EvalMult(cc, c1, c2);

ct_rot1 = EvalRotate(cc, c1, 1);
ct_rot2 = EvalRotate(cc, c1, -2);

result = Plaintext()

println()
println("Results of homomorphic computations: ")

Decrypt(cc, privkey, c1, result)
SetLength(result, batch_size)
print("x1 = ", result)
println("Estimated precision in bits: ", round(GetLogPrecision(result), sigdigits=8))

Decrypt(cc, privkey, ct_add, result)
SetLength(result, batch_size)
print("x1 + x2 = ", result)
println("Estimated precision in bits: ", round(GetLogPrecision(result), sigdigits=8))

Decrypt(cc, privkey, ct_sub, result)
SetLength(result, batch_size)
println("x1 - x2 = ", result)

Decrypt(cc, privkey, ct_scalar, result)
SetLength(result, batch_size)
println("4 * x1 = ", result)

Decrypt(cc, privkey, ct_mult, result)
SetLength(result, batch_size)
println("x1 * x2 = ", result)

Decrypt(cc, privkey, ct_rot1, result)
SetLength(result, batch_size)
println()
println("In rotations, very small outputs (~10^-10 here) correspond to 0's:")
println("x1 rotate by 1 = ", result)

Decrypt(cc, privkey, ct_rot2, result)
SetLength(result, batch_size)
println("x1 rotate by -2 = ", result)
