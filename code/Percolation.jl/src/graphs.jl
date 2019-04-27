abstract type Graph end


mutable struct Network <: Graph
	"""
	Type to house the sets of nodes, edges, and clusters of a network
	INPUT
		`n`            : Total number of nodes in the network
		`n_steps`      : Number of edges to add to the graph
		`seed`         : (optional kwarg) Seed value for the random number generator
	OUTPUT
		`g`            : A new instance of type `Network`
	VARIABLES
		`n`            : Total number of nodes in the network
		`n_steps`      : Number of edges to add to the graph
		`nodes`        : Dictionary with node IDs as keys and cluster IDs as values
		`edges`        : Set of edges present in the graph
		`clusters`     : Dictionary with cluster IDs as keys and clusters as values
		`cluster_sizes`: Dictionary with cluster IDs as keys and clusters sizes as values
		`C`            : Array where `C[t]` is the largest cluster size at step `t`
		`P`            : Array where `P[t]` is the order parameter at step `t`
		`rng`          : Random number generator
	"""
	n            ::Int
	n_steps      ::Int
	nodes        ::Dict{Int64, Int64}
	edges        ::Set{Tuple{Int, Int}}
	clusters     ::Dict{Int64, Set{Int64}}
	cluster_sizes::Dict{Int64, Int64}
	C            ::Array{Int, 1}
	rng          ::MersenneTwister
	function Network(n::Int, n_steps::Int; seed::Int=8)
		nodes         = Dict(1:n .=> 1:n)
		edges         = Set()
		clusters      = Dict(1:n .=> Set.(1:n))
		cluster_sizes = Dict(1:n .=> 1)
		C             = zeros(Int, n_steps+1)
		C[1]          = 1
		rng           = MersenneTwister(seed)
		new(n, n_steps, nodes, edges, clusters, cluster_sizes, C, rng)
	end
end


mutable struct Lattice2D <: Graph
	"""
	Type to house the sets of nodes, edges, and clusters of a 2D lattice
	INPUT
		`L`            : Side length of the square lattice
		`n_steps`      : Number of edges to add to the graph
		`seed`         : (optional kwarg) Seed value for the random number generator
	OUTPUT
		`g`            : A new instance of type `Lattice2D`
	VARIABLES
		`L`            : Side length of the square lattice
		`n`            : Total number of nodes in the lattice, `n = L^2`
		`n_steps`      : Number of edges to add to the graph
		`nodes`        : Dictionary with node IDs as keys and cluster IDs as values
		`edges`        : Set of edges present in the graph
		`clusters`     : Dictionary with cluster IDs as keys and clusters as values
		`cluster_sizes`: Dictionary with cluster IDs as keys and clusters sizes as values
		`C`            : Array where `C[t]` is the largest cluster size at step `t`
		`P`            : Array where `P[t]` is the order parameter at step `t`
		`rng`          : Random number generator
	"""
	L            ::Int
	n            ::Int
	n_steps      ::Int
	nodes        ::Dict{Tuple{Int, Int}, Int64}
	edges        ::Set{Tuple{Tuple{Int, Int}, Tuple{Int, Int}}}
	clusters     ::Dict{Int64, Set{Tuple{Int, Int}}}
	cluster_sizes::Dict{Int64, Int64}
	C            ::Array{Int, 1}
	rng          ::MersenneTwister
	function Lattice2D(L::Int, n_steps::Int; seed::Int=8)
		indices       = [(i, j) for i in 1:L, j in 1:L][:]
		n             = L^2
		nodes         = Dict(indices .=> 1:n)
		edges         = Set()
		clusters      = Dict(1:n .=> Set.([[i] for i in indices]))
		cluster_sizes = Dict(1:n .=> 1)
		C             = zeros(Int, n_steps+1)
		C[1]          = 1
		rng           = MersenneTwister(seed)
		indices       = []
		new(L, n, n_steps, nodes, edges, clusters, cluster_sizes, C, rng)
	end
end


Base.copy(g::Network) = Network(g.n, g.n_steps)
Base.copy(g::Lattice2D) = Lattice2D(g.n, g.n_steps)
