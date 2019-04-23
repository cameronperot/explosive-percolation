abstract type Graph end


mutable struct Network <: Graph
	"""
	Type to house the sets of nodes, edges, and clusters of a network
	INPUT
		`n`   : Total number of nodes in the network
		`τ`   : (optional kwarg) Number of edges to add to the graph
		`seed`: (optional kwarg) Seed value for the random number generator
	OUTPUT
		`g`: A new instance of type Network
	VARIABLES
		`n`       : Number of nodes
		`τ`       : Number of edges to add to the graph
		`nodes`   : Set of nodes present in the graph
		`edges`   : Set of edges present in the graph
		`clusters`: Set of clusters present in the graph
		`C`       : Largest cluster size
		`P`       : Order parameter
		`rng`     : Random number generator
	"""
	n        ::Int
	τ        ::Int
	nodes    ::Set{Int}
	edges    ::Set{Tuple{Int, Int}}
	clusters ::Set{Set{Int}}
	C        ::Array{Int, 1}
	P        ::Array{Float64, 1}
	rng      ::MersenneTwister
	function Network(n::Int; τ=0, seed=8)
		nodes    = Set(1:n)
		edges    = Set()
		clusters = Set()
		C        = zeros(Int, τ+1)
		C[1]     = 1
		P        = []
		rng      = MersenneTwister(seed)
		new(n, τ, nodes, edges, clusters, C, P, rng)
	end
end
