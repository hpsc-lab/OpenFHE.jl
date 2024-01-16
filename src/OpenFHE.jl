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
export CCParams, CryptoContextCKKSRNS
export SetMultiplicativeDepth, SetScalingModSize, SetBatchSize, SetSecretKeyDist,
       SetSecurityLevel, SetRingDim, SetScalingTechnique, SetFirstModSize,
       SetNumLargeDigits, SetKeySwitchTechnique

# FHECKKSRNS
export GetBootstrapDepth

# CryptoObject
export GetCryptoContext

# CryptoContext
export CryptoContext, GenCryptoContext, Enable, GetRingDimension, KeyGen, EvalMultKeyGen,
       EvalRotateKeyGen, MakeCKKSPackedPlaintext, Encrypt, EvalAdd, EvalSub, EvalMult,
       EvalRotate, Decrypt, EvalBootstrapSetup, EvalBootstrapKeyGen, EvalBootstrap

# Plaintext
export Plaintext
export SetLength, GetLogPrecision, GetRealPackedValue

# Ciphertext
export Ciphertext
export GetLevel

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
