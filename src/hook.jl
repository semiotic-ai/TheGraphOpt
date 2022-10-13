# Copyright 2022-, Semiotic AI, Inc.
# SPDX-License-Identifier: Apache-2.0

export Hook, stophook, StopWhen, shouldstop

"""
Abstract type for hooks.
"""
abstract type Hook end

"""
    shouldstop(hs::AbstractVecOrTuple{H}, a::OptAlgorithm; locals...)

Map over the hooks `hs` to check for stopping conditions.

This performs an `OR` operation if there are multiple hooks that have the
[`TheGraphOpt.IsStoppingCondition`](@ref) trait.
"""
function shouldstop(hs::AbstractVecOrTuple{H}, a::OptAlgorithm; locals...) where {H<:Hook}
    return any(map(h -> stophook(h, a; locals...), hs))
end

function stophook(h::T, a::OptAlgorithm; locals...) where {T}
    return stophook(StopTrait(T), h, a; locals...)
end
"""
    stophook(h::::IsStoppingCondition, a::OptAlgorithm; locals...)

Raise an error if the hook is a stopping condition but has not implemented `stophook`.
"""
function stophook(::IsStoppingCondition, h::Hook, a::OptAlgorithm; locals...)
    return error(
        "$(typeof(h)) registered as `IsStoppingCondition`, but `stophook` hasn't been " *
        "defined for it.",
    )
end
"""
    stophook(h::::(!IsStoppingCondition), a::OptAlgorithm; locals...)

If the hook isn't a stopping condition, it shouldn't be considered in the OR, so return false.
"""
stophook(::IsNotStoppingCondition, h::Hook, a::OptAlgorithm; locals...) = false

"""
    StopWhen(f::Function)

Stops optimisation when some condition is met.

The condition is set by `f`.
Note that `f` gets access to variables in the [`TheGraphOpt.minimize`](@ref) scope.
This means, for example, that it can use `locals[:z]` to compute residuals.
This has the [`TheGraphOpt.IsStoppingCondition`](@ref) trait.
"""
Base.@kwdef struct StopWhen <: Hook
    f::Function
end
StopTrait(::Type{StopWhen}) = IsStoppingCondition()

"""
    stophook(h::StopWhen, a::OptAlgorithm; locals...)

Call `h.f` on `a` and `;locals`.
"""
stophook(h::StopWhen, a::OptAlgorithm; locals...) = h.f(a; locals...)
