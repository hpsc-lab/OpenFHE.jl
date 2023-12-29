module OpenFHE

using CxxWrap # need to use everything to avoid `UndefVarError`s
using Preferences: @load_preference

# Load library path from preferences and wrap OpenFHE module
const openfhe_julia_library = @load_preference("openfhe_julia_library", "openfhe_julia")
@wrapmodule(() -> openfhe_julia_library)

function __init__()
    @initcxx
end


# CCParams and its functions
export CCParams, CryptoContextCKKSRNS, SetMultiplicativeDepth, SetScalingModSize,
       SetBatchSize

# CryptoContext and its functions
export GenCryptoContext, Enable, GetRingDimension, KeyGen, EvalMultKeyGen, EvalRotateKeyGen,
       MakeCKKSPackedPlaintext, Encrypt, EvalAdd, EvalSub, EvalMult, EvalRotate, Decrypt

# Plaintext and its functions
export Plaintext, SetLength, GetLogPrecision

# PKESchemeFeature
export PKESchemeFeature, PKE, KEYSWITCH, PRE, LEVELEDSHE, ADVANCEDSHE, MULTIPARTY, FHE,
       SCHEMESWITCH


function Base.show(io::IO, pt::CxxWrap.CxxWrapCore.SmartPointer{<:PlaintextImpl})
    print(io, _to_string_plaintext(pt))
end

# Convenience methods to avoid having to dereference smart pointers
for (WrappedT, fun) in [
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
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.PlaintextImpl}) => :SetLength,
    :(CxxWrap.StdLib.SharedPtrAllocated{OpenFHE.PlaintextImpl}) => :GetLogPrecision,
]
    @eval function $fun(arg::$WrappedT, args...)
        $fun(arg[], args...)
    end
end

end # module OpenFHE
