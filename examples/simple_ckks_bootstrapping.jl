using OpenFHE

parameters = CCParams{CryptoContextCKKSRNS}()

secretKeyDist = UNIFORM_TERNARY
SetSecretKeyDist(parameters, secretKeyDist)

SetSecurityLevel(parameters, HEStd_NotSet)
SetRingDim(parameters, 1 << 12)

rescaleTech = FLEXIBLEAUTO
dcrtBits = 59;
firstMod = 60;

SetScalingModSize(parameters, dcrtBits)
SetScalingTechnique(parameters, rescaleTech)
SetFirstModSize(parameters, firstMod)

levelBudget = [4, 4]

levelsAvailableAfterBootstrap = 10
depth = levelsAvailableAfterBootstrap + GetBootstrapDepth(levelBudget, secretKeyDist)
SetMultiplicativeDepth(parameters, depth)

cryptoContext = GenCryptoContext(parameters)

Enable(cryptoContext, PKE)
Enable(cryptoContext, KEYSWITCH)
Enable(cryptoContext, LEVELEDSHE)
Enable(cryptoContext, ADVANCEDSHE)
Enable(cryptoContext, FHE)

ringDim = GetRingDimension(cryptoContext)
# This is the maximum number of slots that can be used for full packing.
numSlots = div(ringDim,  2)
println("CKKS scheme is using ring dimension ", ringDim)
println()

EvalBootstrapSetup(cryptoContext; levelBudget)

keyPair = KeyGen(cryptoContext)
pubkey = OpenFHE.public_key(keyPair)
privkey = OpenFHE.private_key(keyPair)
EvalMultKeyGen(cryptoContext, privkey);
EvalBootstrapKeyGen(cryptoContext, privkey, numSlots);

x = [0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0]
encodedLength = length(x)

# We start with a depleted ciphertext that has used up all of its levels.
ptxt = MakeCKKSPackedPlaintext(cryptoContext, x; scaleDeg = 1, level = depth - 1)

SetLength(ptxt, encodedLength)
println("Input: ", ptxt)

ciphertext = Encrypt(cryptoContext, pubkey, ptxt)

println("Initial number of levels remaining: ", depth - GetLevel(ciphertext))

# Perform the bootstrapping operation. The goal is to increase the number of levels
# remaining for HE computation.
ciphertextAfter = EvalBootstrap(cryptoContext, ciphertext)

println("Number of levels remaining after bootstrapping: ", depth - GetLevel(ciphertextAfter))
println()

result = Plaintext()
Decrypt(cryptoContext, privkey, ciphertextAfter, result);
SetLength(result, encodedLength)
println("Output after bootstrapping \n\t", result)
