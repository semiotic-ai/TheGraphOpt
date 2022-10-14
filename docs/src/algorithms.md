# Algorithms

This section will introduce you to the basic workflow that you'll use to optimise functions,
as well as the algorithms we've implemented.

Generally speaking, there are two parts to optimising.
The first is to specify the function you want to optimise.
Say,

```julia
julia> f(x) = sum(x .^ 2)
```

Then you want to create a [Hook](@ref hooks) with the [`TheGraphOpt.IsStoppingCondition`](@ref) trait.
Else, optimisation will get stuck in an infinite loop.

```julia
julia> using LinearAlgebra
julia> h = StopWhen((a; locals...) -> norm(x(a) - locals[:z]) < ϵ(a))  # Stop when the residual is less than the tolerance
```

Then, you want to choose the algorithm you want to use for minimisation and specify its parameters.

```julia
julia> a = GradientDescent(; x=[100.0, 50.0], η=1e-1, ϵ=1e-6, hooks=[h,])  # Specify parameters for optimisation
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

### Projected Gradient Descent

Projected Gradient Descent is a more general gradient descent in a sense.
Whereas gradient descent itself has no constraint, projected gradient descent allows
for you to specify a constraint.
In particular, here, we are interested in solving the problem of ``\min_x f(x)`` subject to
some constraints.
Those constraints define the feasible region ``\mathcal{C}``.
Thus, the full problem we're trying to solve is ``\min_x f(x) \textrm{subject to } x\in\mathcal{C}``.
Once we do the standard gradient descent step, here we project the result onto the feasible set.
In other words, 

```math
\begin{align*}
    y_{n} &= x_n - η∇f(x_n) \\
    x_{n+1} &= \textrm{Pr}(y_n)_\mathcal{C}
\end{align*}
```

To use PGD, you'll need to specify `t`, the projection function.
Any projection function must take only `x` as input.
To get more complex behaviour, you may find it useful to leverage currying (partial function application).

Let's look at an example of this.
Say we want to minimise ``f(x)=\sum x^2`` subject to a unit simplex constraint.
We provide a function [`TheGraphOpt.σsimplex`](@ref).
However, this function doesn't only take `x` as input, but also takes `σ`.
In order to create a projection function in terms of only `x`, we will apply currying by creating
a new function.

```julia
julia> using TheGraphOpt
julia> unitsimplex(x) = σsimplex(x, 1)
```

Now, we can create a PGD parameters struct and solve our problem.

```julia
julia> using LinearAlgebra
julia> f(x) = sum(x.^2)
julia> a = ProjectedGradientDescent(;
            x=[100.0, 50.0],
            η=1e-1,
            ϵ=1e-6,
            hooks=[StopWhen((a; kws...) -> norm(x(a) - kws[:z]) < ϵ(a))],
            t=unitsimplex,
        )
julia> aopt = minimize(f, a)
julia> TheGraphOpt.x(aopt)
2-element Vector{Float64}:
 0.5000023384026198
 0.49999766159738035
```

The PGD struct is documented by

```@docs
TheGraphOpt.ProjectedGradientDescent
```

And the projection functions we've already defined are

```@docs
TheGraphOpt.σsimplex
TheGraphOpt.gssp
```
