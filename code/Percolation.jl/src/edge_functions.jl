function choose_edge(g::Network)
	"""
	Randomly selects an inactive edge in `g`
	INPUT
		`g`: An instance of type Network
	OUTPUT
		`edge`: A two-tuple of integers representing an inactive edge in `g`
	"""
	edge = (rand(g.rng, 1:g.n), rand(g.rng, 1:g.n))
	if edge[1] ≠ edge[2] && edge ∉ g.edges
		return edge
	else
		choose_edge(g)
	end
end


function choose_edge(g::Network, edge₁::Tuple{Int, Int})
	"""
	Randomly selects an inactive edge in `g` that is not equal to `edge₁`
	INPUT
		`g`: An instance of type Network
		`edge₁`: A two-tuple of integers representing an inactive edge in `g`
	OUTPUT
		`edge₂`: A two-tuple of integers representing an inactive edge in `g`
	"""
	edge₂ = (rand(g.rng, 1:g.n), rand(g.rng, 1:g.n))
	if edge₂[1] ≠ edge₂[2] && edge₂ ≠ edge₁ && edge₂ ≠ reverse(edge₁) && edge₂ ∉ g.edges
		return edge₂
	else
		choose_edge(g, edge₁)
	end
end


function add_edge!(g::Network, edge::Tuple{Int, Int})
	"""
	Adds an edge to `g`
	INPUT
		`g`   : An instance of type Network
		`edge`: edge to be added to `g``, two-tuple of integers
	OUTPUT
		None, updates `g` in-place
	"""
	push!(g.edges, edge)
	push!(g.edges, reverse(edge))
end
