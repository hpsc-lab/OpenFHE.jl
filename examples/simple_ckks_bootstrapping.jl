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
# TODO: add `GetBootstrapDepth` that accepts a Julia vector of `Int`s
# depth = levelsAvailableAfterBootstrap + GetBootstrapDepth(levelBudget, secretKeyDist)
levelBudget_ = OpenFHE.StdVector(UInt32.(levelBudget))
depth = levelsAvailableAfterBootstrap + GetBootstrapDepth(levelBudget_, secretKeyDist)
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

# TODO: add `EvalBootstrapSetup` that allow omitting the default arguments
# TODO: add `EvalBootstrapSetup` that accepts a Julia vector of `Int`s
# EvalBootstrapSetup(cryptoContext, levelBudget)
EvalBootstrapSetup(cryptoContext, levelBudget_, OpenFHE.StdVector(UInt32[1, 1]), 0, 0, true)

keyPair = KeyGen(cryptoContext)
pubkey = OpenFHE.public_key(keyPair)
privkey = OpenFHE.private_key(keyPair)
EvalMultKeyGen(cryptoContext, privkey);
EvalBootstrapKeyGen(cryptoContext, privkey, numSlots);

x = [0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0]
encodedLength = length(x)

# We start with a depleted ciphertext that has used up all of its levels.
ptxt = MakeCKKSPackedPlaintext(cryptoContext, x, 1, depth - 1)

SetLength(ptxt, encodedLength)
println("Input: ", ptxt)

ciph = Encrypt(cryptoContext, pubkey, ptxt)

println("Initial number of levels remaining: ", depth - GetLevel(ciph))

# Perform the bootstrapping operation. The goal is to increase the number of levels
# remaining for HE computation.
# TODO: Add `EvalBootstrap` that allows omitting the default arguments
# ciphertextAfter = EvalBootstrap(cryptoContext, ciph)
# FIXME: The follwoing line currently causes a segmentation fault:
ciphertextAfter = EvalBootstrap(cryptoContext, ciph, 1, 0)

println("Number of levels remaining after bootstrapping: ", depth - GetLevel(ciphertextAfter))
prinltn()

result = Plaintext()
Decrypt(cryptoContext, privkey, ciphertextAfter, OpenFHE.CxxPtr(result));
SetLength(result, encodedLength)
println("Output after bootstrapping \n\t", result)
