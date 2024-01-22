# DCRTPoly
"""
    DCRTPoly

A type used as a parameter for many parametric data types (e.g., [`CryptoContext`](@ref)
or [`Ciphertext`](@ref)) to indicate how some fundamental lattice operations are encoded
in OpenFHE. Usually this type never needs to be constructed directly by a user.

See also: [`CryptoContext`](@ref)
"""
DCRTPoly


# CCParams
"""
    CryptoContextCKKSRNS

A type used as a parameter to `CCParams` to indicate that parameters for CKKS-based
encryptions are to be stored.

See also: [`CCParams`](@ref)
"""
CryptoContextCKKSRNS

"""
    CCParams{T}

Type to store parameters for a generating a cryptographic context in OpenFHE using
`GenCryptoContext`.

Use `CCParams{CryptoContextCKKSRNS}()` to create a parameter store that can be used to
generate a cryptographic context for CKKS-encrypted operations.

See also: [`CryptoContextCKKSRNS`](@ref), [`GenCryptoContext`](@ref)
"""
CCParams

"""
    SetMultiplicativeDepth(parameters::CCParams, depth::Integer)

Set the required multiplicative `depth` for a set of `parameters`.
"""
SetMultiplicativeDepth

"""
    SetScalingModSize(parameters::CCParams, modulus::Integer)

Set the scaling `modulus` for a set of `parameters`.

See also: [`SetFirstModSize`](@ref)
"""
SetScalingModSize

"""
    SetSecretKeyDist(parameters::CCParams, distribution::SecretKeyDist)

Set the `distribution` from which the secret key is chosen for a set of `parameters`.

See also: [`SecretKeyDist`](@ref)
"""
SetSecretKeyDist

"""
    SetSecurityLevel(parameters::CCParams, level::SecurityLevel)

Set the encryption security `level` according to the homomogrphic encryption standard for a
set of `parameters`.

See also: [`SecurityLevel`](@ref)
"""
SetSecurityLevel

"""
    SetRingDim(parameters::CCParams, dimension::Integer)

Set the polynomial ring `dimension` for a set of `parameters`.
"""
SetRingDim

"""
    SetScalingTechnique(parameters::CCParams, technique::ScalingTechnique)

Set the ciphertext multiplication `technique` for a set of `parameters`.

See also: [`ScalingTechnique`](@ref)
"""
SetScalingTechnique

"""
    SetFirstModSize(parameters::CCParams, modulus::Integer)

Set the first `modulus` for a set of `parameters`.

See also: [`SetScalingModSize`](@ref)
"""
SetFirstModSize

"""
    SetNumLargeDigits(parameters::CCParams, number::Integer)

Set the `number` of large digits for a set of `parameters`.
"""
SetNumLargeDigits

"""
    SetKeySwitchTechnique(parameters::CCParams, technique::KeySwitchTechnique)

Set the key switching technique `technique` for a set of `parameters`.

See also: [`KeySwitchTechnique`](@ref)
"""
SetKeySwitchTechnique


# FHECKKSRNS
# `GetBootstrapDepth` is documented in `src/convenience.jl`

# CryptoContext
"""
    GenCryptoContext(parameters::CCParams)::CryptoContext
    GenCryptoContext(parameters::CCParams<CryptoContextCKKSRNS>)::CryptoContext<DCRTYPoly>

Generate a crypto context from a set of `parameters`. The exact return type depends on the
parameter set type.

See also: [`CryptoContext`](@ref), [`CCParams`](@ref)
"""
GenCryptoContext

"""
    Enable(crypto_context::CryptoContext, feature::PKESchemeFeature)

Enable a certain public key encryption `feature` in the given `crypto_context`.

See also: [`CryptoContext`](@ref), [`PKESchemeFeature`](@ref)
"""
Enable

"""
    GetRingDimension(crypto_context::CryptoContext)::UInt32

Return the polynomial ring dimension for a given `crypto_context`.

See also: [`CryptoContext`](@ref)
"""
GetRingDimension

