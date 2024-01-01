# OpenFHE.jl

[![Build Status](https://github.com/sloede/OpenFHE.jl/workflows/CI/badge.svg)](https://github.com/sloede/OpenFHE.jl/actions?query=workflow%3ACI)
[![License: MIT](https://img.shields.io/badge/License-MIT-success.svg)](https://opensource.org/license/mit/)

OpenFHE.jl is a Julia wrapper package for
[OpenFHE](https://github.com/openfheorg/openfhe-development), a C++ library for fully
homomorphic encryption. The C++ functionality is exposed in native Julia via the
[CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl) package, using
[openfhe-julia](https://github.com/sloede/openfhe-julia) as its backend.

**Note: While already usable, this wrapper is in an early state and only exposes a very
limited subset of OpenFHE to Julia. Community contributions welcome!**


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
exposed by [openfhe-julia](https://github.com/sloede/openfhe-julia), it would have to be
added there first.
