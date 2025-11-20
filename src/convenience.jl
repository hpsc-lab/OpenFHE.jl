"""
    EncodingParams

Type alias for `CxxWrap.StdLib.SharedPtr{EncodingParamsImpl}`.

The `EncodingParams` store the parameters for encoding. These parameters are kept with
multiple OpenFHE objects and are continually reused during the encoding of new values.
"""
const EncodingParams = CxxWrap.StdLib.SharedPtr{EncodingParamsImpl}

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

"""
    Plaintext


Type alias for `CxxWrap.StdLib.SharedPtr{PlaintextImpl}`.

The plaintext object can hold unencrypted data. It is created either by encoding raw data
(e.g., through [`MakeCKKSPackedPlaintext`](@ref)) or by decrypting a [`Ciphertext`](@ref)
object using [`Decrypt`](@ref).

See also: [`Ciphertext`](@ref), [`Decrypt`](@ref)
"""
const Plaintext = CxxWrap.StdLib.SharedPtr{PlaintextImpl}

# Print contents of Plaintext types using internal implementation
Base.print(io::IO, plaintext::Plaintext) = print(io, _to_string(plaintext))

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
    :(Ciphertext{DCRTPoly}) => :GetNoiseScaleDeg,
    :(Ciphertext{DCRTPoly}) => :SetNoiseScaleDeg,
    :(Ciphertext{DCRTPoly}) => :GetLevel,
    :(Ciphertext{DCRTPoly}) => :SetLevel,
    :(Ciphertext{DCRTPoly}) => :GetHopLevel,
    :(Ciphertext{DCRTPoly}) => :SetHopLevel,
    :(Ciphertext{DCRTPoly}) => :GetScalingFactor,
    :(Ciphertext{DCRTPoly}) => :SetScalingFactor,
    :(Ciphertext{DCRTPoly}) => :GetSlots,
    :(Ciphertext{DCRTPoly}) => :SetSlots,
    :(Ciphertext{DCRTPoly}) => :Clone,
    :(Ciphertext{DCRTPoly}) => :CloneZero,
    :(Ciphertext{DCRTPoly}) => :GetEncodingParameters,
    :(CryptoContext{DCRTPoly}) => :Enable,
    :(CryptoContext{DCRTPoly}) => :GetKeyGenLevel,
    :(CryptoContext{DCRTPoly}) => :SetKeyGenLevel,
    :(CryptoContext{DCRTPoly}) => :GetEncodingParams,
    :(CryptoContext{DCRTPoly}) => :GetCyclotomicOrder,
    :(CryptoContext{DCRTPoly}) => :GetModulus,
    :(CryptoContext{DCRTPoly}) => :GetRingDimension,
    :(CryptoContext{DCRTPoly}) => :GetRootOfUnity,
    :(CryptoContext{DCRTPoly}) => :KeyGen,
    :(CryptoContext{DCRTPoly}) => :MakeCKKSPackedPlaintext,
    :(CryptoContext{DCRTPoly}) => :MakePackedPlaintext,
    :(CryptoContext{DCRTPoly}) => :Encrypt,
    :(CryptoContext{DCRTPoly}) => :Decrypt,
    :(CryptoContext{DCRTPoly}) => :EvalNegate,
    :(CryptoContext{DCRTPoly}) => :EvalAdd,
    :(CryptoContext{DCRTPoly}) => :EvalSub,
    :(CryptoContext{DCRTPoly}) => :EvalMultKeyGen,
    :(CryptoContext{DCRTPoly}) => :EvalMult,
    :(CryptoContext{DCRTPoly}) => :EvalSquare,
    :(CryptoContext{DCRTPoly}) => :EvalMultNoRelin,
    :(CryptoContext{DCRTPoly}) => :Relinearize,
    :(CryptoContext{DCRTPoly}) => :RelinearizeInPlace,
    :(CryptoContext{DCRTPoly}) => :EvalRotate,
    :(CryptoContext{DCRTPoly}) => :EvalRotateKeyGen,
    :(CryptoContext{DCRTPoly}) => :ComposedEvalMult,
    :(CryptoContext{DCRTPoly}) => :Rescale,
    :(CryptoContext{DCRTPoly}) => :RescaleInPlace,
    :(CryptoContext{DCRTPoly}) => :ModReduce,
    :(CryptoContext{DCRTPoly}) => :ModReduceInPlace,
    :(CryptoContext{DCRTPoly}) => :EvalSin,
    :(CryptoContext{DCRTPoly}) => :EvalCos,
    :(CryptoContext{DCRTPoly}) => :EvalLogistic,
    :(CryptoContext{DCRTPoly}) => :EvalDivide,
    :(CryptoContext{DCRTPoly}) => :EvalSumKeyGen,
    :(CryptoContext{DCRTPoly}) => :EvalSum,
    :(CryptoContext{DCRTPoly}) => :EvalBootstrapSetup,
    :(CryptoContext{DCRTPoly}) => :EvalBootstrapKeyGen,
    :(CryptoContext{DCRTPoly}) => :EvalBootstrap,
    :(CryptoContext{DCRTPoly}) => :Compress,
    :(Plaintext) => :GetScalingFactor,
    :(Plaintext) => :SetScalingFactor,
    :(Plaintext) => :IsEncoded,
    :(Plaintext) => :GetEncodingParams,
    :(Plaintext) => :GetElementRingDimension,
    :(Plaintext) => :GetLength,
    :(Plaintext) => :SetLength,
    :(Plaintext) => :GetNoiseScaleDeg,
    :(Plaintext) => :SetNoiseScaleDeg,
    :(Plaintext) => :GetLevel,
    :(Plaintext) => :SetLevel,
    :(Plaintext) => :GetSlots,
    :(Plaintext) => :SetSlots,
    :(Plaintext) => :GetLogError,
    :(Plaintext) => :GetLogPrecision,
    :(Plaintext) => :GetStringValue,
    :(Plaintext) => :GetCoefPackedValue,
    :(Plaintext) => :GetPackedValue,
    :(Plaintext) => :GetRealPackedValue,
    :(EncodingParams) => :GetPlaintextModulus,
    :(EncodingParams) => :SetPlaintextModulus,
    :(EncodingParams) => :GetPlaintextRootOfUnity,
    :(EncodingParams) => :SetPlaintextRootOfUnity,
    :(EncodingParams) => :GetPlaintextBigModulus,
    :(EncodingParams) => :SetPlaintextBigModulus,
    :(EncodingParams) => :GetPlaintextBigRootOfUnity,
    :(EncodingParams) => :SetPlaintextBigRootOfUnity,
    :(EncodingParams) => :GetPlaintextGenerator,
    :(EncodingParams) => :SetPlaintextGenerator,
    :(EncodingParams) => :GetBatchSize,
    :(EncodingParams) => :SetBatchSize,
]
    @eval function $fun(arg::$WrappedT, args...; kwargs...)
        $fun(arg[], args...; kwargs...)
    end
