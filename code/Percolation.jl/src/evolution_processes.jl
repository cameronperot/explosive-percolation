function erdos_renyi(g_::Graph)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	INPUT
		`g_`: An instance of type Graph
	OUTPUT
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)
	for t in 1:g.n_steps
		edge = choose_edge(g)
		add_edge!(g, edge)
		update_clusters!(g, t, edge)
	end
	return g
end


function erdos_renyi!(g::Graph)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	INPUT
		`g`: An instance of type Graph
	OUTPUT
		None, updates `g` in-place
	"""
	for t in 1:g.n_steps
		edge = choose_edge(g)
		add_edge!(g, edge)
		update_clusters!(g, t, edge)
	end
	return g
end


function bohman_frieze(g_::Graph, K::Int)
	"""
	Achlioptas process, implementation of Bohman-Frieze bounded size rule
	INPUT
		`g_`: An instance of type Graph
		`K` : Bounded size of clusters upon which to determine edge acceptance
	OUTPUT
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		if g.cluster_sizes[g.cluster_ids[edge₁[1]]] < K && g.cluster_sizes[g.cluster_ids[edge₁[2]]] < K
			add_edge!(g, edge₁)
			update_clusters!(g, t, edge₁)
		else
			add_edge!(g, edge₂)
			update_clusters!(g, t, edge₂)
		end
	end
	return g
end


function bohman_frieze!(g::Graph, K::Int)
	"""
	Achlioptas process, implementation of Bohman-Frieze bounded size rule
	INPUT
		`g`: An instance of type Graph
		`K`: Bounded size of clusters upon which to determine edge acceptance
	OUTPUT
		None, updates `g` in-place
	"""
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		if g.cluster_sizes[g.cluster_ids[edge₁[1]]] < K && g.cluster_sizes[g.cluster_ids[edge₁[2]]] < K
			add_edge!(g, edge₁)
			update_clusters!(g, t, edge₁)
		else
			add_edge!(g, edge₂)
			update_clusters!(g, t, edge₂)
		end
	end
	return g
end


function product_rule(g_::Graph)
	"""
	Achlioptas process, implementation of the product rule
	INPUT
		`g_`: An instance of type Graph
	OUTPUT
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		if g.cluster_sizes[g.cluster_ids[edge₁[1]]] * g.cluster_sizes[g.cluster_ids[edge₁[2]]] < g.cluster_sizes[g.cluster_ids[edge₂[1]]] * g.cluster_sizes[g.cluster_ids[edge₂[2]]]
			add_edge!(g, edge₁)
			update_clusters!(g, t, edge₁)
		else
			add_edge!(g, edge₂)
			update_clusters!(g, t, edge₂)
		end
	end
	return g
end


function product_rule!(g::Graph)
	"""
	Achlioptas process, implementation of the product rule
	INPUT
		`g`: An instance of type Graph
	OUTPUT
		None, updates `g` in-place
	"""
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		if g.cluster_sizes[g.cluster_ids[edge₁[1]]] * g.cluster_sizes[g.cluster_ids[edge₁[2]]] < g.cluster_sizes[g.cluster_ids[edge₂[1]]] * g.cluster_sizes[g.cluster_ids[edge₂[2]]]
			add_edge!(g, edge₁)
			update_clusters!(g, t, edge₁)
		else
			add_edge!(g, edge₂)
			update_clusters!(g, t, edge₂)
		end
	end
	return g
end


function new_rule(g_::Graph, q::Float64)
	"""
	Achlioptas process, a probability based rule for accepting edges
	INPUT
		`g_`: An instance of type Graph
		`q` : Minimum probability that edge₁ is accepted
	OUTPUT
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
			update_clusters!(g, t, edge₁)
		else
			add_edge!(g, edge₂)
			update_clusters!(g, t, edge₂)
		end
	end
	return g
end


function new_rule!(g::Graph, q::Float64)
	"""
	Achlioptas process, a probability based rule for accepting edges
	INPUT
		`g`: An instance of type Graph
		`q`: Minimum probability that edge₁ is accepted
	OUTPUT
		None, updates `g` in-place
	"""
	for t in 1:g.n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)
		r = length(g.clusters[g.cluster_ids[edge₁[1]]] ∪ g.clusters[g.cluster_ids[edge₁[2]]]) / g.C[t]
		p = maximum((1-r, q))
		if rand(g.rng) < p
			add_edge!(g, edge₁)
			update_clusters!(g, t, edge₁)
		else
			add_edge!(g, edge₂)
			update_clusters!(g, t, edge₂)
		end
	end
	return g
end
