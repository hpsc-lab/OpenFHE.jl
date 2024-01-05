using Documenter

# Get OpenFHE.jl root directory
openfhe_root_dir = dirname(@__DIR__)

# Fix for https://github.com/trixi-framework/Trixi.jl/issues/668
if (get(ENV, "CI", nothing) != "true") && (get(ENV, "OPENFHE_DOC_DEFAULT_ENVIRONMENT", nothing) != "true")
    push!(LOAD_PATH, openfhe_root_dir)
end

using OpenFHE 

# Define module-wide setups such that the respective modules are available in doctests
DocMeta.setdocmeta!(OpenFHE, :DocTestSetup, :(using OpenFHE); recursive=true)

# Copy some files from the top level directory to the docs and modify them
# as necessary
open(joinpath(@__DIR__, "src", "index.md"), "w") do io
    # Point to source file
    println(io, """
    ```@meta
    EditURL = "https://github.com/sloede/OpenFHE.jl/blob/main/README.md"
    ```
    """)
    # Write the modified contents
    for line in eachline(joinpath(openfhe_root_dir, "README.md"))
        line = replace(line, "[LICENSE.md](LICENSE.md)" => "[License](@ref)")
        println(io, line)
    end
end

open(joinpath(@__DIR__, "src", "license.md"), "w") do io
    # Point to source file
    println(io, """
    ```@meta
    EditURL = "https://github.com/sloede/OpenFHE/blob/main/LICENSE.md"
    ```
    """)
    # Write the modified contents
    println(io, "# License")
    println(io, "")
    for line in eachline(joinpath(openfhe_root_dir, "LICENSE.md"))
        println(io, "> ", line)
    end
end

# Make documentation
makedocs(
    # Specify modules for which docstrings should be shown
    modules = [OpenFHE],
    # Set sitename to Trixi.jl
    sitename="OpenFHE.jl",
    # Provide additional formatting options
    format = Documenter.HTML(
        # Disable pretty URLs during manual testing
        prettyurls = get(ENV, "CI", nothing) == "true",
        # Set canonical URL to GitHub pages URL
        canonical = "https://openfhe-jl.lakemper.eu/stable"
    ),
    # Explicitly specify documentation structure
    pages = [
        "Home" => "index.md",
        "API reference" => "reference.md",
        "License" => "license.md"
    ],
)


deploydocs(;
    repo = "github.com/sloede/OpenFHE.jl",
    devbranch = "main",
    push_preview = true
)