end


# Convenience `show` methods to hide wrapping-induced ugliness
# Note: remember to add tests to `test/test_convenience.jl` if you add something here
for (T, str) in [
    :(CCParams{<:CryptoContextBFVRNS}) => "CCParams{CryptoContextBFVRNS}()",
    :(CCParams{<:CryptoContextBGVRNS}) => "CCParams{CryptoContextBGVRNS}()",
    :(CCParams{<:CryptoContextCKKSRNS}) => "CCParams{CryptoContextCKKSRNS}()",
    :(CryptoContextBFVRNS) => "CryptoContextBFVRNS()",
    :(CryptoContextBGVRNS) => "CryptoContextBGVRNS()",
    :(CryptoContextCKKSRNS) => "CryptoContextCKKSRNS()",
    :(CryptoContext{DCRTPoly}) => "CryptoContext{DCRTPoly}()",
    :(Ciphertext{DCRTPoly}) => "Ciphertext{DCRTPoly}()",
    :(Plaintext) => "Plaintext()",
    :(PublicKey{DCRTPoly}) => "PublicKey{DCRTPoly}()",
    :(PrivateKey{DCRTPoly}) => "PrivateKey{DCRTPoly}()",
    :(DecryptResult) => "DecryptResult()",
    :(EncodingParams) => "EncodingParams()",
]
    @eval function Base.show(io::IO, ::$T)
        print(io, $str)
    end
end


# More convenience methods

