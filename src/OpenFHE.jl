module OpenFHE

using CxxWrap: @wrapmodule, @initcxx
using Preferences: @load_preferences

# Load library path from preferences and wrap OpenFHE module
const openfhe_julia_library = @load_preferences("openfhe_julia_library", "openfhe_julia")
@wrapmodule(() -> openfhe_julia_library)

function __init__()
    @initcxx
end

end # module OpenFHE
