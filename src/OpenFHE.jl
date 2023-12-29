module OpenFHE

using CxxWrap # need to use everything to avoid `UndefVarError`s
using Preferences: @load_preference

# Load library path from preferences and wrap OpenFHE module
const openfhe_julia_library = @load_preference("openfhe_julia_library", "openfhe_julia")
@wrapmodule(() -> openfhe_julia_library)

function __init__()
    @initcxx
end

function Base.show(io::IO, pt::CxxWrap.CxxWrapCore.SmartPointer{<:PlaintextImpl})
    print(io, _to_string_plaintext(pt))
end

end # module OpenFHE
