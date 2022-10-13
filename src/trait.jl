# Copyright 2022-, Semiotic AI, Inc.
# SPDX-License-Identifier: Apache-2.0

export StopTrait, IsStoppingCondition, IsNotStoppingCondition

# Stopping Condition trait

"""
Abstract type for stopping conditions traits
"""
abstract type StopTrait end

"""
Exhibited by hooks that are stopping conditions.
Stopping condition hooks must emit a boolean value when [`TheGraphOpt.stophook`](@ref) is called.
If multiple hooks meet `IsStoppingCondition` are instantiated at the same time, we assume that
they are meant to be OR'ed, so if any of them is true, optimisation is finished.
For more complex behaviour, consider defining a more complex function using a single
[`StopWhen`](@ref).

To set this trait for a hook, run
```julia
julia> StopTrait(::Type{MyHook}) = IsStoppingCondition()
```
"""
struct IsStoppingCondition <: StopTrait end

"""
Exhibited by hooks that are not stopping conditions.
This is the default case.
You should not have to set it manually for any hooks.
"""
struct IsNotStoppingCondition <: StopTrait end

StopTrait(::Type) = IsNotStoppingCondition()
