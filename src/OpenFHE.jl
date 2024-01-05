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
    @eval function $fun(arg::$WrappedT, args...; kwargs...)
        $fun(arg[], args...; kwargs...)
    end
end


# More convenience methods

# Allow passing Julia vectors and provide default arguments
function MakeCKKSPackedPlaintext(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                                 value::Vector{Float64};
                                 scaleDeg = 1,
                                 level = 0,
                                 params = OpenFHE.CxxWrap.StdLib.SharedPtr{OpenFHE.ILDCRTParams{OpenFHE.ubint{UInt64}}}(),
                                 slots = 0)
    MakeCKKSPackedPlaintext(context, CxxWrap.StdVector(value), scaleDeg, level, params, slots)
end

# Allow passing Julia vectors of arbitrary integer type and provide default arguments
function EvalRotateKeyGen(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                          privateKey,
                          indexList::Vector{<:Integer};
                          publicKey = OpenFHE.CxxWrap.StdLib.SharedPtr{OpenFHE.PublicKeyImpl{OpenFHE.DCRTPoly}}())
    EvalRotateKeyGen(context, privateKey, CxxWrap.StdVector(Int32.(indexList)), publicKey)
end

# Allow passing Julia vectors of arbitrary integer type and provide default arguments
function EvalBootstrapSetup(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}};
                            levelBudget = [5, 4],
                            dim1 = [0, 0],
                            slots = 0,
                            correctionFactor = 0,
                            precompute = true)
    EvalBootstrapSetup(context,
                       CxxWrap.StdVector(UInt32.(levelBudget)),
                       CxxWrap.StdVector(UInt32.(dim1)),
                       slots,
                       correctionFactor,
                       precompute)
end

# Provide default arguments
function EvalBootstrap(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                       ciphertext;
                       numIterations = 1,
                       precision = 0)
    EvalBootstrap(context, ciphertext, numIterations, precision)
end

# Allow passing regular Plaintext without wrapping in pointer first
function Decrypt(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                 key_or_cipher1,
                 key_or_cipher2,
                 result::CxxWrap.CxxWrapCore.SmartPointer{<:PlaintextImpl})
    Decrypt(context, key_or_cipher1, key_or_cipher2, CxxPtr(result))
end

# Allow passing Julia vectors of arbitrary integer type
function GetBootstrapDepth(levelBudget::Vector{<:Integer}, secretKeyDist)
    GetBootstrapDepth(CxxWrap.StdVector(UInt32.(levelBudget)), secretKeyDist)
end


# Actual implementations
function Base.show(io::IO, pt::CxxWrap.CxxWrapCore.SmartPointer{<:PlaintextImpl})
    print(io, _to_string_plaintext(pt))
end


const OPENFHE_PACKAGE_UUID = UUID("77ce9b8e-ecf5-45d1-bd8a-d31f384f2f95")

"""
    OpenFHE.set_library!(path = nothing; force = true)

Set the absolute `path` to a system-provided OpenFHE-julia installation, e.g., something
like `/path/to/libopenfhe_julia.<ext>`, where `<ext>` is `so` on Linux`, `dylib` on macOS,
and `dll` on Windows. Restart the Julia session after executing this function such that the
changes take effect. Using `nothing` as the path will revert the library path to the default
settings, i.e., the JLL-provided version of OpenFHE-julia will be used.
"""
function set_library!(path = nothing; force = true)
    if isnothing(path)
        delete_preferences!(OPENFHE_PACKAGE_UUID, "libopenfhe_julia"; force)
    else
        isfile(path) || throw(ArgumentError("$path is not an existing file."))
        set_preferences!(OPENFHE_PACKAGE_UUID, "libopenfhe_julia" => path; force)
    end
    @info "Please restart Julia and reload OpenFHE.jl for the library changes to take effect"
end

"""
    OpenFHE.library_path()

Return the path of the OpenFHE-julia library that is used.
"""
library_path() = libopenfhe_julia_path


end # module OpenFHE
