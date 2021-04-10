module CellListsBenchmarks

export benchmark_cell_list_serial
export benchmark_cell_list_parallel
export benchmark_brute_force
export benchmark_cell_lists
export benchmark_near_neighbors_serial
export benchmark_near_neighbors_parallel
export benchmark_functions
export run_benchmark
export Benchmark

using Base.Sys
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
    near_neighbors(c, p, r)
end


# --- Benchmark functions ---

function benchmark_cell_list_serial(p, r, seconds)
    @benchmark CellList($p, $r) seconds=seconds
end

function benchmark_cell_list_parallel(p, r, seconds)
    @benchmark CellList($p, $r, $Val(:threads)) seconds=seconds
end

function benchmark_brute_force(p, r, seconds)
    @benchmark brute_force($p, $r) seconds=seconds
end

function benchmark_cell_lists(p, r, seconds)
    @benchmark cell_lists($p, $r) seconds=seconds
end

function benchmark_near_neighbors_serial(p, r, seconds)
    c = CellList(p, r)
    @benchmark near_neighbors($c, $p, $r) seconds=seconds
end

function benchmark_near_neighbors_parallel(p, r, seconds)
    c = CellList(p, r)
    @benchmark near_neighbors($c, $p, $r, $Val(:threads)) seconds=seconds
end

const benchmark_functions = Dict(
    "cell_list_serial" => benchmark_cell_list_serial,
    "cell_list_parallel" => benchmark_cell_list_parallel,
    "brute_force" => benchmark_brute_force,
    "cell_lists" => benchmark_cell_lists,
    "near_neighbors_serial" => benchmark_near_neighbors_serial,
    "near_neighbors_parallel" => benchmark_near_neighbors_parallel,
)


# --- Run benchmark ---

function run_benchmark(benchmark::Function, n::Int, d::Int, r::Float64, seed::Int, iterations::Int, seconds::Float64)
    @info "Function: benchmark_algorithm"
    @info "Arguments" benchmark n d r seed iterations seconds nthreads()
    rng = MersenneTwister(seed)
    trials = BenchmarkTools.Trial[]
    time = Time(now())
    @info "Started: $(time)"
    for i in 1:iterations
        @info "Iteration: $(i) / $(iterations)"
        p = rand(rng, n, d)
        t = benchmark(p, r, seconds)
        time2 = Time(now())
        @info "Time: $(Time(time2 - time))"
        time = time2
        push!(trials, t)
    end
    @info "Finished: $(Time(now()))"
    return trials
end

struct Benchmark
    benchmark::String
    n::Int
    d::Int
    r::Float64
    seed::Int
    trials::Vector{BenchmarkTools.Trial}
    nthreads::Int
    timestamp::DateTime
    version::VersionNumber
    cpu_info::Vector{Sys.CPUinfo}
end

function Benchmark(benchmark::String, n::Int, d::Int, r::Float64, seed::Int, iterations::Int, seconds::Float64)
    trials = run_benchmark(benchmark_functions[benchmark], n, d, r, seed, iterations, seconds)
    Benchmark(benchmark, n, d, r, seed, trials, nthreads(), now(), VERSION, cpu_info())
end

end # module
