export GradientDescent, iteration, x, η

Base.@kwdef struct GradientDescent{T<:Real}
    x::Vector{T}
    η::T
end

x(g::GradientDescent) = g.x
η(g::GradientDescent) = g.η

function iteration(f::Function, g::GradientDescent)
    ∇f = Zygote.gradient(f, x(g)) |> first
    z = x(g) .- η(g) * ∇f
    n = @set g.x = z
    return n
end
