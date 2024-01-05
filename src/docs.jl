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

Set the required multiplicative depth for a set of `parameters`.
"""
SetMultiplicativeDepth

"""
    SetScalingModSize(parameters::CCParams, depth::Integer)

Set the scaling modulus for a set of `parameters`.
"""
SetScalingModSize


# Plaintext and its functions
"""
    Plaintext()

Create an empty `Plaintext` object without any encoded data.
"""
Plaintext


# Add convenience `show` methods to hide wrapping-induced ugliness
for (T, str) in [
    :(CCParams{<:CryptoContextCKKSRNS}) => "CCParams{CryptoContextCKKSRNS}()",
    :(CryptoContextCKKSRNS) => "CryptoContextCKKSRNS()",
    :(CxxWrap.StdLib.SharedPtr{CryptoContextImpl{DCRTPoly}}) => "SharedPtr{CryptoContext{DCRTPoly}}()",
]
    @eval function Base.show(io::IO, ::$T)
        print(io, $str)
    end
end
