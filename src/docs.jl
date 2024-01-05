# CCParams and its functions
"""
    CCParams{CryptoContextCKKSRNS}()

Create a new `CCParams` object to store parameters for CKKS-encrypted operations.
"""
CCParams

"""
   SetMultiplicativeDepth(parameters::CCParams, depth::Integer)

Set multiplicative depth for a given set of parameters.
"""
SetMultiplicativeDepth


# Plaintext and its functions
"""
    Plaintext()

Create an empty `Plaintext` object without any encoded data.
"""
Plaintext
