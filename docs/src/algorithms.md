# Algorithms

This section will introduce you to the basic workflow that you'll use to optimise functions,
as well as the algorithms we've implemented.

Generally speaking, there are two parts to optimising.
The first is to specify the function you want to optimise.
Say,

```julia
julia> f(x) = sum(x .^ 2)
```

Then, you want to choose the algorithm you want to use for minimisation and specify its parameters.

```julia
julia> a = GradientDescent(; x=[100.0, 50.0], η=1e-1, ϵ=1e-6)  # Specify parameters for optimisation
```

Finally, you'll run `minimize!` or `minimize`.

```julia
julia> sol = minimize!(f, a)  # Optimise
```

```@docs
TheGraphOpt.minimize!
TheGraphOpt.minimize
```

`sol` here is a struct containing various metadata.
If you only care about the optimal value of `x`, then grab it using

```julia
julia> TheGraphOpt.x(sol)
```


## Algorithms

### Gradient Descent

From [Wikipedia](https://en.wikipedia.org/wiki/Gradient_descent):

> [Gradient Descent]... is a first-order iterative optimization algorithm for finding a local minimum of a differentiable function. The idea is to take repeated steps in the opposite direction of the gradient (or approximate gradient) of the function at the current point, because this is the direction of steepest descent. 

If the function we're optimising `f` is convex, then a local minimum is also a global minimum.
The update rule for gradient descent is ``x_{n+1}=x_n - η∇f(x_n)``.

```@docs
TheGraphOpt.GradientDescent
```
