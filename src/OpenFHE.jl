module OpenFHE

using CxxWrap # need to use everything to avoid `UndefVarError`s
using Preferences: @load_preference, set_preferences!, delete_preferences!
using UUIDs: UUID
using openfhe_julia_jll: libopenfhe_julia


# Load library path from preferences and wrap OpenFHE module
const libopenfhe_julia_path = @load_preference("libopenfhe_julia", libopenfhe_julia)
@wrapmodule(() -> libopenfhe_julia_path)

function __init__()
    @initcxx
end

# Export OpenFHE functionality
# Note: Not all types are exported that have been wrapped by CxxWrap.jl, but mostly those
# that a user can actually create using a constructor. This is subject to change in the
# future.

# DCRTPoly
export DCRTPoly

# CCParams
export CCParams, CryptoContextBFVRNS, CryptoContextCKKSRNS
export GetPlaintextModulus, GetDigitSize, GetStandardDeviation, GetSecretKeyDist,
       GetMaxRelinSkDeg, GetNoiseEstimate, GetDesiredPrecision, GetStatisticalSecurity,
       GetNumAdversarialQueries, GetThresholdNumOfParties, GetKeySwitchTechnique,
       GetScalingTechnique, GetBatchSize, GetFirstModSize, GetNumLargeDigits,
       GetMultiplicativeDepth, GetScalingModSize, GetSecurityLevel, GetRingDim,
       GetEvalAddCount, GetKeySwitchCount, GetMultiHopModSize,
       SetPlaintextModulus, SetDigitSize, SetStandardDeviation, SetSecretKeyDist,
       SetMaxRelinSkDeg, SetNoiseEstimate, SetDesiredPrecision, SetStatisticalSecurity,
       SetNumAdversarialQueries, SetThresholdNumOfParties, SetKeySwitchTechnique,
       SetScalingTechnique, SetBatchSize, SetFirstModSize, SetNumLargeDigits,
       SetMultiplicativeDepth, SetScalingModSize, SetSecurityLevel, SetRingDim,
       SetEvalAddCount, SetKeySwitchCount, SetMultiHopModSize

# FHECKKSRNS
export GetBootstrapDepth

# EncodingParams
export EncodingParams
export GetPlaintextModulus, SetPlaintextModulus, GetPlaintextRootOfUnity,
       SetPlaintextRootOfUnity, GetPlaintextBigModulus, SetPlaintextBigModulus,
       GetPlaintextBigRootOfUnity, SetPlaintextBigRootOfUnity, GetPlaintextGenerator,
       SetPlaintextGenerator, GetBatchSize, SetBatchSize

# CryptoObject
export GetCryptoContext

# CryptoContext
export CryptoContext
export GenCryptoContext, Enable, GetKeyGenLevel, SetKeyGenLevel, GetEncodingParams,
       GetCyclotomicOrder, GetModulus, GetRingDimension, GetRootOfUnity, KeyGen,
       MakePackedPlaintext, MakeCKKSPackedPlaintext, Encrypt, Decrypt, EvalNegate, EvalAdd,
       EvalSub, EvalMultKeyGen, EvalMult, EvalSquare, EvalMultNoRelin, Relinearize,
       RelinearizeInPlace, EvalRotate, EvalRotateKeyGen, ComposedEvalMult, Rescale,
       RescaleInPlace, ModReduce, ModReduceInPlace, EvalSin, EvalCos, EvalLogistic,
       EvalDivide, EvalSumKeyGen, EvalSum, EvalBootstrapSetup, EvalBootstrapKeyGen,
       EvalBootstrap

# Plaintext
export Plaintext
export GetScalingFactor, SetScalingFactor, IsEncoded, GetElementRingDimension,
       GetLength, SetLength, GetNoiseScaleDeg, SetNoiseScaleDeg, GetLevel, SetLevel,
       GetSlots, SetSlots, GetLogError, GetLogPrecision, GetStringValue,
       GetCoefPackedValue, GetPackedValue, GetRealPackedValue

# Ciphertext
export Ciphertext
export GetNoiseScaleDeg, SetNoiseScaleDeg, GetLevel, SetLevel, GetHopLevel, SetHopLevel,
       GetScalingFactor, SetScalingFactor, GetSlots, SetSlots, Clone, CloneZero

# KeyPair
export KeyPair

# PublicKey
export PublicKey

# PrivateKey
export PrivateKey

# Enums
export PKESchemeFeature, PKE, KEYSWITCH, PRE, LEVELEDSHE, ADVANCEDSHE, MULTIPARTY, FHE,
       SCHEMESWITCH
export KeySwitchTechnique, INVALID_KS_TECH, BV, HYBRID
export ScalingTechnique, FIXEDMANUAL, FIXEDAUTO, FLEXIBLEAUTO, FLEXIBLEAUTOEXT, NORESCALE,
       INVALID_RS_TECHNIQUE
export SecretKeyDist, GAUSSIAN, UNIFORM_TERNARY, SPARSE_TERNARY
export SecurityLevel, HEStd_128_classic, HEStd_192_classic, HEStd_256_classic,
       HEStd_128_quantum, HEStd_192_quantum, HEStd_256_quantum, HEStd_NotSet


include("auxiliary.jl")
include("convenience.jl")
include("documentation.jl")

end # module OpenFHE
