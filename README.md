# OpenFHE.jl

[![Docs-stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://openfhe-jl.lakemper.eu/stable)
[![Docs-dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://openfhe-jl.lakemper.eu/dev)
[![Build Status](https://github.com/sloede/OpenFHE.jl/workflows/CI/badge.svg)](https://github.com/sloede/OpenFHE.jl/actions?query=workflow%3ACI)
[![Coveralls](https://coveralls.io/repos/github/sloede/OpenFHE.jl/badge.svg)](https://coveralls.io/github/sloede/OpenFHE.jl)
[![Codecov](https://codecov.io/gh/sloede/OpenFHE.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/sloede/OpenFHE.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-success.svg)](https://opensource.org/license/mit/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10460452.svg)](https://doi.org/10.5281/zenodo.10460452)

OpenFHE.jl is a Julia wrapper package for
[OpenFHE](https://github.com/openfheorg/openfhe-development), a C++ library for fully
homomorphic encryption. The C++ functionality is exposed in native Julia via the
[CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl) package, using
[OpenFHE-julia](https://github.com/sloede/openfhe-julia) as its backend.


## Getting started

### Installation
If you have not yet installed Julia, please [follow the instructions for your
operating system](https://julialang.org/downloads/platform/).
[OpenFHE.jl](https://github.com/sloede/OpenFHE.jl) works with Julia v1.8
and later.

Since it is a registered Julia package, you can install OpenFHE.jl by executing the
following commands in the Julia REPL:
```julia
julia> import Pkg; Pkg.add("OpenFHE")
```
Internally, OpenFHE.jl relies on [OpenFHE-julia](https://github.com/sloede/openfhe-julia) to
provide bindings for the C++ library
[OpenFHE](https://github.com/openfheorg/openfhe-development). Precompiled binares for
OpenFHE-julia and OpenFHE are automatically for your platform when you install OpenFHE.jl,
thus there is no need to compile anything manually.

### Usage
The easiest way to get started is to run one of the examples from the
[`examples`](https://github.com/sloede/OpenFHE.jl/tree/main/examples) directory by
`include`ing them in Julia, e.g.,
```julia
julia> using OpenFHE

julia> include(joinpath(pkgdir(OpenFHE), "examples", "simple_real_numbers.jl"))
CKKS scheme is using ring dimension 16384

Input x1: (0.25, 0.5, 0.75, 1, 2, 3, 4, 5,  ... ); Estimated precision: 50 bits

Input x2: (5, 4, 3, 2, 1, 0.75, 0.5, 0.25,  ... ); Estimated precision: 50 bits


Results of homomorphic computations:
x1 = (0.25, 0.5, 0.75, 1, 2, 3, 4, 5,  ... ); Estimated precision: 43 bits
Estimated precision in bits: 43.0
x1 + x2 = (5.25, 4.5, 3.75, 3, 3, 3.75, 4.5, 5.25,  ... ); Estimated precision: 43 bits
Estimated precision in bits: 43.0
x1 - x2 = (-4.75, -3.5, -2.25, -1, 1, 2.25, 3.5, 4.75,  ... ); Estimated precision: 43 bits

4 * x1 = (1, 2, 3, 4, 8, 12, 16, 20,  ... ); Estimated precision: 41 bits

x1 * x2 = (1.25, 2, 2.25, 2, 2, 2.25, 2, 1.25,  ... ); Estimated precision: 41 bits


In rotations, very small outputs (~10^-10 here) correspond to 0's:
x1 rotate by 1 = (0.5, 0.75, 1, 2, 3, 4, 5, 0.25,  ... ); Estimated precision: 43 bits

x1 rotate by -2 = (4, 5, 0.25, 0.5, 0.75, 1, 2, 3,  ... ); Estimated precision: 43 bits
```

### Using a custom OpenFHE-julia library
By default, OpenFHE.jl uses the [OpenFHE-julia](https://github.com/sloede/openfhe-julia)
library provided by the openfhe\_julia\_jll.jl package, which is automatically obtained when
installing OpenFHE.jl. Someimtes, however, it might be beneficial to instead use a
system-provided OpenFHE-julia library, e.g., for development or performance purposes. You
can change the default by providing a different library with the `OpenFHE.set_library!`
function, i.e., by running
```julia
julia> using OpenFHE

julia> OpenFHE.set_library!("/abs/path/to/library.so")
[ Info: Please restart Julia and reload OpenFHE.jl for the library changes to take effect
```
This will create a `LocalPreferences.toml` file in your current project directory with the
`libopenfhe_julia` preference set accordingly. As advised, you need to restart Julia for
the change to take effect. By calling `set_library!()` without an argument, you revert to
using JLL-provided library again.

In case the custom library has been deleted, loading OpenFHE.jl will fail. In that case,
either remove the `LocalPreferences.toml` file or manually reset the preferences by
executing
```julia
julia> using UUIDs, Preferences

julia> delete_preferences!(UUID("77ce9b8e-ecf5-45d1-bd8a-d31f384f2f95"), # UUID of OpenFHE.jl
                           "libopenfhe_julia"; force = true)
```


## Referencing
If you use OpenFHE.jl in your own research, please cite this repository as follows:
```bibtex
@misc{schlottkelakemper2024openfhejulia,
  title={{O}pen{FHE}.jl: {F}ully homomorphic encryption in {J}ulia using {O}pen{FHE}},
  author={Schlottke-Lakemper, Michael},
  year={2024},
  howpublished={\url{https://github.com/sloede/OpenFHE.jl}},
  doi={10.5281/zenodo.10460452}
}
```


## Authors
OpenFHE.jl was initiated by [Michael Schlottke-Lakemper](https://lakemper.eu) (RWTH
Aachen University/High-Performance Computing Center Stuttgart (HLRS), Germany), who is also
its principal maintainer.


## License and contributing
OpenFHE.jl is available under the MIT license (see [LICENSE.md](LICENSE.md)).
[OpenFHE](https://github.com/openfheorg/openfhe-development) itself is available under
the BSD 2-Clause license.

Contributions by the community are very welcome! A good start would be to compare the
`examples` folder in OpenFHE.jl
([link](https://github.com/sloede/OpenFHE.jl/tree/main/examples))
and in OpenFHE
([link](https://github.com/openfheorg/openfhe-development/tree/main/src/pke/examples)) and to
port a missing example file to OpenFHE.jl. In case some OpenFHE functionality is not yet
exposed by [OpenFHE-julia](https://github.com/sloede/openfhe-julia), it would have to be
added there first.
