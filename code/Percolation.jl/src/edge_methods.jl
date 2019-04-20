function choose_edge(g::Network)
	"""
	Randomly selects and returns a closed edge in g
	INPUT
		`g`: An instance of type Network
	OUTPUT
		`edge`: A set of two integers representing a closed edge in the graph
	"""
	edge = Set{Int}([rand(g.rng, 1:g.n), rand(g.rng, 1:g.n)])
	if length(edge) == 2 && edge ∉ g.edges
		return edge
	else
		choose_edge(g)
	end
end


function add_edge(g::Network, edge::Set{Int})
	"""
	Adds an edge to g
	INPUT
		`g`   : An instance of type Network
		`edge`: edge to be added to the graph, set of two integers
	OUTPUT
		None, updates g in-place
	"""
	push!(g.edges, edge)
end


function add_edge(g::Network, edge::Tuple{Int, Int})
	"""
	Adds an edge to g
	INPUT
		`g`   : An instance of type Network
		`edge`: edge to be added to the graph, two-tuple of integers
	OUTPUT
		None, updates g in-place
	"""
	push!(g.edges, Set(edge))
end
