module CellListsBenchmarks

export benchmark_cell_list_serial
export benchmark_cell_list_parallel
export benchmark_brute_force
export benchmark_cell_lists
export benchmark_near_neighbors_serial
export benchmark_near_neighbors_parallel
export benchmark_functions
export run_benchmark

using Base.Threads
using Dates
using Random
using BenchmarkTools
using CellLists

function brute_force(p::Array{T, 2}, r::T) where T <: AbstractFloat
    ps = Vector{Tuple{Int, Int}}()
    n, d = size(p)
    for i in 1:(n-1)
        for j in (i+1):n
            if @inbounds distance_condition(p[i, :], p[j, :], r)
                push!(ps, (i, j))
            end
        end
    end
    return ps
end

function cell_lists(p::Array{T, 2}, r::T) where T <: AbstractFloat
    c = CellList(p, r)
    return near_neighbors(c, p, r)
end

# --- Benchmarks functions ---

function benchmark_cell_list_serial(rng, n, d, r, seconds)
    p = rand(rng, n, d)
    @benchmark CellList($p, $r) seconds=seconds
end

function benchmark_cell_list_parallel(rng, n, d, r, seconds)
    p = rand(rng, n, d)
    @benchmark CellList($p, $r, $Val(:parallel)) seconds=seconds
end

function benchmark_brute_force(rng, n, d, r, seconds)
    p = rand(rng, n, d)
    @benchmark brute_force($p, $r) seconds=seconds
end

function benchmark_cell_lists(rng, n, d, r, seconds)
    p = rand(rng, n, d)
    @benchmark cell_lists($p, $r) seconds=seconds
end

function benchmark_near_neighbors_serial(rng, n, d, r, seconds)
    p = rand(rng, n, d)
    c = CellList(p, r)
    @benchmark near_neighbors($c, $p, $r) seconds=seconds
end

function benchmark_near_neighbors_parallel(rng, n, d, r, seconds)
    p = rand(rng, n, d)
    c = CellList(p, r)
    @benchmark near_neighbors($c, $p, $r, $Val(:parallel)) seconds=seconds
end

function run_benchmark(benchmark::Function, n::Int, d::Int, r::Float64, seed::Int, iterations::Int, seconds::Float64)
    @info "Function: benchmark_algorithm"
    @info "Arguments" benchmark n d r seed iterations seconds nthreads()
    rng = MersenneTwister(seed)
    trials = BenchmarkTools.Trial[]
    time = Time(now())
    @info "Started: $(time)"
    for i in 1:iterations
        @info "Iteration: $(i) / $(iterations)"
        t = benchmark(rng, n, d, r, seconds)
        time2 = Time(now())
        @info "Time: $(Time(time2 - time))"
        time = time2
        push!(trials, t)
    end
    @info "Finished: $(Time(now()))"
    return trials
end

const benchmark_functions = Dict(
    "cell_list_serial" => benchmark_cell_list_serial,
    "cell_list_parallel" => benchmark_cell_list_parallel,
    "brute_force" => benchmark_brute_force,
    "cell_lists" => benchmark_cell_lists,
    "near_neighbors_serial" => benchmark_near_neighbors_serial,
    "near_neighbors_parallel" => benchmark_near_neighbors_parallel,
)

function run_benchmark(benchmark::String, n::Int, d::Int, r::Float64, seed::Int, iterations::Int, seconds::Float64)
    run_benchmark(benchmark_functions[benchmark], n, d, r, seed, iterations, seconds)
end

end # module
