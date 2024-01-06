# CCParams and its functions
"""
    CryptoContextCKKSRNS

A type used as a parameter to `CCParams` to indicate that parameters for CKKS-based
encryptions are to be set..

See also: [`CCParams`](@ref)
"""
CryptoContextCKKSRNS

"""
    CCParams{CryptoContextCKKSRNS}()

Create a new `CCParams` object to store parameters for CKKS-encrypted operations.
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
# GetBootstrapDepth: documented in `src/convenience.jl`

# CryptoContext and its functions
"""
    GenCryptoContext(parameters::CCParams)

Generate a crypto context from a set of `parameters`.

See also: [`CCParams`](@ref)
"""
GenCryptoContext

"""
    Enable(crypto_context::CCParams)

Generate a crypto context from a set of `parameters`.

See also: [`CCParams`](@ref)
"""
Enable
# GetRingDimension
# KeyGen
# EvalMultKeyGen
# EvalRotateKeyGen,
# MakeCKKSPackedPlaintext
# Encrypt
# EvalAdd
# EvalSub
# EvalMult
# EvalRotate
# Decrypt,
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

Enum type for selecting scheme features in a crypto context using [`Enable`](@ref).

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
