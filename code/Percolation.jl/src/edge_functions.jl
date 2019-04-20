function choose_edge(g::Network)
	"""
	Randomly selects an inactive edge in `g`
	INPUT
		`g`: An instance of type Network
	OUTPUT
		`edge`: A set of two integers representing an inactive edge in `g`
	"""
	edge = (rand(g.rng, 1:g.n), rand(g.rng, 1:g.n))
	if edge[1] != edge[2] && edge ∉ g.edges
		return edge
	else
		choose_edge(g)
	end
end


function add_edge(g::Network, edge::Tuple{Int, Int})
	"""
	Adds an edge to `g`
	INPUT
		`g`   : An instance of type Network
		`edge`: edge to be added to `g``, two-tuple of integers
	OUTPUT
		None, updates `g` in-place
	"""
	push!(g.edges, edge)
	push!(g.edges, (edge[2], edge[1]))
end
