using Test
using CellLists
using CellListsBenchmarks

benchmark_algorithm(cell_list_serial, 100, 2, 0.1, 1, 1, 1.0)
benchmark_algorithm(cell_list_parallel, 100, 2, 0.1, 1, 1, 1.0)
benchmark_algorithm(brute_force, 100, 2, 0.1, 1, 1, 1.0)
benchmark_algorithm(cell_lists, 100, 2, 0.1, 1, 1, 1.0)
benchmark_near_neighbors(near_neighbors, 100, 2, 0.1, 1, 2, 1.0)
benchmark_near_neighbors(p_near_neighbors, 100, 2, 0.1, 1, 2, 1.0)
@test true
