using OpenFHE

plaintext_modulus = 65537
multiplicative_depth = 2

parameters = CCParams{CryptoContextCKKSRNS}()
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

vectorOfInts1 = Int64[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
plaintext1 = OpenFHE.MakePackedPlaintext(cc, vectorOfInts1)
vectorOfInts2 = Int64[3, 2, 1, 4, 5, 6, 7, 8, 9, 10, 11, 12]
plaintext2 = OpenFHE.MakePackedPlaintext(cc, vectorOfInts2)
vectorOfInts3 = Int64[1, 2, 5, 2, 5, 6, 7, 8, 9, 10, 11, 12]
plaintext3 = OpenFHE.MakePackedPlaintext(cc, vectorOfInts3)

ct1 = Encrypt(cc, pubkey, plaintext1)
ct2 = Encrypt(cc, pubkey, plaintext2)
ct3 = Encrypt(cc, pubkey, plaintext3)

ct_add12 = EvalAdd(cc, ct1, ct2);
ct_add_result = EvalAdd(cc, ct_add12, ct3);

ct_mult12 = EvalMult(cc, ct1, ct2);
ct_mult_result = EvalMult(cc, ct_mult12, ct3);

ct_rot1 = EvalRotate(cc, ct1, 1);
ct_rot2 = EvalRotate(cc, ct1, 2);
ct_rot3 = EvalRotate(cc, ct1, -1);
ct_rot4 = EvalRotate(cc, ct1, -2);

pt_add_result = Plaintext()
Decrypt(cc, privkey, ct_add_result, pt_add_result)

pt_mult_result = Plaintext()
Decrypt(cc, privkey, ct_mult_result, pt_mult_result)

pt_rot1 = Plaintext()
Decrypt(cc, privkey, ct_rot1, pt_rot1)
pt_rot2 = Plaintext()
Decrypt(cc, privkey, ct_rot2, pt_rot2)
pt_rot3 = Plaintext()
Decrypt(cc, privkey, ct_rot3, pt_rot3)
pt_rot4 = Plaintext()
Decrypt(cc, privkey, ct_rot4, pt_rot4)

SetLength(pt_rot1, length(vectorOfInts1)
SetLength(pt_rot2, length(vectorOfInts1)
SetLength(pt_rot3, length(vectorOfInts1)
SetLength(pt_rot4, length(vectorOfInts1)

print("Plaintext #1: ", plaintext1)
print("Plaintext #2: ", plaintext2)
print("Plaintext #3: ", plaintext3)

println()
println("Results of homomorphic computations")
print("#1 + #2 + #3: ", pt_add_result)
print("#1 * #2 * #3: ", pt_mult_result)
print("Left rotation of #1 by 1: ", pt_rot1)
print("Left rotation of #1 by 2: ", pt_rot2)
print("Right rotation of #1 by 1: ", pt_rot3)
print("Right rotation of #1 by 2: ", pt_rot4)




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
