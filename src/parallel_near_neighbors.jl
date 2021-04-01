using Base.Threads
using Dates
using Random
using BenchmarkTools
using CellLists

function benchmark_parallel_near_neighbors(rng::AbstractRNG, n::Int, d::Int, r::Float64, iterations::Int, seconds::Float64)
    @info "Running benchmarks with:" n d r iterations nthreads()
    ts = BenchmarkTools.Trial[]
    tp = BenchmarkTools.Trial[]
    for i in 1:iterations
        @info "Iteration: $(i) / $(iterations) | Time: $(Time(now()))"
        p = rand(rng, n, d)
        c = CellList(p, r)
        bs = @benchmark near_neighbors($c, $p, $r) seconds=seconds
        bp = @benchmark p_near_neighbors($c, $p, $r) seconds=seconds
        push!(ts, bs)
        push!(tp, bp)
    end
    @info "Benchmarks finished: $(Time(now()))"
    return ts, tp
end
