function erdos_renyi(g_::AbstractNetwork, n_steps::Int)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	Arguments
		`g_`     : An instance of type AbstractNetwork
		`n_steps`: Number of edges to add to the AbstractNetwork
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


function erdos_renyi!(g::AbstractNetwork, n_steps::Int)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	Arguments
		`g`      : An instance of type AbstractNetwork
		`n_steps`: Number of edges to add to the AbstractNetwork
	Return
		None, updates `g` in-place
	"""
	for t in 1:n_steps
		edge = choose_edge(g)
		add_edge!(g, edge)
	end

	return g
end


function bohman_frieze(g_::AbstractNetwork, n_steps::Int; K::Int=1)
	"""
	Achlioptas process, implementation of Bohman-Frieze bounded size rule
	Arguments
		`g_`     : An instance of type AbstractNetwork
		`n_steps`: Number of edges to add to the AbstractNetwork
	Keyword Arguments
		`K`      : Bounded size of clusters upon which to determine edge acceptance (default = 1)
	Return
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)

	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if g.cluster_sizes[g.cluster_ids[edge₁[1]]] ≤ K && g.cluster_sizes[g.cluster_ids[edge₁[2]]] ≤ K
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end

	return g
end


function bohman_frieze!(g::AbstractNetwork, n_steps::Int; K::Int=1)
	"""
	Achlioptas process, implementation of Bohman-Frieze bounded size rule
	Arguments
		`g`      : An instance of type AbstractNetwork
		`n_steps`: Number of edges to add to the AbstractNetwork
	Keyword Arguments
		`K`      : Bounded size of clusters upon which to determine edge acceptance (default = 1)
	Return
		None, updates `g` in-place
	"""
	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if g.cluster_sizes[g.cluster_ids[edge₁[1]]] ≤ K && g.cluster_sizes[g.cluster_ids[edge₁[2]]] ≤ K
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end

	return g
end


function product_rule(g_::AbstractNetwork, n_steps::Int)
	"""
	Achlioptas process, implementation of the product rule
	Arguments
		`g_`     : An instance of type AbstractNetwork
		`n_steps`: Number of edges to add to the AbstractNetwork
	Return
		`g`      : An evolved instance of `g_`
	"""
	g = copy(g_)

	for t in 1:n_steps
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


function product_rule!(g::AbstractNetwork, n_steps::Int)
	"""
	Achlioptas process, implementation of the product rule
	Arguments
		`g`      : An instance of type AbstractNetwork
		`n_steps`: Number of edges to add to the AbstractNetwork
	Return
		None, updates `g` in-place
	"""
	for t in 1:n_steps
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


function new_rule(g_::AbstractNetwork, n_steps::Int, q::Float64)
	"""
	Achlioptas process, a probability based rule for accepting edges
	Arguments
		`g_`     : An instance of type AbstractNetwork
		`n_steps`: Number of edges to add to the AbstractNetwork
		`q`      : Minimum probability that edge₁ is accepted
	Return
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)

	for t in 1:n_steps
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


function new_rule!(g::AbstractNetwork, n_steps::Int, q::Float64)
	"""
	Achlioptas process, a probability based rule for accepting edges
	Arguments
		`g`      : An instance of type AbstractNetwork
		`n_steps`: Number of edges to add to the AbstractNetwork
		`q`      : Minimum probability that edge₁ is accepted
	Return
		None, updates `g` in-place
	"""
	for t in 1:n_steps
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


function erdos_renyi(g_::AbstractLattice, n_steps::Int)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	Arguments
		`g_`     : An instance of type AbstractLattice
		`n_steps`: Number of edges to add to the AbstractLattice
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


function erdos_renyi!(g::AbstractLattice, n_steps::Int)
	"""
	Erdos-Renyi style graph evolution, adds edges randomly at each step
	Arguments
		`g`      : An instance of type AbstractLattice
		`n_steps`: Number of edges to add to the AbstractLattice
	Return
		None, updates `g` in-place
	"""
	for t in 1:n_steps
		edge = choose_edge(g)
		add_edge!(g, edge)
	end

	return g
end


function bohman_frieze(g_::AbstractLattice, n_steps::Int; K::Int=1)
	"""
	Achlioptas process, implementation of Bohman-Frieze bounded size rule
	Arguments
		`g_`     : An instance of type AbstractLattice
		`n_steps`: Number of edges to add to the AbstractLattice
	Keyword Arguments
		`K`      : Bounded size of clusters upon which to determine edge acceptance (default = 1)
	Return
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)

	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if g.cluster_sizes[g.cluster_ids[edge₁[1]...]] ≤ K && g.cluster_sizes[g.cluster_ids[edge₁[2]...]] ≤ K
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end

	return g
