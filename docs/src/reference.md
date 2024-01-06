# API reference

Note that most types and functions provided by OpenFHE.jl are generated automatically by
CxxWrap.jl's `@wrapmodule` macro. Therefore, docstrings are attached to just the respective
symbol and not the actual code location. The goal of this reference is thus chiefly to save
the user/developer the hassle of having to go to the (authoritative) OpenFHE documentation
each time they need to use OpenFHE.jl in Julia.

If in doubt, please consult the official
[OpenFHE documentation](https://openfhe-development.readthedocs.io/en/latest/).

!!! note "Dereferencing shared pointer objects"
    Sometimes OpenFHE functions do not directly return wrapped C++ objects but (wrapped)
    shared pointers to those objects. This is indicated by a `SharedPtr` or
    `SharedPtrAllocated` in the type signature. To access the underlying object, use the
    dereferencing operator `[]`.

    To avoid the hassle of having

```@meta
CurrentModule = OpenFHE
```

```@autodocs
Modules = [OpenFHE]
```
