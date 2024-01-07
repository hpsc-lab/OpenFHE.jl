# API reference

Note that most types and functions provided by OpenFHE.jl are generated automatically by
CxxWrap.jl's `@wrapmodule` macro. Therefore, docstrings are attached to just the respective
symbol and not the actual code location. The goal of this reference is thus chiefly to save
the user/developer the hassle of having to go to the (authoritative) OpenFHE documentation
each time they need to use OpenFHE.jl in Julia. Note that the documented types for function
arguments are not necessarily identical to those imposed by the Julia code, but chosen to be
more descriptive. For example, functions expecting enum arguments often allow any `Integer`
value to be passed, but we document the function signature with the enum type instead.

If in doubt, please consult the official
[OpenFHE documentation](https://openfhe-development.readthedocs.io/en/latest/).

!!! note "Dereferencing shared pointer objects"
    Sometimes OpenFHE functions do not directly return wrapped C++ objects but (wrapped)
    shared pointers to those objects. This is indicated by a `SharedPtr` or
    `SharedPtrAllocated` in the type signature. To access the underlying object, use the
    dereferencing operator `[]`.

    To avoid the hassle of having to dereference shared pointer objects when calling their
    member functions (which in Julia requires passing the object as the first argument),
    many functions have a method that automatically dereference the shared pointer, e.g.,
    all `CryptoContext` member functions such as [`GetRingDimension`](@ref) or
    [`MakeCKKSPackedPlaintext`](@ref).

```@meta
CurrentModule = OpenFHE
```

```@autodocs
Modules = [OpenFHE]
```
