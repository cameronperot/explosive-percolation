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
		`P`       : Order parameter
		`rng`     : Random number generator
	"""
	n        ::Int
	nodes    ::Set{Int}
	edges    ::Set{Set{Int}}
	clusters ::Set{Set{Int}}
	P        ::Array{Float64, 1}
	rng      ::MersenneTwister
	function Network(n::Int; seed=8)
		nodes    = Set(1:n)
		edges    = Set{Tuple{Int, Int}}()
		clusters = Set([Set(i) for i in 1:n])
		P        = [1/n]
		rng      = MersenneTwister(seed)
		new(n, nodes, edges, clusters, P, rng)
	end
end
