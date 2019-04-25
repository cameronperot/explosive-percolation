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
	g.P = g.C ./ g.n
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
	g.P = g.C ./ g.n
	return g
end


function bohman_frieze!(g::Graph)
	for t in 1:g.n_steps
	end
end


function product_rule(g_::Graph)
	"""
	Achlioptas process, implementation of da Costa's product rule
	INPUT
		`g_`: An instance of type Graph
	OUTPUT
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)
	for t in 1:g.n_steps
		node₁, node₂ = edge₁ = choose_edge(g)
		node₃, node₄ = edge₂ = choose_edge(g, edge₁)
		if length(g.clusters[g.nodes[node₁]]) * length(g.clusters[g.nodes[node₂]]) < length(g.clusters[g.nodes[node₃]]) * length(g.clusters[g.nodes[node₄]])
			add_edge!(g, edge₁)
			update_clusters!(g, t, edge₁)
		else
			add_edge!(g, edge₂)
			update_clusters!(g, t, edge₂)
		end
	end
	g.P = g.C ./ g.n
	return g
end


function product_rule!(g::Graph)
	"""
	Achlioptas process, implementation of da Costa's product rule
	INPUT
		`g`: An instance of type Graph
	OUTPUT
		None, updates `g` in-place
	"""
	for t in 1:g.n_steps
		node₁, node₂ = edge₁ = choose_edge(g)
		node₃, node₄ = edge₂ = choose_edge(g, edge₁)
		if length(g.clusters[g.nodes[node₁]]) * length(g.clusters[g.nodes[node₂]]) < length(g.clusters[g.nodes[node₃]]) * length(g.clusters[g.nodes[node₄]])
			add_edge!(g, edge₁)
			update_clusters!(g, t, edge₁)
		else
			add_edge!(g, edge₂)
			update_clusters!(g, t, edge₂)
		end
	end
	g.P = g.C ./ g.n
	return g
end


function new_rule!(g::Graph, q::Float64)
	"""
	Stochastic process for adding edges to `g`
	INPUT
		`g`: An instance of type Graph
		`q`: Minimum probability that the chosen edge is accepted
	OUTPUT
		None, updates `g` in-place
	"""
	t = 1
	while t <= g.n_steps
		node₁, node₂ = edge = choose_edge(g)
		r = length(g.clusters[g.nodes[node₁]] ∪ g.clusters[g.nodes[node₂]]) / g.C[t]
		p = maximum((1-r, q))
		if rand(g.rng) < p
			add_edge!(g, edge)
			update_clusters!(g, t, edge)
			t += 1
		end
	end
	g.P = g.C ./ g.n
	return g
end
