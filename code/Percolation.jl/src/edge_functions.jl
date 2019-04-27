function choose_edge(g::Network)
	"""
	Randomly selects an inactive edge in `g`
	INPUT
		`g`   : An instance of type Network
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
		`g`    : An instance of type Network
		`edge₁`: A two-tuple of integers representing an inactive edge in `g`
	OUTPUT
		`edge₂`: A two-tuple of integers representing an inactive edge in `g`
	"""
	edge₂ = choose_edge(g)
	if edge₂ ≠ edge₁ && edge₂ ≠ reverse(edge₁)
		return edge₂
	else
		choose_edge(g, edge₁)
	end
end


function choose_edge(g::Lattice2D)
	"""
	Randomly selects an inactive edge in `g`
	INPUT
		`g`   : An instance of type Lattice2D
	OUTPUT
		`edge`: A two-tuple of two-tuples of integers representing an inactive edge in `g`
	"""
	node     = (rand(g.rng, 1:g.L), rand(g.rng, 1:g.L))
	neighbor = nearest_neighbors(g, node)[rand(g.rng, 1:4)]
	edge     = (node, neighbor)
	if edge ∉ g.edges
		return edge
	else
		choose_edge(g)
	end
end


function choose_edge(g::Lattice2D, edge₁::Tuple{Tuple{Int, Int}, Tuple{Int, Int}})
	"""
	Randomly selects an inactive edge in `g` that is not equal to `edge₁`
	INPUT
		`g`    : An instance of type Lattice2D
		`edge₁`: A two-tuple of two-tuples of integers representing an inactive edge in `g`
	OUTPUT
		`edge₂`: A two-tuple of two-tuples of integers representing an inactive edge in `g`
	"""
	edge₂ = choose_edge(g)
	if edge₂ ≠ edge₁ && edge₂ ≠ reverse(edge₁)
		return edge₂
	else
		choose_edge(g, edge₁)
	end
end


function add_edge!(g::Graph, edge::Tuple)
	"""
	Adds an edge to `g`
	INPUT
		`g`   : An instance of type Graph
		`edge`: A two-tuple of integers representing the edge to be added to `g`
	OUTPUT
		None, updates `g` in-place
	"""
	push!(g.edges, edge)
	push!(g.edges, reverse(edge))
end


"""
Functions plus and minus are an implementation of periodic boundary conditions for use in the `nearest_neighbors` function below
"""
function plus(g::Lattice2D, i::Int)
	i == g.L ? 1 : i+1
end
function minus(g::Lattice2D, i::Int)
	i == 1 ? g.L : i-1
end


function nearest_neighbors(g::Lattice2D, node::Tuple{Int, Int})
	"""
	Determines the next-nearest neighbors of `node`
	INPUT
		`g`        : An instance of type Lattice2D
		`node`     : A two-tuple of integers representing a node in `g`
	OUTPUT
		`neighbors`: A four-tuple of two-tuples of integers representing the cartesian indices of the (up, down, left, right) neighbors
	"""
	return ((minus(g, node[1]), node[2]), (plus(g, node[1]), node[2]), (node[1], minus(g, node[2])), (node[1], plus(g, node[2])))
end
