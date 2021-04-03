using Base.Threads
using Dates
using Random
using BenchmarkTools
using CellLists

function benchmark_near_neighbors(n::Int, d::Int, r::Float64, seed::Int, iterations::Int, seconds::Float64; parallel::Bool=false)
    @info "Function: benchmark_near_neighbors"
    @info "Arguments" n d r seed iterations nthreads() parallel
    rng = MersenneTwister(seed)
    trials = BenchmarkTools.Trial[]
    time = Time(now())
    @info "Started: $(time)"
    for i in 1:iterations
        @info "Iteration: $(i) / $(iterations)"
        p = rand(rng, n, d)
        c = CellList(p, r)
        if parallel
            t = @benchmark p_near_neighbors($c, $p, $r) seconds=seconds
        else
            t = @benchmark near_neighbors($c, $p, $r) seconds=seconds
        end
        time2 = Time(now())
        @info "Time: $(Time(time2 - time))"
        time = time2
        push!(trials, t)
    end
    @info "Finished: $(Time(now()))"
    return trials
end
