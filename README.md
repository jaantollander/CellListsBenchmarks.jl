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
Benchmark("cell_list_serial", n, d, r, seed, iterations, seconds)
Benchmark("cell_list_threads", n, d, r, seed, iterations, seconds)
Benchmark("brute_force", n, d, r, seed, iterations, seconds)
Benchmark("cell_lists", n, d, r, seed, iterations, seconds)
Benchmark("near_neighbors_serial", n, d, r, seed, iterations, seconds)
Benchmark("near_neighbors_threads", n, d, r, seed, iterations, seconds)
```
