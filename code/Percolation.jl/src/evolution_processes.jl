function erdos_renyi(g_::AbstractGraph)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	Arguments:
		`g_`: An instance of type AbstractGraph
	Output:
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)
	for t in 1:g.n_steps
		edge = choose_edge(g)
		add_edge!(g, edge)
	end
	return g
end


function erdos_renyi!(g::AbstractGraph)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	Arguments:
		`g`: An instance of type AbstractGraph
	Output:
		None, updates `g` in-place
	"""
	for t in 1:g.n_steps
		edge = choose_edge(g)
		add_edge!(g, edge)
	end
	return g
end


function bohman_frieze(g_::AbstractGraph, K::Int)
	"""
	Achlioptas process, implementation of Bohman-Frieze bounded size rule
	Arguments:
		`g_`: An instance of type AbstractGraph
		`K` : Bounded size of clusters upon which to determine edge acceptance
	Output:
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		if g.cluster_sizes[g.cluster_ids[edge₁[1]]] < K && g.cluster_sizes[g.cluster_ids[edge₁[2]]] < K
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end
	return g
end


function bohman_frieze!(g::AbstractGraph, K::Int)
	"""
	Achlioptas process, implementation of Bohman-Frieze bounded size rule
	Arguments:
		`g`: An instance of type AbstractGraph
		`K`: Bounded size of clusters upon which to determine edge acceptance
	Output:
		None, updates `g` in-place
	"""
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		if g.cluster_sizes[g.cluster_ids[edge₁[1]]] < K && g.cluster_sizes[g.cluster_ids[edge₁[2]]] < K
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end
	return g
end


function product_rule(g_::AbstractGraph)
	"""
	Achlioptas process, implementation of the product rule
	Arguments:
		`g_`: An instance of type AbstractGraph
	Output:
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		if g.cluster_sizes[g.cluster_ids[edge₁[1]]] * g.cluster_sizes[g.cluster_ids[edge₁[2]]] < g.cluster_sizes[g.cluster_ids[edge₂[1]]] * g.cluster_sizes[g.cluster_ids[edge₂[2]]]
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end
	return g
end


function product_rule!(g::AbstractGraph)
	"""
	Achlioptas process, implementation of the product rule
	Arguments:
		`g`: An instance of type AbstractGraph
	Output:
		None, updates `g` in-place
	"""
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		if g.cluster_sizes[g.cluster_ids[edge₁[1]]] * g.cluster_sizes[g.cluster_ids[edge₁[2]]] < g.cluster_sizes[g.cluster_ids[edge₂[1]]] * g.cluster_sizes[g.cluster_ids[edge₂[2]]]
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end
	return g
end


function new_rule(g_::AbstractGraph, q::Float64)
	"""
	Achlioptas process, a probability based rule for accepting edges
	Arguments:
		`g_`: An instance of type AbstractGraph
		`q` : Minimum probability that edge₁ is accepted
	Output:
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		r = length(g.clusters[g.cluster_ids[edge₁[1]]] ∪ g.clusters[g.cluster_ids[edge₁[2]]]) / g.C[t]
		p = maximum((1-r, q))
		if rand(g.rng) < p
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end
	return g
end


function new_rule!(g::AbstractGraph, q::Float64)
	"""
	Achlioptas process, a probability based rule for accepting edges
	Arguments:
		`g`: An instance of type AbstractGraph
		`q`: Minimum probability that edge₁ is accepted
	Output:
		None, updates `g` in-place
	"""
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		r = length(g.clusters[g.cluster_ids[edge₁[1]]] ∪ g.clusters[g.cluster_ids[edge₁[2]]]) / g.C[t]
		p = maximum((1-r, q))
		if rand(g.rng) < p
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end
	return g
end
