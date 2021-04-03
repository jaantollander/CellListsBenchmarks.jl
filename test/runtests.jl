using Test
using CellLists
using CellListsBenchmarks

n = 100
d = 2
r = 0.1
seed = 1
iterations = 1
seconds = 1.0
benchmark_algorithm(cell_list_serial, n, d, r, seed, iterations, seconds)
benchmark_algorithm(cell_list_parallel, n, d, r, seed, iterations, seconds)
benchmark_algorithm(brute_force, n, d, r, seed, iterations, seconds)
benchmark_algorithm(cell_lists, n, d, r, seed, iterations, seconds)
benchmark_near_neighbors(near_neighbors, n, d, r, seed, iterations, seconds)
benchmark_near_neighbors(p_near_neighbors, n, d, r, seed, iterations, seconds)
@test true
