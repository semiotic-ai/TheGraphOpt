# Copyright 2022-, Semiotic AI, Inc.
# SPDX-License-Identifier: Apache-2.0

export minimize, minimize!

abstract type OptAlgorithm end

"""
    minimize(f::Function, a::OptAlgorithm)

Minimize `f` using `a`.

This will generally be less performant than [`TheGraphOpt.minimize!`](@ref).
However, there are cases in which this will be better, so we provide it as an option.
"""
minimize(f::Function, a::OptAlgorithm) = maybeminimize!(f, a, x)

"""
    minimize!(f::Function, a::OptAlgorithm)

Minimize `f` using `a`.

Does in-place updates of `a.x`.
This will generally be more performant than [`TheGraphOpt.minimize`](@ref).
However, there are cases in which this will be worse, so we provide both.
"""
minimize!(f::Function, a::OptAlgorithm) = maybeminimize!(f, a, x!)

"""
    maybeminimize!(f::Function, a::OptAlgorithm, op::Function)

Minimize `f` using `a`, which calls `op` for updating `a.x`.

This function *may* be in-place.
Don't use it directly unless you know what you're doing.
This function is unexported.
"""
function maybeminimize!(f::Function, a::OptAlgorithm, op::Function)
    z = x(a) .- 1
    while norm(z - x(a)) > ϵ(a)
        a = op(a, z)
        z = iteration(f, a)
    end
    a = op(a, z)
    return a
end
