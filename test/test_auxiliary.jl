module TestAuxiliary

using Test
using OpenFHE

@testset verbose=true showtiming=true "library_path" begin
    @test_nowarn OpenFHE.library_path()
end

@testset verbose=true showtiming=true "set_library!" begin
    @test_nowarn OpenFHE.set_library!(OpenFHE.library_path())
    @test_nowarn OpenFHE.set_library!()
end

end # module
