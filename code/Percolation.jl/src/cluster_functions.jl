function get_largest_cluster_size(g::Network)
	"""
	Determines the size of the largest cluster in `g`
	INPUT
		`g`: An instance of type Network
	OUTPUT
		Integer representing the number of nodes in the largest cluster of `g`
	"""
	return maximum([length(cluster) for cluster in values(g.clusters)])
end


function get_largest_clusters(g::Network, n_clusters::Int)
	"""
	Determines the `n_clusters` largest clusters in 'g'
	INPUT
		`g`         : An instance of type Network
		`n_clusters`: The number of largest clusters to return
	OUTPUT
		Sorted (descending) array of the `n_clusters` largest clusters in `g`
	"""
	# TODO need account for the case when length(g.clusters) < n_clusters
	return sort!(collect(values(g.clusters)), by=length, rev=true)[1:n_clusters]
end


function update_clusters!(g::Network, t::Int, edge::Tuple{Int, Int})
	"""
	Updates `g` with the newly merged cluster the largest cluster size
	INPUT
		`g`   : An instance of type Network
		`t`   : Current step in the evolution process
		`edge`: Edge added to `g` at step `t`
	OUTPUT
		None, updates `g` in-place
	"""
	cluster₁ = g.nodes[edge[1]]
	cluster₂ = g.nodes[edge[2]]
	if length(g.clusters[cluster₁]) > length(g.clusters[cluster₂])
		if cluster₁ ≠ cluster₂
			union!(g.clusters[cluster₁], g.clusters[cluster₂])
			for node in g.clusters[cluster₂]
				g.nodes[node] = cluster₁
			end
			delete!(g.clusters, cluster₂)
		end
		g.C[t+1] = maximum((g.C[t], length(g.clusters[cluster₁])))
	else
		if cluster₁ ≠ cluster₂
			union!(g.clusters[cluster₂], g.clusters[cluster₁])
			for node in g.clusters[cluster₁]
				g.nodes[node] = cluster₂
			end
			delete!(g.clusters, cluster₁)
		end
		g.C[t+1] = maximum((g.C[t], length(g.clusters[cluster₂])))
	end
end