end


function bohman_frieze!(g::AbstractLattice, n_steps::Int; K::Int=1)
	"""
	Achlioptas process, implementation of Bohman-Frieze bounded size rule
	Arguments
		`g`      : An instance of type AbstractLattice
		`n_steps`: Number of edges to add to the AbstractLattice
	Keyword Arguments
		`K`      : Bounded size of clusters upon which to determine edge acceptance (default = 1)
	Return
		None, updates `g` in-place
	"""
	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if g.cluster_sizes[g.cluster_ids[edge₁[1]...]] ≤ K && g.cluster_sizes[g.cluster_ids[edge₁[2]...]] ≤ K
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end

	return g
end


function product_rule(g_::AbstractLattice, n_steps::Int)
	"""
	Achlioptas process, implementation of the product rule
	Arguments
		`g_`     : An instance of type AbstractLattice
		`n_steps`: Number of edges to add to the AbstractLattice
	Return
		`g`      : An evolved instance of `g_`
	"""
	g = copy(g_)

	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if g.cluster_sizes[g.cluster_ids[edge₁[1]...]] * g.cluster_sizes[g.cluster_ids[edge₁[2]...]] < g.cluster_sizes[g.cluster_ids[edge₂[1]...]] * g.cluster_sizes[g.cluster_ids[edge₂[2]...]]
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end

	return g
end


function product_rule!(g::AbstractLattice, n_steps::Int)
	"""
	Achlioptas process, implementation of the product rule
	Arguments
		`g`      : An instance of type AbstractLattice
		`n_steps`: Number of edges to add to the AbstractLattice
	Return
		None, updates `g` in-place
	"""
	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		if g.cluster_sizes[g.cluster_ids[edge₁[1]...]] * g.cluster_sizes[g.cluster_ids[edge₁[2]...]] < g.cluster_sizes[g.cluster_ids[edge₂[1]...]] * g.cluster_sizes[g.cluster_ids[edge₂[2]...]]
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end

	return g
end


function new_rule(g_::AbstractLattice, n_steps::Int, q::Float64)
	"""
	Achlioptas process, a probability based rule for accepting edges
	Arguments
		`g_`     : An instance of type AbstractLattice
		`n_steps`: Number of edges to add to the AbstractLattice
		`q`      : Minimum probability that edge₁ is accepted
	Return
		`g` : An evolved instance of `g_`
	"""
	g = copy(g_)

	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		r = length(g.clusters[g.cluster_ids[edge₁[1]...]] ∪ g.clusters[g.cluster_ids[edge₁[2]...]]) / g.C[t]
		p = maximum((1-r, q))

		if rand(g.rng) < p
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end

	return g
end


function new_rule!(g::AbstractLattice, n_steps::Int, q::Float64)
	"""
	Achlioptas process, a probability based rule for accepting edges
	Arguments
		`g`      : An instance of type AbstractLattice
		`n_steps`: Number of edges to add to the AbstractLattice
		`q`      : Minimum probability that edge₁ is accepted
	Return
		None, updates `g` in-place
	"""
	for t in 1:n_steps
		edge₁ = choose_edge(g)
		edge₂ = choose_edge(g, edge₁)

		r = length(g.clusters[g.cluster_ids[edge₁[1]...]] ∪ g.clusters[g.cluster_ids[edge₁[2]...]]) / g.C[t]
		p = maximum((1-r, q))

		if rand(g.rng) < p
			add_edge!(g, edge₁)
		else
			add_edge!(g, edge₂)
		end
	end

	return g
end