"""
    KeyGen(crypto_context::CryptoContext)

Generate and return a key pair with a public and a private key for a given `crypto_context`.

See also: [`CryptoContext`](@ref), [`KeyPair`](@ref), [`PublicKey`](@ref), [`PrivateKey`](@ref)
"""
KeyGen

"""
    EvalMultKeyGen(crypto_context::CryptoContext, private_key::PrivateKey)

Generate relinearization key for use with [`EvalMult`](@ref) using the `private_key`, and
store it in the  given `crypto_context`.

See also: [`CryptoContext`](@ref), [`PrivateKey`](@ref), [`EvalMult`](@ref)
"""
EvalMultKeyGen

# EvalRotateKeyGen` is documented in `src/convenience.jl`

# `MakeCKKSPackedPlaintext` is documented in `src/convenience.jl`

"""
    Encrypt(crypto_context::CryptoContext, public_key::PublicKey, plaintext::Plaintext)

Encrypt a given [`Plaintext`](@ref) object into a [`Ciphertext`](@ref) using the given
`public_key` and using the parameters of the `crypto_context`.

See also: [`CryptoContext`](@ref), [`PublicKey`](@ref), [`Decrypt`](@ref)
"""
Encrypt

"""
    EvalAdd(crypto_context::CryptoContext, ciphertext1::Ciphertext, ciphertext2::Ciphertext)
    EvalAdd(crypto_context::CryptoContext, ciphertext::Ciphertext, plaintext::Plaintext)
    EvalAdd(crypto_context::CryptoContext, plaintext::Plaintext, ciphertext::Ciphertext)
    EvalAdd(crypto_context::CryptoContext, ciphertext::Ciphertext, scalar::Real)
    EvalAdd(crypto_context::CryptoContext, scalar::Real, ciphertext::Ciphertext)

Add `ciphertext1` to `ciphertext2` and return the resulting [`Ciphertext`](@ref).
Both input ciphertexts need to be derived from the given `crypto_context`.

Add `plaintext` to the `ciphertext` and return the resulting
[`Ciphertext`](@ref). The input ciphertext needs to be derived from the given
`crypto_context`, while the plaintext needs to be encoded in a compatible manner

Add the real-valued `scalar` element-wise to `ciphertext` and return the resulting
[`Ciphertext`](@ref). The input ciphertext needs to be derived from the given
`crypto_context`.

See also: [`CryptoContext`](@ref), [`Ciphertext`](@ref), [`Plaintext`](@ref)
"""
EvalAdd

"""
    EvalSub(crypto_context::CryptoContext, ciphertext1::Ciphertext, ciphertext2::Ciphertext)
    EvalSub(crypto_context::CryptoContext, ciphertext::Ciphertext, plaintext::Plaintext)
    EvalSub(crypto_context::CryptoContext, plaintext::Plaintext, ciphertext::Ciphertext)
    EvalSub(crypto_context::CryptoContext, ciphertext::Ciphertext, scalar::Real)
    EvalSub(crypto_context::CryptoContext, scalar::Real, ciphertext::Ciphertext)

Subtract `ciphertext2` from `ciphertext1` and return the resulting [`Ciphertext`](@ref).
Both input ciphertexts need to be derived from the given `crypto_context`.

Subtract `plaintext` from `ciphertext` (or vice-versa) and return the resulting
[`Ciphertext`](@ref). The input ciphertext needs to be derived from the given
`crypto_context`, while the plaintext needs to be encoded in a compatible manner

Subtract the real-valued `scalar` element-wise from `ciphertext` (or vice-versa)
and return the resulting [`Ciphertext`](@ref). The input ciphertext needs to be derived from
the given `crypto_context`.

See also: [`CryptoContext`](@ref), [`Ciphertext`](@ref), [`Plaintext`](@ref)
"""
EvalSub

