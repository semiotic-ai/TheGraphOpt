module TheGraphOpt

using Base: AbstractVecOrTuple

using Accessors
using Lazy
using LinearAlgebra
using Zygote

abstract type OptAlgorithm end

include("trait.jl")
include("hook.jl")
include("project.jl")
include("core.jl")
include("gradientdescent.jl")
include("projectedgradientdescent.jl")

end
