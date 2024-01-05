module TestAuxiliary

using Test
using OpenFHE

@testset verbose=true showtiming=true "library_path" begin
    @test_nowarn OpenFHE.library_path()
end

@testset verbose=true showtiming=true "set_library!" begin
    msg = "[ Info: Please restart Julia and reload OpenFHE.jl for the library changes to take effect\n"
    @test_warn msg OpenFHE.set_library!(OpenFHE.library_path())
    @test_warn msg OpenFHE.set_library!()
end

end # module
