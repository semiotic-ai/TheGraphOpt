# Copyright 2022-, Semiotic AI, Inc.
# SPDX-License-Identifier: Apache-2.0

export HalpernIteration

"""
    HalpernIteration{T<:Real,V<:AbstractVector{T}} <: Hook

A hook for using [Halpern Iteration](https://projecteuclid.org/journals/bulletin-of-the-american-mathematical-society/volume-73/issue-6/Fixed-points-of-nonexpanding-maps/bams/1183529119.pdf).
in which you should specify the `x₀` and `λ`.

This is an implicitly regularised method.
If you use an algorithm like gradient descent with halpern iteration, you'll converge to
the solution with the minimum ``\ell2`` distance from `x₀`.
"""
Base.@kwdef struct HalpernIteration{T<:Real,V<:AbstractVector{T},F<:Function} <: Hook
    x₀::V
    λ::F
end
PostIterationTrait(::Type{<:HalpernIteration}) = RunAfterIteration()
function postiterationhook(
    ::RunAfterIteration,
    h::HalpernIteration,
    a::OptAlgorithm,
    z::AbstractVector{T};
    locals...,
) where {T<:Real}
    k = locals[:i]
    λₖ = h.λ(k + 1)
    z = λₖ * h.x₀ .+ (1 .- λₖ) * z
    return z
end
