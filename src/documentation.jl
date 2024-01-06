# CCParams and its functions
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

# CryptoContext and its functions
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

# EvalMultKeyGen
# EvalRotateKeyGen,
# MakeCKKSPackedPlaintext

"""
    Encrypt(crypto_context::CryptoContext, public_key::PublicKey, plaintext::Plaintext)

Encrypt a given [`Plaintext`](@ref) object into a [`Ciphertext`](@ref) using the given
`public_key` and using the parameters of the `crypto_context`.

See also: [`CryptoContext`](@ref), [`PublicKey`](@ref)
"""
Encrypt

# EvalAdd
# EvalSub
# EvalMult
# EvalRotate
# Decrypt
# EvalBootstrapSetup
# EvalBootstrapKeyGen
# EvalBootstrap


# Plaintext and its functions
"""
    Plaintext()

Create an empty `Plaintext` object without any encoded data.
"""
Plaintext


# Ciphertext and its functions
# GetLevel


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

See also: [`KeyGen`](@ref), [`CryptoContext`](@ref), [`PublicKey`](@ref), [`PrivateKey`](@ref)
"""
