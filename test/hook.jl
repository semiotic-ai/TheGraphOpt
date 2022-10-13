# Copyright 2022-, Semiotic AI, Inc.
# SPDX-License-Identifier: Apache-2.0

@testset "hook" begin
    struct FakeOptAlg <: TheGraphOpt.OptAlgorithm end
    a = FakeOptAlg()

    @testset "StopWhen" begin
        function counter(h, a)
            i = 0
            while !shouldstop(h, a; Base.@locals()...)
                i += 1
            end
            return i
        end

        h = StopWhen((a; kws...) -> kws[:i] ≥ 5)  # Stop when i ≥ 5
        i = counter((h,), a)
        @test i == 5
    end
end
