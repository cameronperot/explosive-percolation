function erdos_renyi(g::Network)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	INPUT
		`g`: An instance of type Network
	OUTPUT
		`g`: Evolved verion of input `g`
	"""
	for t in 1:g.τ
		edge = choose_edge(g)
		add_edge!(g, edge)
		cluster₁ = get_cluster(g, edge[1])
		cluster₂ = get_cluster(g, edge[2])
		update_clusters!(g, t, cluster₁, cluster₂)
	end
	g.P = g.C ./ g.n
	return g
end


function bohman_frieze(g::Network)
	for t in 1:g.τ
	end
end


function product_rule(g::Network)
	"""
	Achlioptas process, implementation of da Costa's product rule
	INPUT
		`g`: An instance of type Network
	OUTPUT
		`g`: Evolved verion of input `g`
	"""
	for t in 1:g.τ
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g)
		cluster₁ = get_cluster(g, edge₁[1])
		cluster₂ = get_cluster(g, edge₁[2])
		cluster₃ = get_cluster(g, edge₂[1])
		cluster₄ = get_cluster(g, edge₂[2])
		if length(cluster₁) * length(cluster₂) < length(cluster₃) * length(cluster₄)
			add_edge!(g, edge₁)
			update_clusters!(g, t, cluster₁, cluster₂)
		else
			add_edge!(g, edge₂)
			update_clusters!(g, t, cluster₃, cluster₄)
		end
	end
	g.P = g.C ./ g.n
	return g
end


function new_rule(g::Network, q::Float64)
	"""
	Achlioptas process, stochastic process for adding edges to `g`
	INPUT
		`g`: An instance of type Network
		`q`: Minimum probability that the chosen edge is accepted
	OUTPUT
		`g`: Evolved verion of input `g`
	"""
	for t in 1:g.τ
		edge = choose_edge(g)
		cluster₁ = get_cluster(edge[1])
		cluster₂ = get_cluster(edge[2])
		merged_cluster = cluster₁ ∪ cluster₂
		r = length(merged_cluster) / g.C[t]
		p = maximum(1-r, q)
		if rand(g.rng) < p
			add_edge!(g, edge)
			update_clusters!(g, t, cluster₁, cluster₂, merged_cluster)
		end
	end
	g.P = g.C ./ g.n
	return g
end
