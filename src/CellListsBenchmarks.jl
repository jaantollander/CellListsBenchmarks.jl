module CellListsBenchmarks

export cell_list_serial, cell_list_parallel
export brute_force, cell_lists
export benchmark_algorithm, benchmark_near_neighbors

using Base.Threads
using Dates
using Random
using BenchmarkTools
using CellLists

cell_list_serial(p, r) = CellList(p, r)
cell_list_parallel(p, r) = CellList(p, r, Val(:parallel))

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

function benchmark_algorithm(algorithm::Function, n::Int, d::Int, r::Float64, seed::Int, iterations::Int, seconds::Float64)
    @info "Function: benchmark_algorithm"
    @info "Arguments" algorithm n d r seed iterations seconds nthreads()
    rng = MersenneTwister(seed)
    trials = BenchmarkTools.Trial[]
    time = Time(now())
    @info "Started: $(time)"
    for i in 1:iterations
        @info "Iteration: $(i) / $(iterations)"
        p = rand(rng, n, d)
        t = @benchmark $algorithm($p, $r) seconds=seconds
        time2 = Time(now())
        @info "Time: $(Time(time2 - time))"
        time = time2
        push!(trials, t)
    end
    @info "Finished: $(Time(now()))"
    return trials
end

function benchmark_near_neighbors(n::Int, d::Int, r::Float64, seed::Int, iterations::Int, seconds::Float64; parallel::Bool=false)
    @info "Function: benchmark_near_neighbors"
    @info "Arguments" n d r seed iterations seconds parallel nthreads()
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

end # module
