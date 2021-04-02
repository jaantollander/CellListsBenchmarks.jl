using Base.Threads
using Dates
using Random
using BenchmarkTools
using CellLists

function benchmark_near_neighbors(n::Int, d::Int, r::Float64, seed::Int, iterations::Int, seconds::Float64; parallel::Bool=false)
    @info "Running benchmarks with:" n d r seed iterations nthreads() parallel
    rng = MersenneTwister(seed)
    trials = BenchmarkTools.Trial[]
    time = Time(now())
    @info "Bechmarks started: $(time)"
    for i in 1:iterations
        @info "Iteration: $(i) / $(iterations)"
        p = rand(rng, n, d)
        c = CellList(p, r)
        if parallel
            b = @benchmark p_near_neighbors($c, $p, $r) seconds=seconds
        else
            b = @benchmark near_neighbors($c, $p, $r) seconds=seconds
        end
        time2 = Time(now())
        @info "Time: $(Time(time2 - time))"
        time = time2
        push!(trials, b)
    end
    @info "Benchmarks finished: $(Time(now()))"
    return trials
end