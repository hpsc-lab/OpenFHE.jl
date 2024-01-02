module OpenFHE

using CxxWrap # need to use everything to avoid `UndefVarError`s
using Preferences: @load_preference
using openfhe_julia_jll: libopenfhe_julia

# Load library path from preferences and wrap OpenFHE module
const openfhe_julia_library = @load_preference("openfhe_julia_library", libopenfhe_julia)
@wrapmodule(() -> openfhe_julia_library)

function __init__()
    @initcxx
end


# CCParams and its functions
export CCParams, CryptoContextCKKSRNS, SetMultiplicativeDepth, SetScalingModSize,
       SetBatchSize, SetSecretKeyDist, SetSecurityLevel, SetSecurityLevel, SetRingDim,
       SetScalingTechnique, SetFirstModSize, SetMultiplicativeDepth, SetNumLargeDigits,
       SetKeySwitchTechnique

# FHECKKSRNS
export GetBootstrapDepth

# CryptoContext and its functions
export GenCryptoContext, Enable, GetRingDimension, KeyGen, EvalMultKeyGen, EvalRotateKeyGen,
       MakeCKKSPackedPlaintext, Encrypt, EvalAdd, EvalSub, EvalMult, EvalRotate, Decrypt,
       EvalBootstrapSetup, EvalBootstrapKeyGen, EvalBootstrap

# Plaintext and its functions
export Plaintext, SetLength, GetLogPrecision

# Ciphertext and its functions
export GetLevel

# Enums
export PKESchemeFeature, PKE, KEYSWITCH, PRE, LEVELEDSHE, ADVANCEDSHE, MULTIPARTY, FHE,
       SCHEMESWITCH
export ScalingTechnique, FIXEDMANUAL, FIXEDAUTO, FLEXIBLEAUTO, FLEXIBLEAUTOEXT, NORESCALE,
       INVALID_RS_TECHNIQUE
export SecretKeyDist, GAUSSIAN, UNIFORM_TERNARY, SPARSE_TERNARY
export DistributionType, HEStd_uniform, HEStd_error, HEStd_ternary
export SecurityLevel, HEStd_128_classic, HEStd_192_classic, HEStd_256_classic,
       HEStd_128_quantum, HEStd_192_quantum, HEStd_256_quantum, HEStd_NotSet


# Convenience methods to avoid having to dereference smart pointers
for (WrappedT, fun) in [
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CiphertextImpl{OpenFHE.DCRTPoly}}) => :GetLevel,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :Enable,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :GetRingDimension,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :KeyGen,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :EvalMultKeyGen,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :EvalRotateKeyGen,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :MakeCKKSPackedPlaintext,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :Encrypt,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :EvalAdd,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :EvalSub,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :EvalMult,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :EvalRotate,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :Decrypt,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :EvalBootstrapSetup,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :EvalBootstrapKeyGen,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}}) => :EvalBootstrap,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.PlaintextImpl}) => :SetLength,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.PlaintextImpl}) => :GetLogPrecision,
]
    @eval function $fun(arg::$WrappedT, args...)
        $fun(arg[], args...)
    end
end


# Actual implementations
function Base.show(io::IO, pt::CxxWrap.CxxWrapCore.SmartPointer{<:PlaintextImpl})
    print(io, _to_string_plaintext(pt))
end


end # module OpenFHE