"""
    EvalMult(crypto_context::CryptoContext, ciphertext1::Ciphertext, ciphertext2::Ciphertext)
    EvalMult(crypto_context::CryptoContext, ciphertext::Ciphertext, plaintext::Plaintext)
    EvalMult(crypto_context::CryptoContext, plaintext::Plaintext, ciphertext::Ciphertext)
    EvalMult(crypto_context::CryptoContext, ciphertext::Ciphertext, scalar::Real)
    EvalMult(crypto_context::CryptoContext, scalar::Real, ciphertext::Ciphertext)

Multiply `ciphertext1` with `ciphertext2` and return the resulting [`Ciphertext`](@ref).
Both input ciphertexts need to be derived from the given `crypto_context`.

Multiply `ciphertext` with the `plaintext` and return the resulting
[`Ciphertext`](@ref). The input ciphertext needs to be derived from the given
`crypto_context`, while the plaintext needs to be encoded in a compatible manner

Multiply `ciphertext` with the real-valued `scalar` and return the resulting
[`Ciphertext`](@ref). The input ciphertext needs to be derived from the given
`crypto_context`.

See also: [`CryptoContext`](@ref), [`Ciphertext`](@ref), [`Plaintext`](@ref)
"""
EvalMult


"""
    EvalNegate(crypto_context::CryptoContext, ciphertext::Ciphertext)

Negate the `ciphertext`. The input ciphertext needs to be derived from the given
`crypto_context`.

See also: [`CryptoContext`](@ref), [`Ciphertext`](@ref)
"""
EvalNegate


"""
    EvalRotate(crypto_context::CryptoContext, ciphertext::Ciphertext, index::Integer)

Rotate the `ciphertext` by the given `index`. A positive index denotes a left shift, a
negative index a right shift.  The input ciphertext needs to be derived from the given
`crypto_context`.

See also: [`CryptoContext`](@ref), [`Ciphertext`](@ref)
"""
EvalRotate

# `Decrypt` is documented in `src/convenience.jl`

# `EvalBootstrapSetup` is documented in `src/convenience.jl`

"""
    EvalBootstrapKeyGen(crypto_context::CryptoContext, private_key::PrivateKey, num_slots::Integer)

Generate the necessary keys from `private_key` to enable bootstrapping for a given
`crypto_context` and `num_slots` slots. Supported for CKKS only.

See also: [`CryptoContext`](@ref), [`PrivateKey`](@ref), [`EvalBootstrapSetup`](@ref), [`EvalBootstrap`](@ref)
"""
EvalBootstrapKeyGen

# `EvalBootstrap` is documented in `src/convenience.jl`


# Plaintext

# `Plaintext` is documented in `src/convenience.jl`

"""
    IsEncoded(plaintext::Plaintext)

Return true when encoding is done for a given `plaintext`.

See also: [`Plaintext`](@ref)
"""
IsEncoded

"""
    GetElementRingDimension(plaintext::Plaintext)::UInt32

Return the ring dimension on the underlying element for a given `plaintext`.

See also: [`Plaintext`](@ref)
"""
GetElementRingDimension

"""
    GetLogError(plaintext::Plaintext)

Return log2 of estimated standard deviation of approximation for a given `plaintext`.

See also: [`Plaintext`](@ref)
"""
GetLogError

"""
    GetLogPrecision(plaintext::Plaintext)

Return log2 of estimated precision for a given `plaintext`.

See also: [`Plaintext`](@ref)
"""
GetLogPrecision

"""
    GetStringValue(plaintext::Plaintext)::String

Return data as string for a given `plaintext`.

Note: Only supported for schemes that encode data as string!

See also: [`Plaintext`](@ref)
"""
GetStringValue

"""
    GetCoefPackedValue(plaintext::Plaintext)::Vector{Int64}

Return data as packed coefficients for a given `plaintext`.

Note: Only supported for schemes that encode data as packed coefficients!

See also: [`Plaintext`](@ref)
"""
GetCoefPackedValue

"""
    GetPackedValue(plaintext::Plaintext)::Vector{Int64}

Return data as packed value for a given `plaintext`.

Note: Only supported for schemes that encode data as packed values!

See also: [`Plaintext`](@ref)
"""
GetPackedValue

