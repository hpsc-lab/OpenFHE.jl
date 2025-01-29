const OPENFHE_PACKAGE_UUID = UUID("77ce9b8e-ecf5-45d1-bd8a-d31f384f2f95")

"""
    OpenFHE.set_library!(path = nothing; force = true)

Set the absolute `path` to a system-provided OpenFHE-julia installation, e.g., something
like `/path/to/libopenfhe_julia.<ext>`, where `<ext>` is `so` on Linux`, `dylib` on macOS,
and `dll` on Windows. Restart the Julia session after executing this function such that the
changes take effect. Using `nothing` as the path will revert the library path to the default
settings, i.e., the JLL-provided version of OpenFHE-julia will be used.
"""
function set_library!(path = nothing; force = true)
    if isnothing(path)
        delete_preferences!(OPENFHE_PACKAGE_UUID, "libopenfhe_julia"; force)
    else
        isfile(path) || throw(ArgumentError("$path is not an existing file."))
        set_preferences!(OPENFHE_PACKAGE_UUID, "libopenfhe_julia" => path; force)
    end
    @info "Please restart Julia and reload OpenFHE.jl for the library changes to take effect"
end

"""
    OpenFHE.set_native_int!(native_int::Integer = 64; force = true)

Set the native integer size for an OpenFHE-julia installation, it can be `64` or `128` bits.
Restart the Julia session after executing this function such that the changes take effect.

See also: [`OpenFHE.get_native_int`](@ref)
"""
function set_native_int!(native_int::Integer = 64)
    if native_int != 64 && native_int != 128
        throw(ArgumentError("Unsupported value '$native_int' passed to `native_int` (must be `64` or `128`)"))
    end
    @set_preferences!("native_int" => native_int)
    @info "Please restart Julia and reload OpenFHE.jl for the library changes to take effect"
end


"""
    OpenFHE.library_path()

Return the path of the OpenFHE-julia library that is used.
"""
library_path() = libopenfhe_julia_path