"""
    MakeCKKSPackedPlaintext(crypto_context::CryptoContext, value::Vector{Float64};
                            scale_degree = 1,
                            level = 1,
                            params = C_NULL,
                            num_slots = 0)

Encode a vector of real numbers `value` into a CKKS-packed [`Plaintext`](@ref) using the
given `crypto_context`.
Please refer to the OpenFHE documentation for details on the remaining arguments.

See also: [`CryptoContext`](@ref), [`Plaintext`](@ref)
"""
function MakeCKKSPackedPlaintext(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                                 value::Vector{Float64};
                                 scale_degree = 1,
                                 level = 0,
                                 params = OpenFHE.CxxWrap.StdLib.SharedPtr{OpenFHE.ILDCRTParams{OpenFHE.ubint{UInt64}}}(),
                                 num_slots = 0)
    MakeCKKSPackedPlaintext(context, CxxWrap.StdVector(value), scale_degree, level, params, num_slots)
end

"""
    MakePackedPlaintext(crypto_context::CryptoContext, value::Vector{<:Integer};
                        noise_scale_degree = 1,
                        level = 0)

Encode a vector of integers `value` into a BFV/BGV-packed [`Plaintext`](@ref) using the
given `crypto_context`.
Please refer to the OpenFHE documentation for details on the remaining arguments.

See also: [`CryptoContext`](@ref), [`Plaintext`](@ref)
"""
function MakePackedPlaintext(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                             value::Vector{<:Integer};
                             noise_scale_degree = 1,
                             level = 0)
    MakePackedPlaintext(context, Int64.(value); noise_scale_degree, level)
end
function MakePackedPlaintext(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                             value::Vector{Int64};
                             noise_scale_degree = 1,
                             level = 0)
    MakePackedPlaintext(context, CxxWrap.StdVector(value), noise_scale_degree, level)
end

"""
    EvalRotateKeyGen(crypto_context::CryptoContext,
                     private_key::PrivateKey,
                     index_list::Vector{<:Integer};
                     public_key::PublicKey = C_NULL)

Generate rotation keys for use with [`EvalRotate`](@ref) using the `private_key` and for the
rotation indices in `index_list. The keys are stored in the  given `crypto_context`.
Please refer to the OpenFHE documentation for details on the remaining arguments.

See also: [`CryptoContext`](@ref), [`PrivateKey`](@ref), [`PublicKey`](@ref), [`EvalRotate`](@ref)
"""
function EvalRotateKeyGen(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                          privateKey,
                          indexList::Vector{<:Integer};
                          publicKey = OpenFHE.CxxWrap.StdLib.SharedPtr{OpenFHE.PublicKeyImpl{OpenFHE.DCRTPoly}}())
    EvalRotateKeyGen(context, privateKey, CxxWrap.StdVector(Int32.(indexList)), publicKey)
end

"""
    EvalBootstrapSetup(crypto_context::CryptoContext;
                       level_budget::Vector{<:Integer} = [5, 4],
                       dim1::Vector{<:Integer} = [0, 0],
                       slots = 0,
                       correction_factor = 0,
                       precompute = true)

Set up a given `crypto_context` for bootstrapping. Supported for CKKS only.
Please refer to the OpenFHE documentation for details on the remaining arguments.

See also: [`CryptoContext`](@ref), [`EvalBootstrapKeyGen`](@ref), [`EvalBootstrap`](@ref)
"""
function EvalBootstrapSetup(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}};
                            level_budget = [5, 4],
                            dim1 = [0, 0],
                            slots = 0,
                            correction_factor = 0,
                            precompute = true)
    EvalBootstrapSetup(context,
                       CxxWrap.StdVector(UInt32.(level_budget)),
                       CxxWrap.StdVector(UInt32.(dim1)),
                       slots,
                       correction_factor,
                       precompute)
end

"""
    EvalBootstrap(crypto_context::CryptoContext, ciphertext::Ciphertext;
                  num_iterations = 1,
                  precision = 0)

Return a refreshed `ciphertext` for a given `crypto_context`. Supported for CKKS only.
Please refer to the OpenFHE documentation for details on the remaining arguments.

See also: [`CryptoContext`](@ref), [`PrivateKey`](@ref), [`EvalBootstrapSetup`](@ref), [`EvalBootstrap`](@ref)
"""
function EvalBootstrap(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                       ciphertext;
                       num_iterations = 1,
                       precision = 0)
    EvalBootstrap(context, ciphertext, num_iterations, precision)
end

