abstract type Graph end


mutable struct Network <: Graph
	"""
	Type to house the sets of nodes, edges, and clusters of a network
	INPUT
		`n`: Total number of nodes in the network
	OUTPUT
		`g`: A new instance of type Network
	VARIABLES
		`n`       : Number of nodes
		`nodes`   : Set of nodes present in the graph
		`edges`   : Set of edges present in the graph
		`clusters`: Set of clusters present in the graph
		`C`       : Largest cluster size
		`P`       : Order parameter
		`rng`     : Random number generator
	"""
	n        ::Int
	nodes    ::Set{Int}
	edges    ::Set{Tuple{Int, Int}}
	clusters ::Set{Set{Int}}
	C        ::Array{Int, 1}
	P        ::Array{Float64, 1}
	rng      ::MersenneTwister
	function Network(n::Int; seed=8)
		nodes    = Set(1:n)
		edges    = Set()
		clusters = Set([Set(i) for i in 1:n])
		C        = []
		P        = []
		rng      = MersenneTwister(seed)
		new(n, nodes, edges, clusters, C, P, rng)
	end
end
