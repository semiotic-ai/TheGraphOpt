module TheGraphOpt

using Base: AbstractVecOrTuple

using Accessors
using LinearAlgebra
using Zygote

abstract type OptAlgorithm end

include("trait.jl")
include("hook.jl")
include("core.jl")
include("gradientdescent.jl")

end
