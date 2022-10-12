# Copyright 2022-, Semiotic AI, Inc.
# SPDX-License-Identifier: Apache-2.0

@testset "gradientdescent" begin
    g = GradientDescent(x=[100.0, 50.0], η=1e-1)
    @testset "iteration" begin
        f(x) = sum(x .^ 2)
        n = iteration(f, g)
        @test x(n) == [80.0, 40.0]
    end
end
