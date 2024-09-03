# OpenFHE.jl

[![Docs-stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://hpsc-lab.github.io/OpenFHE.jl/stable)
[![Docs-dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://hpsc-lab.github.io/OpenFHE.jl/dev)
[![Build Status](https://github.com/hpsc-lab/OpenFHE.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/hpsc-lab/OpenFHE.jl/actions?query=workflow%3ACI)
[![Coveralls](https://coveralls.io/repos/github/hpsc-lab/OpenFHE.jl/badge.svg)](https://coveralls.io/github/hpsc-lab/OpenFHE.jl)
[![Codecov](https://codecov.io/gh/hpsc-lab/OpenFHE.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/hpsc-lab/OpenFHE.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-success.svg)](https://opensource.org/license/mit/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10460452.svg)](https://doi.org/10.5281/zenodo.10460452)

OpenFHE.jl is a Julia wrapper package for
[OpenFHE](https://github.com/openfheorg/openfhe-development), a C++ library for fully
homomorphic encryption. The C++ functionality is exposed in native Julia via the
[CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl) package, using
[OpenFHE-julia](https://github.com/hpsc-lab/openfhe-julia) as its backend.

*Note: This package is work in progress and not all capabilities of OpenFHE have been
translated to Julia yet. Community contributions are very welcome!*


## Getting started

### Prerequisites
If you have not yet installed Julia, please [follow the instructions for your
operating system](https://julialang.org/downloads/platform/).
[OpenFHE.jl](https://github.com/hpsc-lab/OpenFHE.jl) works with Julia v1.8
and later on Linux and macOS platforms, and with Julia v1.9 or later on Windows platforms.

### Installation
Since OpenFHE.jl is a registered Julia package, you can install it by executing the
following commands in the Julia REPL:
```julia
julia> import Pkg; Pkg.add("OpenFHE")
```
Internally, OpenFHE.jl relies on [OpenFHE-julia](https://github.com/hpsc-lab/openfhe-julia) to
provide bindings for the C++ library
[OpenFHE](https://github.com/openfheorg/openfhe-development). Precompiled binares for
OpenFHE-julia and OpenFHE are automatically for your platform when you install OpenFHE.jl,
thus there is no need to compile anything manually.

### Usage
The easiest way to get started is to run one of the examples from the
[`examples`](https://github.com/hpsc-lab/OpenFHE.jl/tree/main/examples) directory by
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

### Memory issues
OpenFHE is a memory-optimized C++ library, but these optimizations can cause
memory issues when transitioning to Julia.

In OpenFHE, large objects like `Ciphertext`, `Plaintext`, and `CryptoContext` are managed
using `std::shared_ptr`. These objects are not freed until all associated `std::shared_ptr`s
are destroyed. Since the Julia objects that hold a reference to these shared pointers are relatively small, Julia's garbage collector
does not always free them automatically, as they are not considered a high priority for garbage collection. This is because Julia's garbage collector primarily
focuses on "young" objects during its incremental collections, leaving some `std::shared_ptr`s
in memory even when they are no longer in use. This may result in a significant increase in memory consumption over time,
as a single `Ciphertext` object can occupy over 60 MB. Consequently, complex operations may lead
to gigabytes of memory being occupied without being freed until the Julia session is terminated.
One possible solution is to manually trigger Julia's garbage collector
to perform a full collection, which will also clean up these "small" objects:
```julia
GC.gc()
```

Additionally, OpenFHE optimizes memory usage in C++ by storing evaluation keys and `CryptoContext`s
in static objects. These objects, being quite large, remain in memory until the Julia REPL is
closed. To release them while the REPL is still running, you can execute the following functions:
```julia
ClearEvalMultKeys()
ClearEvalSumKeys()
ClearEvalAutomorphismKeys()
ReleaseAllContexts()
```
Note that this will invalidate all currently existing contexts, even those which are
still in use. Thus you should only call these functions once you are done with a given
FHE setup and want to start a new one.
For more details, please refer to the documentation for [`ClearEvalMultKeys`](@ref),
[`ClearEvalSumKeys`](@ref), [`ClearEvalAutomorphismKeys`](@ref), and [`ReleaseAllContexts`](@ref).

Therefore, for a full cleanup of all OpenFHE-occupied memory, first ensure that all variables holding references to OpenFHE objects are out of scope and then execute
```julia
ClearEvalMultKeys()
ClearEvalSumKeys()
ClearEvalAutomorphismKeys()
ReleaseAllContexts()
GC.gc()
```
By running these commands at appropriate points in your code, you can prevent excessive memory
usage and ensure efficient memory management when using OpenFHE.jl.

### Using a custom OpenFHE-julia library
By default, OpenFHE.jl uses the [OpenFHE-julia](https://github.com/hpsc-lab/openfhe-julia)
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

### Transitioning between OpenFHE and OpenFHE.jl
OpenFHE.jl using CxxWrap.jl to wrap the C++ library OpenFHE for use in Julia. In general, we
try to stick as close to the original library's names and conentions as possible. Since some
concepts of C++ do not directly translate to Julia, however, some differences are
unavoidable. The most notable one is likely that Julia does not know the concept of class
member functions. CxxWrap.jl (and OpenFHE.jl) translates this to Julia functions that expect
the object as its first argument. Thus, a C++ member function call
```c++
my_object.member_function(arg1, arg2);
```
will look like
```julia
member_function(my_object, arg1, arg2)
```
in Julia.

To simplify switching back and forth between OpenFHE.jl and the C++ library OpenFHE,
OpenFHE.jl tries to use the same type and function names as OpenFHE. Since `PascalCase` is
used for types and functions in OpenFHE, the same style is used in OpenFHE.jl, even though
this is contrary to typical Julia best practices (where `PascalCase` is only used for types
and `snake_case` is used for functions).

Furthermore, all OpenFHE types are wrapped by corresponding CxxWrap.jl types, which can
sometimes be very verbose. To reduce clutter in the Julia REPL, OpenFHE.jl thus often uses a
simpler canonical output when printing an object. For example, the output of
`GenCryptoContext(parameters)` is an object of type
`CxxWrap.StdLib.SharedPtrAllocated{CryptoContextImpl{DCRTPoly}}`, but when `show`ing the
object we just print `SharedPtr{CryptoContext{DCRTPoly}}()`. To find out the actual
underlying type, use `typeof`.


## Referencing
If you use OpenFHE.jl in your own research, please cite this repository as follows:
```bibtex
@misc{schlottkelakemper2024openfhejulia,
  title={{O}pen{FHE}.jl: {F}ully homomorphic encryption in {J}ulia using {O}pen{FHE}},
  author={Schlottke-Lakemper, Michael},
  year={2024},
  howpublished={\url{https://github.com/hpsc-lab/OpenFHE.jl}},
  doi={10.5281/zenodo.10460452}
}
```


## Authors
OpenFHE.jl was initiated by [Michael Schlottke-Lakemper](https://www.uni-augsburg.de/fakultaet/mntf/math/prof/hpsc)
(University of Augsburg, Germany), who is also its principal maintainer.

Further contributions to OpenFHE.jl have been made by the following people:
* [Arseniy Kholod](https://www.github.com/ArseniyKholod) (RWTH Aachen University, Germany)


## License and contributing
OpenFHE.jl is available under the MIT license (see [LICENSE.md](LICENSE.md)).
[OpenFHE](https://github.com/openfheorg/openfhe-development) itself is available under
the BSD 2-Clause license.

Contributions by the community are very welcome! A good start would be to compare the
`examples` folder in OpenFHE.jl
([link](https://github.com/hpsc-lab/OpenFHE.jl/tree/main/examples))
and in OpenFHE
([link](https://github.com/openfheorg/openfhe-development/tree/main/src/pke/examples)) and to
port a missing example file to OpenFHE.jl. In case some OpenFHE functionality is not yet
exposed by [OpenFHE-julia](https://github.com/hpsc-lab/openfhe-julia), it would have to be
added there first.
