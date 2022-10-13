# Copyright 2022-, Semiotic AI, Inc.
# SPDX-License-Identifier: Apache-2.0

export GradientDescent, x, x!, η, ϵ

"""
    GradientDescent{
        T<:Real,H<:Hook,V<:AbstractVector{T},S<:AbstractVecOrTuple{H}
    } <: OptAlgorithm

Specifies parameters for gradient descent learning.

# Fields
- `η::T` is the learning rate/step size.
- `x::V` is the current best guess for the solution.
- `ϵ::T` is the tolerance.
- `hooks::S` are the hooks
"""
Base.@kwdef struct GradientDescent{
    T<:Real,H<:Hook,V<:AbstractVector{T},S<:AbstractVecOrTuple{H}
} <: OptAlgorithm
    x::V
    η::T
    ϵ::T
    hooks::S
end

"""
    x(g::GradientDescent)
    x(g::GradientDescent, v)

The current best guess for the solution. If using the setter, `v` is the new value.

The setter is not in-place.
See [`TheGraphOpt.x!`](@ref).
"""
x(g::GradientDescent) = g.x
x(g::GradientDescent, v) = @set g.x = v
"""
    x!(g::GradientDescent, v)

In-place setting of `g.x` to `v`

See [`TheGraphOpt.x`](@ref).
"""
function x!(g::GradientDescent, v)
    g.x .= v
    return g
end
"""
    η(g::GradientDescent)
    η(g::GradientDescent, v)

The learning rate/step size. If using the setter, `v` is the new value.

The setter is not in-place.
"""
η(g::GradientDescent) = g.η
η(g::GradientDescent, v) = @set g.η = v
"""
    ϵ(g::GradientDescent)
    ϵ(g::GradientDescent, v)

The tolerance. If using the setter, `v` is the new value.

The setter is not in-place.
"""
ϵ(g::GradientDescent) = g.ϵ
ϵ(g::GradientDescent, v) = @set g.ϵ = v

"""
    iteration(f::Function, a::OptAlgorithm)

One iteration of `a` on the function `f`.

This function is unexported.
"""
function iteration(f::Function, g::GradientDescent)
    ∇f = first(Zygote.gradient(f, x(g)))
    z = x(g) .- η(g) * ∇f
    return z
end