"""
    GetRealPackedValue(plaintext::Plaintext)::Vector{Float64}

Return data as double precision values for a given `plaintext`.

Note: Only supported for schemes that encode data as double precision values!

See also: [`Plaintext`](@ref)
"""
GetRealPackedValue


# Ciphertext (+ Plaintext)
"""
    GetNoiseScaleDeg(ciphertext::Ciphertext)
    GetNoiseScaleDeg(plaintext::Plaintext)

Get the degree of the scaling factor for the given `ciphertext` or `plaintext`..

See also: [`Ciphertext`](@ref), [`Plaintext`](@ref), [`SetNoiseScaleDeg`](@ref)
"""
GetNoiseScaleDeg

"""
    SetNoiseScaleDeg(ciphertext::Ciphertext, degree::Integer)
    SetNoiseScaleDeg(plaintext::Plaintext, degree::Integer)

Set the `degree` of the scaling factor for the given `ciphertext` or `plaintext`..

See also: [`Ciphertext`](@ref), [`Plaintext`](@ref), [`GetNoiseScaleDeg`](@ref)
"""
SetNoiseScaleDeg

"""
    GetLevel(ciphertext::Ciphertext)
    GetLevel(plaintext::Plaintext)

Return the number of scalings performed for the given `ciphertext` or `plaintext`..

See also: [`Ciphertext`](@ref), [`Plaintext`](@ref), [`SetLevel`](@ref)
"""
GetLevel

"""
    SetLevel(ciphertext::Ciphertext, level::Integer)
    SetLevel(plaintext::Plaintext, level::Integer)

Set the number of scalings `level` for the given `ciphertext` or `plaintext`..

See also: [`Ciphertext`](@ref), [`Plaintext`](@ref), [`GetLevel`](@ref)
"""
SetLevel

"""
    GetHopLevel(ciphertext::Ciphertext)

Return the re-encryption level for the given `ciphertext`.

See also: [`Ciphertext`](@ref), [`SetHopLevel`](@ref)
"""
GetHopLevel

"""
    SetHopLevel(ciphertext::Ciphertext, level::Integer)

Set the re-encryption `level` for the given `ciphertext`.

See also: [`Ciphertext`](@ref), [`GetHopLevel`](@ref)
"""
SetHopLevel

"""
    GetScalingFactor(ciphertext::Ciphertext)
    GetScalingFactor(plaintext::Plaintext)

Return the scaling factor for the given `ciphertext` or `plaintext`.

See also: [`Ciphertext`](@ref), [`Plaintext`](@ref), [`SetScalingFactor`](@ref)
"""
GetScalingFactor

"""
    SetScalingFactor(ciphertext::Ciphertext, factor::Real)
    SetScalingFactor(plaintext::Plaintext, factor::Real)

Set the scaling `factor` for the given `ciphertext` or `plaintext`.

See also: [`Ciphertext`](@ref), [`Plaintext`](@ref), [`GetScalingFactor`](@ref)
"""
SetScalingFactor

"""
    GetSlots(ciphertext::Ciphertext)
    GetSlots(plaintext::Plaintext)

Return the number of slots for the given `ciphertext` or `plaintext`.

See also: [`Ciphertext`](@ref), [`Plaintext`](@ref), [`SetSlots`](@ref)
"""
GetSlots

"""
    SetSlots(ciphertext::Ciphertext, slots::Integer)
    SetSlots(plaintext::Plaintext, slots::Integer)

Set the number of `slots` for the given `ciphertext` or `plaintext`.

See also: [`Ciphertext`](@ref), [`Plaintext`](@ref), [`GetSlots`](@ref)
"""
SetSlots

"""
    Clone(ciphertext::Ciphertext)

Clone the given `ciphertext` *including* its encrypted data.

See also: [`Ciphertext`](@ref), [`CloneZero`](@ref)
"""
Clone

"""
    CloneZero(ciphertext::Ciphertext)

Clone the given `ciphertext` *without* its encrypted data.

See also: [`Ciphertext`](@ref), [`Clone`](@ref)
"""
CloneZero


