```@meta
CurrentModule = TheGraphOpt
```

# TheGraphOpt

This package implements optimisation algorithms for use within simulation and production.
For the most part, your workflow should look something like

```julia
julia> using TheGraphOpt
julia> f(x) = sum(x .^ 2)  # Specify function to optimise as min f(x)
julia> a = GradientDescent(; x=[100.0, 50.0], η=1e-1, ϵ=1e-6)  # Specify parameters for optimisation
julia> sol = minimize!(f, a)  # Optimise
julia> @show TheGraphOpt.x(sol)  # Print out the optimal value
2-element Vector{Float64}:
 3.4163644416613304e-6
 1.6909278549636878e-6
```

## Installation

Make sure you've installed [Julia 1.8 or greater](https://julialang.org/).

This package is hosted on [SemioticJLRegistry](https://github.com/semiotic-ai/SemioticJLRegistry).
To add this package, first add the registry to your Julia installation.
Then, install this package by running `] add TheGraphOpt` from the Julia REPL.

``` julia
julia> ]registry add https://github.com/semiotic-ai/SemioticJLRegistry
julia> ]add TheGraphOpt
```
