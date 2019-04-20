function erdos_renyi(g::Network, τ::Int)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	INPUT
		`g`: An instance of type Network
		`τ`: Total number of edges to add to `g`
	OUTPUT
		`g`: Evolved verion of input `g`
	"""
	for t in 1:τ
		add_edge(g, choose_edge(g))
	end
	g.P = g.C ./ g.n
	return g
end


function bohman_frieze(g::Network, τ::Int)
	for t in 1:τ
end


function product_rule(g::Network, τ::Int)
	"""
	Achlioptas process, implementation of da Costa's product rule
	INPUT
		`g`: An instance of type Network
		`τ`: Total number of edges to add to `g`
	OUTPUT
		`g`: Evolved verion of input `g`
	"""
	for t in 1:τ
		node₁, node₂ = edge₁ = choose_edge(g)
		node₃, node₄ = edge₂ = choose_edge(g)
		while edge₁ == edge₂ # to avoid choosing the same two edges
			node₃, node₄ = edge₂ = choose_edge(g)
		end
		cluster₁ = get_cluster(g, node₁)
		cluster₂ = get_cluster(g, node₂)
		cluster₃ = get_cluster(g, node₃)
		cluster₄ = get_cluster(g, node₄)
		if length(cluster₁) * length(cluster₂) < length(cluster₃) * length(cluster₄)
			add_edge(g, edge)
			merge_clusters(g, cluster₁, cluster₂)
			C = get_largest_cluster_size(g)
			push!(g.C, C)
		else
			add_edge(g, edge)
			merge_clusters(g, cluster₃, cluster₄)
			C = get_largest_cluster_size(g)
			push!(g.C, C)
		end
	end
	g.P = g.C ./ g.n
	return g
end


function new_rule(g::Network, τ::Int, q::Float64)
	"""
	Achlioptas process, stochastic process for adding edges to `g`
	INPUT
		`g`: An instance of type Network
		`τ`: Total number of edges to add to `g`
	OUTPUT
		`g`: Evolved verion of input `g`
	"""
	for t in 1:τ
		node₁, node₂ = edge = choose_edge(g)
		cluster₁ = get_cluster(node₁)
		cluster₂ = get_cluster(node₂)
		C = get_largest_cluster_size(g)
		p = maximum(1-C/g.n, q)
		if rand(g.rng) < p
			add_edge(g, edge)
			merge_clusters(g, cluster₁, cluster₂)
			push!(g.C, maximum(C, length(cluster₁)*length(cluster₂)))
		end
	end
	g.P = g.C ./ g.n
	return g
end
