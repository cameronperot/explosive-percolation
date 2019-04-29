abstract type AbstractGraph end


mutable struct Network <: AbstractGraph
	"""
	Type to house the nodes, edges, and clusters of a network
	Arguments
		`n`            : Total number of nodes in the network
	Keyword Arguments
		`seed`         : Seed value for the random number generator (default = 8)
	Return
		`g`            : A new instance of type `Network`
	Attributes
		`n`            : Total number of nodes in the network
		`t`            : Current step in the evolution process, number of edges in the network
		`edges`        : Set of edges present in the network
		`cluster_ids`  : Dictionary with nodes as keys and cluster IDs as values
		`clusters`     : Dictionary with cluster IDs as keys and clusters as values
		`cluster_sizes`: Dictionary with cluster IDs as keys and clusters sizes as values
		`C`            : Array where `C[t]` is the largest cluster size at step `t-1`
		`rng`          : Random number generator
	"""
	n            ::Int
	t            ::Int
	edges        ::Set{Tuple{Int, Int}}
	cluster_ids  ::Dict{Int64, Int64}
	clusters     ::Dict{Int64, Set{Int64}}
	cluster_sizes::Dict{Int64, Int64}
	C            ::Array{Int, 1}
	rng          ::MersenneTwister
	function Network(n::Int; seed::Int=8)
		t             = 0
		edges         = Set()
		cluster_ids   = Dict(1:n .=> 1:n)
		clusters      = Dict(1:n .=> Set.(1:n))
		cluster_sizes = Dict(1:n .=> 1)
		C             = Int[1]
		rng           = MersenneTwister(seed)
		new(n, t, edges, cluster_ids, clusters, cluster_sizes, C, rng)
	end
end


mutable struct Lattice2D <: AbstractGraph
	"""
	Type to house the nodes, edges, and clusters of a 2D lattice
	Arguments
		`L`            : Side length of the square lattice
	Keyword Arguments
		`seed`         : Seed value for the random number generator (default = 8)
	Return
		`g`            : A new instance of type `Lattice2D`
	Attributes
		`L`            : Side length of the square lattice
		`n`            : Total number of nodes in the lattice, `n = L^2`
		`t`            : Current step in the evolution process, number of edges in the lattice
		`edges`        : Set of edges present in the lattice
		`cluster_ids`  : Dictionary with nodes as keys and cluster IDs as values
		`clusters`     : Dictionary with cluster IDs as keys and clusters as values
		`cluster_sizes`: Dictionary with cluster IDs as keys and clusters sizes as values
		`C`            : Array where `C[t]` is the largest cluster size at step `t-1`
		`rng`          : Random number generator
	"""
	L            ::Int
	n            ::Int
	t            ::Int
	edges        ::Set{Tuple{Tuple{Int, Int}, Tuple{Int, Int}}}
	cluster_ids  ::Dict{Tuple{Int, Int}, Int64}
	clusters     ::Dict{Int64, Set{Tuple{Int, Int}}}
	cluster_sizes::Dict{Int64, Int64}
	C            ::Array{Int, 1}
	rng          ::MersenneTwister
	function Lattice2D(L::Int; seed::Int=8)
		n             = L^2
		t             = 0
		edges         = Set()
		indices       = [(i, j) for i in 1:L, j in 1:L][:]
		cluster_ids   = Dict(indices .=> 1:n)
		clusters      = Dict(1:n .=> Set.([[i] for i in indices]))
		cluster_sizes = Dict(1:n .=> 1)
		C             = Int[1]
		rng           = MersenneTwister(seed)
		indices       = nothing
		new(L, n, t, edges, cluster_ids, clusters, cluster_sizes, C, rng)
	end
end


Base.copy(g::Network) = Network(g.n, g.n_steps)
Base.copy(g::Lattice2D) = Lattice2D(g.n, g.n_steps)
