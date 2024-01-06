# Define CryptoContext for convenience
"""
    CryptoContext{T}

Type alias for `CxxWrap.StdLib.SharedPtr{CryptoContextImpl{T}}`.

The crypto context is the central object in OpenFHE that facilitates all essential
cryptographic operations such as key generation, encryption/decryption, arithmetic
operations on plaintexts and ciphertexts etc.

In OpenFHE, a crypto context is always created from a set of `CCParams` parameters using
`GenCryptoContext`.

See also: [`CCParams`](@ref), [`GenCryptoContext`](@ref)
"""
const CryptoContext{T} = CxxWrap.StdLib.SharedPtr{CryptoContextImpl{T}}

"""
    Ciphertext{T}

Type alias for `CxxWrap.StdLib.SharedPtr{CiphertextImpl{T}}`.

The ciphertext object holds homomorphically encrypted data that can be used for encrypted
computations. It is created either by encrypting a [`Plaintext`](@ref) object or by
performing arithmetic with existing ciphertexts.

See also: [`Plaintext`](@ref), [`Encrypt`](@ref)
"""
const Ciphertext{T} = CxxWrap.StdLib.SharedPtr{CiphertextImpl{T}}

# TODO: Define Plaintext here similarly to the CryptoContext
# const Plaintext{T} = CxxWrap.StdLib.SharedPtr{PlaintextImpl{T}}

"""
    PublicKey{T}

Type alias for `CxxWrap.StdLib.SharedPtr{PublicKeyImpl{T}}`.

Public keys can be used to encrypt [`Plaintext`](@ref) data into [`Ciphertext`](@ref)
objects. They are part of a `KeyPair` that contains both a public and a private key. Key
pairs can be created from a [`CryptoContext`](@ref) by calling [`KeyGen`](@ref).

See also: [`KeyGen`](@ref), [`KeyPair`](@ref)
"""
const PublicKey{T} = CxxWrap.StdLib.SharedPtr{PublicKeyImpl{T}}

"""
    PrivateKey{T}

Type alias for `CxxWrap.StdLib.SharedPtr{PrivateKeyImpl{T}}`.

Private keys can be used to decrypt [`Ciphertext`](@ref) data into [`Plaintext`](@ref)
objects. They are part of a `KeyPair` that contains both a public and a private key. Key
pairs can be created from a [`CryptoContext`](@ref) by calling [`KeyGen`](@ref).

See also: [`KeyGen`](@ref), [`KeyPair`](@ref)
"""
const PrivateKey{T} = CxxWrap.StdLib.SharedPtr{PrivateKeyImpl{T}}

# Convenience methods to avoid having to dereference smart pointers
for (WrappedT, fun) in [
    :(Ciphertext{DCRTPoly}) => :GetLevel,
    :(CryptoContext{DCRTPoly}) => :Enable,
    :(CryptoContext{DCRTPoly}) => :GetRingDimension,
    :(CryptoContext{DCRTPoly}) => :KeyGen,
    :(CryptoContext{DCRTPoly}) => :EvalMultKeyGen,
    :(CryptoContext{DCRTPoly}) => :EvalRotateKeyGen,
    :(CryptoContext{DCRTPoly}) => :MakeCKKSPackedPlaintext,
    :(CryptoContext{DCRTPoly}) => :Encrypt,
    :(CryptoContext{DCRTPoly}) => :EvalAdd,
    :(CryptoContext{DCRTPoly}) => :EvalSub,
    :(CryptoContext{DCRTPoly}) => :EvalMult,
    :(CryptoContext{DCRTPoly}) => :EvalRotate,
    :(CryptoContext{DCRTPoly}) => :Decrypt,
    :(CryptoContext{DCRTPoly}) => :EvalBootstrapSetup,
    :(CryptoContext{DCRTPoly}) => :EvalBootstrapKeyGen,
    :(CryptoContext{DCRTPoly}) => :EvalBootstrap,
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
    :(CryptoContext{DCRTPoly}) => "CryptoContext{DCRTPoly}()",
    :(Ciphertext{DCRTPoly}) => "Ciphertext{DCRTPoly}()",
    :(PublicKey{DCRTPoly}) => "PublicKey{DCRTPoly}()",
    :(PrivateKey{DCRTPoly}) => "PrivateKey{DCRTPoly}()",
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

