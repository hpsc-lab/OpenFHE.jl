# Convenience methods to avoid having to dereference smart pointers
for (WrappedT, fun) in [
    :(CxxWrap.StdLib.SharedPtrAllocated{CiphertextImpl{DCRTPoly}}) => :GetLevel,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :Enable,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :GetRingDimension,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :KeyGen,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :EvalMultKeyGen,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :EvalRotateKeyGen,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :MakeCKKSPackedPlaintext,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :Encrypt,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :EvalAdd,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :EvalSub,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :EvalMult,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :EvalRotate,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :Decrypt,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :EvalBootstrapSetup,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :EvalBootstrapKeyGen,
    :(CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}) => :EvalBootstrap,
    :(CxxWrap.StdLib.SharedPtrAllocated{PlaintextImpl}) => :SetLength,
    :(CxxWrap.StdLib.SharedPtrAllocated{PlaintextImpl}) => :GetLogPrecision,
]
    @eval function $fun(arg::$WrappedT, args...; kwargs...)
        $fun(arg[], args...; kwargs...)
    end
end


# Convenience `show` methods to hide wrapping-induced ugliness
for (T, str) in [
    :(CCParams{<:CryptoContextCKKSRNS}) => "CCParams{CryptoContextCKKSRNS}()",
    :(CryptoContextCKKSRNS) => "CryptoContextCKKSRNS()",
    :(CxxWrap.StdLib.SharedPtr{CryptoContextImpl{DCRTPoly}}) => "SharedPtr{CryptoContext{DCRTPoly}}()",
]
    @eval function Base.show(io::IO, ::$T)
        print(io, $str)
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

"""
    GetBootstrapDepth(level_budget::Vector{<:Integer}, secret_key_distribution::SecretKeyDist)

Compute and return the bootstrapping depth for a given `level_budget` and a
`secret_key_distribution`.

See also: [`SecretKeyDist`](@ref)
"""
function GetBootstrapDepth(level_budget::Vector{<:Integer}, secret_key_distribution)
    Int(GetBootstrapDepth(CxxWrap.StdVector(UInt32.(level_budget)), secret_key_distribution))
end


# Actual implementations
function Base.show(io::IO, pt::CxxWrap.CxxWrapCore.SmartPointer{<:PlaintextImpl})
    print(io, _to_string_plaintext(pt))
end

