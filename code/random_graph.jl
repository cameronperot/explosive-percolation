using Random
using Plots; gr()
using LaTeXStrings

mutable struct ER
    n::Int # number of vertices
    p::Float64 # probability each edge is open
    e::Array{Int, 2} # e[i, j] = 1 if edge b/w i and j open
    V::Array{Tuple, 1} # array containing random coordinates for vertices
    clusters::Array{Array, 1} # array containing arrays of clustered vertices

    function ER(n::Int, p::Float64; seed::Int=8)
        rng = MersenneTwister(seed)
        e = zeros(Int, (n, n)) # unsure if should be Int8

        # determine which edges are open with probability p
        for i in 1:n
            for j in i+1:n
                e[i, j] = e[j, i] = Int(p > rand(rng))
            end
        end

        # randomly assign vertex coordinates
        V = Tuple[]
        # evenly spaced on edge of circle
        θs = range(0, stop=2π-(2π/n), length=n)
        for θ in θs
            push!(V, (cos(θ), sin(θ)))
        end
        # random in circle
        # rng2 = MersenneTwister(1)
        # for i in 1:n
        #     θ = rand(rng2) * 2π
        #     r = rand(rng2)
        #     x = r * cos(θ)
        #     y = r * sin(θ)
        #     push!(V, (x, y))
        # end

        x = new(n, p, e, V, determine_clusters(e))
    end
end

function determine_clusters(e::Array{Int, 2})
    n = size(e)[1]
    clustered = Int[]
    clusters = Array[]

    # loop over all vertices
    for i in 1:n
        # if vertex not already in a cluster create a new one
        if i ∉ clustered
            new_cluster = Int[]
            push!(new_cluster, i)
            push!(clustered, i)

            # find which vertices the newly clustered vertex is connected to
            for j in i+1:n
                if e[j, i] == 1
                    push!(new_cluster, j)
                    push!(clustered, j)
                end
            end

            # find which vertices the newly clustered vertices are connected to
            for j in new_cluster
                for k in i+1:n
                    if e[k, j] == 1 && k ∉ new_cluster
                        push!(new_cluster, k)
                        push!(clustered, k)
                    end
                end
            end

            push!(clusters, new_cluster)
        end
    end

    return clusters
end

function plot_network(x::ER)
    e = x.e
    V = x.V
    n = size(e)[1]

    # plot the vertices
    pl = plot(title="Erdös-Rényi (n = $n, p = $(round(p, digits=3)))",
              leg=false, ticks=false, border=:none, titlefont="Source Code Pro",
              xaxis=("", (-1.1, 1.1)), yaxis=("", (-1.1, 1.1)),
              aspect_ratio=true, dpi=1200)
    for v in V
        scatter!(v, marker=(:blue, :circle, 10, 0.1, Plots.stroke(0)))
        # annotate!(V[i][1]-0.07, V[i][2]+0.07, "$i", 12)
    end

    # plot the edges
    for i in 1:n
        for j in i+1:n
            if e[i, j] == 1
                x = [V[i][1], V[j][1]]
                y = [V[i][2], V[j][2]]
                plot!(x, y, line=(3, :black, 0.7))
            end
        end
    end

    return pl
end

n = 10
p = 1 / n
@time x = ER(n, p)
savefig(plot_network(x), "x.png")
# TODO - "time step" implementation, color clusters, also return max cluster size from determine_clusters
