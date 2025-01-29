module TestAuxiliary

using Test
using OpenFHE

println("Tests for native_int = $(OpenFHE.get_native_int())")

@testset verbose=true showtiming=true "test_auxiliary.jl" begin

@testset verbose=true showtiming=true "library_path" begin
    @test_nowarn OpenFHE.library_path()
end

@testset verbose=true showtiming=true "set_library!" begin
    msg = "[ Info: Please restart Julia and reload OpenFHE.jl for the library changes to take effect\n"
    @test_warn msg OpenFHE.set_library!(OpenFHE.library_path())
    @test_warn msg OpenFHE.set_library!()
end

@testset verbose=true showtiming=true "set_native_int!" begin
    msg = "[ Info: Please restart Julia and reload OpenFHE.jl for the library changes to take effect\n"
    # remember initial native integer size
    native_int = OpenFHE.get_native_int()
    @test_warn msg OpenFHE.set_native_int!()
    @test_warn msg OpenFHE.set_native_int!(128)
    @test_throws ArgumentError OpenFHE.set_native_int!(129)
    # return to initial native integer size
    @test_warn msg OpenFHE.set_native_int!(native_int)
end

end # @testset "test_auxiliary.jl"

end # module
