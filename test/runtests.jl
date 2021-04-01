using Test
using Random
using CellListsBenchmarks

function test_benchmark_parallel_near_neighbors()
    rng = MersenneTwister(1)
    benchmark_parallel_near_neighbors(rng, 100, 2, 0.1, 2, 1.0)
    @test true
end

test_benchmark_parallel_near_neighbors()
