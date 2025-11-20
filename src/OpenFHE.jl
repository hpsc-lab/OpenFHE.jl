module OpenFHE

using CxxWrap # need to use everything to avoid `UndefVarError`s
using Preferences: @has_preference, @load_preference, set_preferences!, @set_preferences!, delete_preferences!
using UUIDs: UUID


# Load library path from preferences or JLL package and wrap OpenFHE module
# Note: We hide loading the JLL package behind the preferences check since otherwise
#       we will not be able to test new versions of `libopenfhe_julia` that require an
#       incompatible version of `libcxxwrap_julia`
# xref: https://github.com/hpsc-lab/OpenFHE.jl/issues/46
if @has_preference("libopenfhe_julia")
    const libopenfhe_julia_path = @load_preference("libopenfhe_julia")
else
    native_int = 64
    if @has_preference("native_int")
        native_int = @load_preference("native_int")
    end
    if native_int == 64
        using openfhe_julia_jll: libopenfhe_julia
    elseif native_int == 128
        using openfhe_julia_int128_jll: libopenfhe_julia
    else
        throw(ErrorException("Unsupported value `native_int` = '$native_int' loaded from LocalPreferences.toml (must be `64` or `128`)"))
    end
    const libopenfhe_julia_path = libopenfhe_julia
end
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
export CCParams, CryptoContextBFVRNS, CryptoContextBGVRNS, CryptoContextCKKSRNS
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
export GetCryptoContext, GetEncodingParameters

# CryptoContext
export CryptoContext
export GenCryptoContext, Enable, GetKeyGenLevel, SetKeyGenLevel, GetEncodingParams,
       GetCyclotomicOrder, GetModulus, GetRingDimension, GetRootOfUnity, KeyGen,
       MakePackedPlaintext, MakeCKKSPackedPlaintext, Encrypt, Decrypt, EvalNegate, EvalAdd,
       EvalSub, EvalMultKeyGen, ClearEvalMultKeys, EvalMult, EvalSquare, EvalMultNoRelin,
       Relinearize, RelinearizeInPlace, EvalRotate, EvalRotateKeyGen, ComposedEvalMult, Rescale,
       RescaleInPlace, ModReduce, ModReduceInPlace, EvalSin, EvalCos, EvalLogistic,
       EvalDivide, EvalSumKeyGen, ClearEvalSumKeys, EvalSum, EvalBootstrapSetup, EvalBootstrapKeyGen,
       ClearEvalAutomorphismKeys, EvalBootstrap, Compress

# CryptoContextFactory
export CryptoContextFactory
export ReleaseAllContexts, GetContextCount, GetFullContextByDeserializedContext, GetAllContexts

# Plaintext
export Plaintext
export GetScalingFactor, SetScalingFactor, IsEncoded, GetEncodingParams, GetElementRingDimension,
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

# Export the Compress overloads defined in convenience.jl again
export Compress

end # module OpenFHE
