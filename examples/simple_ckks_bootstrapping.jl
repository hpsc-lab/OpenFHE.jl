using OpenFHE

parameters = CCParams{CryptoContextCKKSRNS}()

secret_key_distribution = UNIFORM_TERNARY
SetSecretKeyDist(parameters, secret_key_distribution)

SetSecurityLevel(parameters, HEStd_NotSet)
SetRingDim(parameters, 1 << 12)

rescale_technique = FLEXIBLEAUTO
dcrt_bits = 59;
first_modulus = 60;

SetScalingModSize(parameters, dcrt_bits)
SetScalingTechnique(parameters, rescale_technique)
SetFirstModSize(parameters, first_modulus)

level_budget = [4, 4]

levels_available_after_bootstrap = 10
depth = levels_available_after_bootstrap + GetBootstrapDepth(level_budget, secret_key_distribution)
SetMultiplicativeDepth(parameters, depth)

cc = GenCryptoContext(parameters)

Enable(cc, PKE)
Enable(cc, KEYSWITCH)
Enable(cc, LEVELEDSHE)
Enable(cc, ADVANCEDSHE)
Enable(cc, FHE)

ring_dimension = GetRingDimension(cc)
# This is the maximum number of slots that can be used for full packing.
num_slots = div(ring_dimension,  2)
println("CKKS scheme is using ring dimension ", ring_dimension)
println()

EvalBootstrapSetup(cc; level_budget)

key_pair = KeyGen(cc)
pubkey = OpenFHE.public_key(key_pair)
privkey = OpenFHE.private_key(key_pair)
EvalMultKeyGen(cc, privkey);
EvalBootstrapKeyGen(cc, privkey, num_slots);

x = [0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0]
encoded_length = length(x)

# We start with a depleted ciphertext that has used up all of its levels.
ptxt = MakeCKKSPackedPlaintext(cc, x; scale_degree = 1, level = depth - 1)

SetLength(ptxt, encoded_length)
println("Input: ", ptxt)

ciphertext = Encrypt(cc, pubkey, ptxt)

println("Initial number of levels remaining: ", depth - GetLevel(ciphertext))

# Perform the bootstrapping operation. The goal is to increase the number of levels
# remaining for HE computation.
ciphertext_after = EvalBootstrap(cc, ciphertext)

println("Number of levels remaining after bootstrapping: ", depth - GetLevel(ciphertext_after))
println()

result = Plaintext()
Decrypt(cc, privkey, ciphertext_after, result);
SetLength(result, encoded_length)
println("Output after bootstrapping \n\t", result)
