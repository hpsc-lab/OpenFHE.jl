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

cryptoContext = GenCryptoContext(parameters)

Enable(cryptoContext, PKE)
Enable(cryptoContext, KEYSWITCH)
Enable(cryptoContext, LEVELEDSHE)
Enable(cryptoContext, ADVANCEDSHE)
Enable(cryptoContext, FHE)

ring_dimension = GetRingDimension(cryptoContext)
# This is the maximum number of slots that can be used for full packing.
num_slots = div(ring_dimension,  2)
println("CKKS scheme is using ring dimension ", ring_dimension)
println()

EvalBootstrapSetup(cryptoContext; level_budget)

key_pair = KeyGen(cryptoContext)
pubkey = OpenFHE.public_key(key_pair)
privkey = OpenFHE.private_key(key_pair)
EvalMultKeyGen(cryptoContext, privkey);
EvalBootstrapKeyGen(cryptoContext, privkey, num_slots);

x = [0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0]
encoded_length = length(x)

# We start with a depleted ciphertext that has used up all of its levels.
ptxt = MakeCKKSPackedPlaintext(cryptoContext, x; scale_degree = 1, level = depth - 1)

SetLength(ptxt, encoded_length)
println("Input: ", ptxt)

ciphertext = Encrypt(cryptoContext, pubkey, ptxt)

println("Initial number of levels remaining: ", depth - GetLevel(ciphertext))

# Perform the bootstrapping operation. The goal is to increase the number of levels
# remaining for HE computation.
ciphertext_after = EvalBootstrap(cryptoContext, ciphertext)

println("Number of levels remaining after bootstrapping: ", depth - GetLevel(ciphertext_after))
println()

result = Plaintext()
Decrypt(cryptoContext, privkey, ciphertext_after, result);
SetLength(result, encoded_length)
println("Output after bootstrapping \n\t", result)
