abstract type Graph end


mutable struct Network <: Graph
	"""
	Type to house the sets of nodes, edges, and clusters of a network
	INPUT
		`n`       : Total number of nodes in the network
		`n_steps` : Number of edges to add to the graph
		`seed`    : (optional kwarg) Seed value for the random number generator
	OUTPUT
		`g`: A new instance of type Network
	VARIABLES
		`n`       : Total number of nodes in the network
		`n_steps` : Number of edges to add to the graph
		`nodes`   : Dictionary with node IDs as keys and cluster IDs as values
		`edges`   : Set of edges present in the graph
		`clusters`: Dictionary with cluster IDs as keys and clusters as values
		`C`       : Largest cluster size
		`P`       : Order parameter
		`rng`     : Random number generator
	"""
	n        ::Int
	n_steps  ::Int
	nodes    ::Dict{Int64, Int64}
	edges    ::Set{Tuple{Int, Int}}
	clusters ::Dict{Int64, Set{Int64}}
	C        ::Array{Int, 1}
	P        ::Array{Float64, 1}
	rng      ::MersenneTwister
	function Network(n::Int, n_steps::Int; seed::Int=8)
		nodes    = Dict(1:n .=> 1:n)
		edges    = Set()
		clusters = Dict(1:n .=> Set.(1:n))
		C        = zeros(Int, n_steps+1)
		C[1]     = 1
		P        = []
		rng      = MersenneTwister(seed)
		new(n, n_steps, nodes, edges, clusters, C, P, rng)
	end
end
