using Distributed; addprocs()
@everywhere using DistributedArrays
@everywhere using Random
using Statistics
using JLD


@everywhere mutable struct Ising
	L           ::Int
	σ           ::Array{Int}
	β           ::Float64
	J           ::Float64
	E_          ::Float64
	E           ::Array{Float64}
	M_          ::Float64
	M           ::Array{Float64}
	n_sweeps    ::Int
	total_flips ::Int
	rng         ::MersenneTwister

	function Ising(L, β; J=1., start="cold", n_sweeps=5*10^4, seed=8)
		rng = MersenneTwister(seed)

		if start == "cold"
			σ = ones(Int, (L, L))
		elseif start == "hot"
			σ = rand(rng, Int[-1, 1], (L, L))
		end

		E₀ = 0
		for j in 1:L
			left  = j == 1 ? L : j-1
			right = j == L ? 1 : j+1
			for i in 1:L
				up   = i == 1 ? L : i-1
				down = i == L ? 1 : i+1
				E₀ += σ[i, j] * (σ[up, j] + σ[down, j]
								 + σ[i, left] + σ[i, right])
			end
		end
		E₀ *= -0.5J
		M₀ = sum(σ)

		E  = Array{Float64, 1}(undef, n_sweeps)
		M  = Array{Float64, 1}(undef, n_sweeps)
		new(L, σ, β, J, E₀, E, M₀, M, n_sweeps, 0, rng)
	end
end


@everywhere function update_observables!(I::Ising, t::Int)
	I.E[t] = I.E_
	I.M[t] = I.M_
end


@everywhere function Wolff!(I::Ising, n_clusters::Int; cutoff::Float64=0.075)
	p = 1 - exp(-2I.β)
	total_flips = 0
	t₀ = Int(floor(cutoff * I.n_sweeps))
	minus(i) = i == 1 ? I.L : i-1
	plus(i)  = i == I.L ? 1 : i+1

	for t in 1:I.n_sweeps
		for n in 1:n_clusters
			i₀, j₀ = rand(I.rng, 1:I.L), rand(I.rng, 1:I.L)
			cluster_orientation = I.σ[i₀, j₀]
			I.σ[i₀, j₀] *= -1
			cluster = Tuple{Int, Int}[(i₀, j₀)]

			ΔE = 2I.J * cluster_orientation *
				(I.σ[minus(i₀), j₀] + I.σ[plus(i₀), j₀] +
				I.σ[i₀, minus(j₀)] + I.σ[i₀, plus(j₀)])
			I.E_ += ΔE
			I.M_ += 2I.σ[i₀, j₀]

			for node in cluster
				i, j = node
				neighbors = Tuple{Int, Int}[(minus(i), j), (plus(i), j),
					(i, minus(j)), (i, plus(j))]

				for neighbor in neighbors
					k, l = neighbor

					if I.σ[k, l] == cluster_orientation && p > rand(I.rng)
						I.σ[k, l] *= -1
						push!(cluster, (k, l))

						ΔE = 2I.J * cluster_orientation *
							(I.σ[minus(k), l] + I.σ[plus(k), l] +
							I.σ[k, minus(l)] + I.σ[k, plus(l)])
						I.E_ += ΔE
						I.M_ -= 2cluster_orientation
					end
				end
			end

			I.total_flips += length(cluster)
		end

		t > t₀ ? update_observables!(I, t) : continue
	end

	I.E = I.E[t₀+1:end]
	I.M = I.M[t₀+1:end]
	return I
end


# %%


L = 128
βc = log(1 + √2) / 2
I = Ising(L, βc)
path = "/home/user/rsync/programming/uni/electives/computer-simulation-ii/hw-03/"
acs = load(string(path, "avg_cluster_sizes.jld"), "avg_cluster_sizes")
@time Wolff!(I, Int(ceil(L^2 / acs[64, βc])))


# %%


using Plots; gr()
heatmap(I.σ.*-1,
	c=:greys,
	dpi=100,
	aspect_ratio=true,
	legend=false,
	framestyle=:box,
	xaxis=false,
	yaxis=false)

savepath = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/latex/images/"
savefig(string(savepath, "Ising-128-percolation.png"))
