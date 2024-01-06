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


# CCParams and its functions
export CCParams, CryptoContextCKKSRNS
export SetMultiplicativeDepth, SetScalingModSize, SetBatchSize, SetSecretKeyDist,
       SetSecurityLevel, SetRingDim, SetScalingTechnique, SetFirstModSize,
       SetNumLargeDigits, SetKeySwitchTechnique

# FHECKKSRNS
export GetBootstrapDepth

# CryptoContext and its functions
export GenCryptoContext, Enable, GetRingDimension, KeyGen, EvalMultKeyGen, EvalRotateKeyGen,
       MakeCKKSPackedPlaintext, Encrypt, EvalAdd, EvalSub, EvalMult, EvalRotate, Decrypt,
       EvalBootstrapSetup, EvalBootstrapKeyGen, EvalBootstrap

# Plaintext and its functions
export Plaintext
export SetLength, GetLogPrecision

# Ciphertext and its functions
export GetLevel

# Enums
export PKESchemeFeature, PKE, KEYSWITCH, PRE, LEVELEDSHE, ADVANCEDSHE, MULTIPARTY, FHE,
       SCHEMESWITCH
export KeySwitchTechnique, INVALID_KS_TECH, BV, HYBRID
export ScalingTechnique, FIXEDMANUAL, FIXEDAUTO, FLEXIBLEAUTO, FLEXIBLEAUTOEXT, NORESCALE,
       INVALID_RS_TECHNIQUE
export SecretKeyDist, GAUSSIAN, UNIFORM_TERNARY, SPARSE_TERNARY
export DistributionType, HEStd_uniform, HEStd_error, HEStd_ternary
export SecurityLevel, HEStd_128_classic, HEStd_192_classic, HEStd_256_classic,
       HEStd_128_quantum, HEStd_192_quantum, HEStd_256_quantum, HEStd_NotSet


include("auxiliary.jl")
include("convenience.jl")
include("documentation.jl")

end # module OpenFHE