"""
    GetCryptoContext(object::Union{Ciphertext})

Return a the crypto context for a an `object` that is is a subtype of `CryptoObject`.

Currently, this is only implemented for [`Ciphertext`](@ref).

See also: [`CryptoContext`](@ref), [`Ciphertext`](@ref)
"""
function GetCryptoContext(object::Union{Ciphertext})
    # Note: Due to limitations of CxxWrap.jl when wrapping mutually dependent template
    # types, openfhe-julia introduces a non-template proxy type as an additional level of
    # indirection.
    # We thus need to first dereference `Ciphertext` to get to the `CiphertextImpl`, then
    # call the proxy method to get the `CryptoContextProxy`, and finally obtain the actual
    # `CryptoContext` from it
    GetCryptoContext(GetCryptoContextProxy(object[]))
end

"""
    Decrypt(crypto_context::CryptoContext, ciphertext::Ciphertext, private_key::PrivateKey, plaintext::Plaintext)
    Decrypt(crypto_context::CryptoContext, private_key::PrivateKey, ciphertext::Ciphertext, plaintext::Plaintext)

Decrypt a `ciphertext` with the given `private_key` and store the result in `plaintext`,
using the parameters of the given `crypto_context`.

See also: [`CryptoContext`](@ref), [`PrivateKey`](@ref), [`Ciphertext`](@ref), [`Plaintext`](@ref), [`Encrypt`](@ref)
"""
function Decrypt(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                 key_or_cipher1,
                 key_or_cipher2,
                 result::CxxWrap.CxxWrapCore.SmartPointer{<:PlaintextImpl})
    Decrypt(context, key_or_cipher1, key_or_cipher2, CxxPtr(result))
end

"""
    OpenFHE.DecryptResult

Return type of the [`Decrypt`](@ref) operation. This type does not actually hold any data
but only information on whether the decryption succeeded. It is currently not used by
OpenFHE.jl and no functions are implemented.

See also: [`Decrypt`](@ref)
"""
DecryptResult

"""
    GetBootstrapDepth(level_budget::Vector{<:Integer}, secret_key_distribution::SecretKeyDist)

Compute and return the bootstrapping depth for a given `level_budget` and a
`secret_key_distribution`.

See also: [`SecretKeyDist`](@ref)
"""
function GetBootstrapDepth(level_budget::Vector{<:Integer}, secret_key_distribution)
    Int(GetBootstrapDepth(CxxWrap.StdVector(UInt32.(level_budget)), secret_key_distribution))
end

"""
    EvalSumKeyGen(crypto_context::CryptoContext, private_key::PrivateKey;
                  public_key::PublicKey = C_NULL)

Generates the key map to be used by [`EvalSum`](@ref). `public_key` has to be set for NTRU schemes.
                  
Please refer to the OpenFHE documentation for more details.
                  
See also: [`CryptoContext`](@ref), [`PrivateKey`](@ref), [`PublicKey`](@ref), [`EvalSum`](@ref)
"""
function EvalSumKeyGen(context::CxxWrap.CxxWrapCore.CxxRef{OpenFHE.CryptoContextImpl{OpenFHE.DCRTPoly}},
                       privateKey;
                       publicKey = OpenFHE.CxxWrap.StdLib.SharedPtr{OpenFHE.PublicKeyImpl{OpenFHE.DCRTPoly}}())
    EvalSumKeyGen(context, privateKey, publicKey)
end

"""
    Compress(crypto_context::CryptoContext, ciphertext::Ciphertext; levels_left = 1, noise_scale_deg = 1)

Return a compressed ciphertext with modulus reduced to a number of multiplicative levels
`levels_left` and noise scale degree `noise_scale_deg`.

See also: [`CryptoContext`](@ref), [Ciphertext](@ref)
"""
function Compress(crypto_context::CryptoContext, ciphertext::Ciphertext; levels_left = 1, noise_scale_deg = 1)
    Compress(crypto_context, ciphertext, levels_left, noise_scale_deg)
end

function _compress_forward(crypto_context::CryptoContext, ciphertext::Ciphertext, levels_left::Int)
    Compress(crypto_context, ciphertext; levels_left = levels_left, noise_scale_deg = 1)
end

@deprecate  Compress(crypto_context::CryptoContext, ciphertext::Ciphertext, levels_left::Int)  \
            _compress_forward(crypto_context, ciphertext, levels_left)
