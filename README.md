# CellListsBenchmarks.jl
Benchmarks for the [CellLists.jl](https://github.com/jaantollander/CellLists.jl) package.

## Usage
```julia
using CellListsBenchmarks

n = 100
d = 2
r = 0.1
seed = 1
iterations = 1
seconds = 1.0
run_benchmark(benchmark_cell_list_serial, n, d, r, seed, iterations, seconds)
run_benchmark(benchmark_cell_list_parallel, n, d, r, seed, iterations, seconds)
run_benchmark(benchmark_brute_force, n, d, r, seed, iterations, seconds)
run_benchmark(benchmark_cell_lists, n, d, r, seed, iterations, seconds)
run_benchmark(benchmark_near_neighbors_serial, n, d, r, seed, iterations, seconds)
run_benchmark(benchmark_near_neighbors_parallel, n, d, r, seed, iterations, seconds)
```