# Enums
"""
    PKESchemeFeature

Enum type for selecting scheme features for public key encryption (PKE) in a crypto context
using [`Enable`](@ref).

Instances are:
* `PKE`
* `KEYSWITCH`
* `PRE`
* `LEVELDSHE`
* `ADVANCEDSHE`
* `MULTIPARTY`
* `FHE`
* `SCHEMESWITCH`

See also: [`Enable`](@ref)
"""
PKESchemeFeature, PKE, KEYSWITCH, PRE, LEVELEDSHE, ADVANCEDSHE, MULTIPARTY, FHE, SCHEMESWITCH

"""
    KeySwitchTechnique

Enum type for selecting the key switching technique in a set of
[`CCParams`](@ref) parameters using [`SetKeySwitchTechnique`](@ref).

Instances are:
* `INVALID_KS_TECH`
* `BV`
* `HYBRID`

See also: [`SetKeySwitchTechnique`](@ref)
"""
KeySwitchTechnique, INVALID_KS_TECH, BV, HYBRID

"""
    ScalingTechnique

Enum type for selecting the scaling technique for ciphertext multiplication in a set of
[`CCParams`](@ref) parameters using [`SetScalingTechnique`](@ref).

Instances are:
* `FIXEDMANUAL`
* `FIXEDAUTO`
* `FLEXIBLEAUTO`
* `FLEXIBLEAUTOEXT`
* `NORESCALE`
* `INVALID_RS_TECHNIQUE`

See also: [`SetScalingTechnique`](@ref)
"""
ScalingTechnique, FIXEDMANUAL, FIXEDAUTO, FLEXIBLEAUTO, FLEXIBLEAUTOEXT, NORESCALE,
INVALID_RS_TECHNIQUE

"""
    SecretKeyDist

Enum type for selecting the distribution from which the secret key is generated. To be
used in a set of [`CCParams`](@ref) parameters using [`SetSecretKeyDist`](@ref).

Instances are:
* `GAUSSIAN`
* `UNIFORM_TERNARY`
* `SPARSE_TERNARY`

See also: [`SetSecretKeyDist`](@ref)
"""
SecretKeyDist, GAUSSIAN, UNIFORM_TERNARY, SPARSE_TERNARY

"""
   SecurityLevel
Enum type for specifying the security level according to the homomorphic encryption standard
in a set of [`CCParams`](@ref) parameters using [`SetSecurityLevel`](@ref).

Instances are:
* `HEStd_128_classic`
* `HEStd_192_classic`
* `HEStd_256_classic`
* `HEStd_128_quantum`
* `HEStd_192_quantum`
* `HEStd_256_quantum`
* `HEStd_NotSet`


See also: [`SetSecurityLevel`](@ref)
"""
SecurityLevel, HEStd_128_classic, HEStd_192_classic, HEStd_256_classic, HEStd_128_quantum, HEStd_192_quantum, HEStd_256_quantum, HEStd_NotSet

"""
    KeyPair{T}

Data type to hold a public/private key combination for encrypting/decrypting data. A key
pair is usually generated by calling [`KeyGen`](@ref).

!!! note
    To extract the public or private key from a key pair, use
    [`OpenFHE.public_key`](@ref) and [`OpenFHE.private_key`](@ref) respectively. Since these
    are not functions provided by OpenFHE but only by OpenFHE.jl, they are not exported.

See also: [`KeyGen`](@ref), [`CryptoContext`](@ref), [`PublicKey`](@ref), [`PrivateKey`](@ref), [`OpenFHE.public_key`](@ref), [`OpenFHE.private_key`](@ref)
"""
KeyPair

"""
    OpenFHE.public_key(key_pair::KeyPair)

Return the public key from a `key_pair`.

See also: [`KeyPair`](@ref), [`private_key`](@ref)
"""
public_key

"""
    OpenFHE.private_key(key_pair::KeyPair)

Return the private key from a `key_pair`.

See also: [`KeyPair`](@ref), [`public_key`](@ref)
"""
private_key
