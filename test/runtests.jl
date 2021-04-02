using Test
using CellListsBenchmarks

function test_benchmark_parallel_near_neighbors()
    benchmark_near_neighbors(100, 2, 0.1, 1, 2, 1.0; parallel=false)
    benchmark_near_neighbors(100, 2, 0.1, 1, 2, 1.0; parallel=true)
    @test true
end

test_benchmark_parallel_near_neighbors()
