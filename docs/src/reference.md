# API reference

Note that most types and functions provided by OpenFHE.jl are generated automatically by
CxxWrap.jl's `@wrapmodule` macro. Therefore, docstrings are attached to just the respective
symbol and not the actual code location. The goal of this reference is thus chiefly to save
the user/developer the hassle of having to go to the (authorative) OpenFHE documentation
each time they need to use OpenFHE.jl in Julia. Therefore, function signatures often include
the expected argument types even though they are not needed for dispatch.

```@meta
CurrentModule = OpenFHE
```

```@autodocs
Modules = [OpenFHE]
```
