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
If you have not yet installed Julia, please [follow the instructions for your
operating system](https://julialang.org/downloads/platform/).
[OpenFHE.jl](https://github.com/sloede/OpenFHE.jl) works with Julia v1.8
and later.

Since it is a registered Julia package, you cann install OpenFHE.jl by executing the
following commands in the Julia REPL:
```julia
julia> import Pkg; Pkg.add("OpenFHE")
```
Internally, OpenFHE.jl relies on [OpenFHE-julia](https://github.com/sloede/openfhe-julia) to
provide bindings for the C++ library
[OpenFHE](https://github.com/openfheorg/openfhe-development). Precompiled binares for
OpenFHE-julia and OpenFHE are automatically for your platform when you install OpenFHE.jl,
thus there is no need to compile anything manually.


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
