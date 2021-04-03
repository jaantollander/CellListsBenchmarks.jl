using Test
using CellListsBenchmarks

function test_benchmark_algorithm()
    benchmark_algorithm(brute_force, 100, 2, 0.1, 1, 1, 1.0)
    benchmark_algorithm(cell_lists, 100, 2, 0.1, 1, 1, 1.0)
    @test true
end

function test_benchmark_parallel_near_neighbors()
    benchmark_near_neighbors(100, 2, 0.1, 1, 2, 1.0; parallel=false)
    benchmark_near_neighbors(100, 2, 0.1, 1, 2, 1.0; parallel=true)
    @test true
end

test_benchmark_algorithm()
test_benchmark_parallel_near_neighbors()
