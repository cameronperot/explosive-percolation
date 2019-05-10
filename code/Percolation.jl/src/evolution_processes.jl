function erdos_renyi(g_::AbstractGraph, n_steps::Int)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	Arguments
		`g_`     : An instance of type AbstractGraph
		`n_steps`: Number of edges to add to the AbstractGraph
	Return
		`g`      : An evolved instance of `g_`
	"""

	g = copy(g_)

	for t in 1:n_steps
		edge = choose_edge(g)
		add_edge!(g, edge)
	end

	return g

end


function erdos_renyi!(g::AbstractGraph, n_steps::Int)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	Arguments
		`g`      : An instance of type AbstractGraph
		`n_steps`: Number of edges to add to the AbstractGraph
	Return
		None, updates `g` in-place
	"""

	for t in 1:n_steps
		edge = choose_edge(g)
		add_edge!(g, edge)
	end

	return g

end


function bohman_frieze(g_::AbstractGraph, n_steps::Int; K::Int=2)
	"""
	Achlioptas process, implementation of Bohman-Frieze bounded size rule
	Arguments
		`g_`     : An instance of type AbstractGraph
		`n_steps`: Number of edges to add to the AbstractGraph
	Keyword Arguments
		`K`      : Bounded size of clusters upon which to determine edge acceptance (default = 1)
	Return
		`g` : An evolved instance of `g_`
	"""
	
	g = copy(g_)

	for t in 1:n_steps

		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if length(g.clusters[g.cluster_ids[edge₁[1]]]) < K && length(g.clusters[g.cluster_ids[edge₁[2]]]) < K
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end

	end

	return g

end


function bohman_frieze!(g::AbstractGraph, n_steps::Int; K::Int=2)
	"""
	Achlioptas process, implementation of Bohman-Frieze bounded size rule
	Arguments
		`g`      : An instance of type AbstractGraph
		`n_steps`: Number of edges to add to the AbstractGraph
	Keyword Arguments
		`K`      : Bounded size of clusters upon which to determine edge acceptance (default = 1)
	Return
		None, updates `g` in-place
	"""

	for t in 1:n_steps

		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if length(g.clusters[g.cluster_ids[edge₁[1]]]) < K && length(g.clusters[g.cluster_ids[edge₁[2]]]) < K
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end

	end

	return g

end


function product_rule(g_::AbstractGraph, n_steps::Int)
	"""
	Achlioptas process, implementation of the product rule
	Arguments
		`g_`     : An instance of type AbstractGraph
		`n_steps`: Number of edges to add to the AbstractGraph
	Return
		`g`      : An evolved instance of `g_`
	"""

	g = copy(g_)

	for t in 1:n_steps

		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if length(g.clusters[g.cluster_ids[edge₁[1]]]) * length(g.clusters[g.cluster_ids[edge₁[2]]]) < length(g.clusters[g.cluster_ids[edge₂[1]]]) * length(g.clusters[g.cluster_ids[edge₂[2]]])
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end

	end

	return g

end


function product_rule!(g::AbstractGraph, n_steps::Int)
	"""
	Achlioptas process, implementation of the product rule
	Arguments
		`g`      : An instance of type AbstractGraph
		`n_steps`: Number of edges to add to the AbstractGraph
	Return
		None, updates `g` in-place
	"""

	for t in 1:n_steps

		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if length(g.clusters[g.cluster_ids[edge₁[1]]]) * length(g.clusters[g.cluster_ids[edge₁[2]]]) < length(g.clusters[g.cluster_ids[edge₂[1]]]) * length(g.clusters[g.cluster_ids[edge₂[2]]])
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end

	end

	return g

end


function p_rule_1!(g::AbstractGraph, n_steps::Int, q::Float64)
	"""
	Achlioptas process, a probability based rule for accepting edges
	Arguments
		`g`      : An instance of type AbstractGraph
		`n_steps`: Number of edges to add to the AbstractGraph
		`q`      : Minimum probability that edge₁ is accepted
	Return
		None, updates `g` in-place
	"""

	for t in 1:n_steps

		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if g.cluster_ids[edge₁[1]] == g.cluster_ids[edge₁[2]]
			add_edge!(g, edge₁)
		elseif maximum((1 - (length(g.clusters[g.cluster_ids[edge₁[1]]]) +
			length(g.clusters[g.cluster_ids[edge₁[2]]])) / g.C[t], q)) < rand(g.rng)
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end

	end

	return g

end


function p_rule_2!(g::AbstractGraph, n_steps::Int)
	"""
	Achlioptas process, a probability based rule for accepting edges
	Arguments
		`g`      : An instance of type AbstractGraph
		`n_steps`: Number of edges to add to the AbstractGraph
		`q`      : Minimum probability that edge₁ is accepted
	Return
		None, updates `g` in-place
	"""

	for t in 1:n_steps

		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if g.cluster_ids[edge₁[1]] == g.cluster_ids[edge₁[2]]
			add_edge!(g, edge₁)
		elseif g.cluster_ids[edge₂[1]] == g.cluster_ids[edge₂[2]]
			add_edge!(g, edge₂)
		else
			C₁ = length(g.clusters[g.cluster_ids[edge₁[1]]]) + length(g.clusters[g.cluster_ids[edge₁[2]]])
			C₂ = length(g.clusters[g.cluster_ids[edge₂[1]]]) + length(g.clusters[g.cluster_ids[edge₂[2]]])
			p = (1 / C₁) / (1 / C₁ + 1 / C₂)

			if p > rand(g.rng)
				add_edge(g, edge₁)
			else
				add_edge(g, edge₂)
			end
		end

	end

	return g

end
