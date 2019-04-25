function get_largest_cluster_size(g::Graph)
	"""
	Determines the size of the largest cluster in `g`
	INPUT
		`g`: An instance of type Graph
	OUTPUT
		Integer representing the number of nodes in the largest cluster of `g`
	"""
	return maximum(values(g.cluster_sizes))
end


function get_avg_cluster_size(g::Graph)
	"""
	Determines the average cluster size in `g`
	INPUT
		`g`: An instance of type Graph
	OUTPUT
		Float64 representing the average cluster size
	"""
	return mean(values(g.cluster_sizes))
end


function get_largest_clusters(g::Graph, n_clusters::Int)
	"""
	Determines the `n_clusters` largest clusters in 'g'
	INPUT
		`g`         : An instance of type Graph
		`n_clusters`: The number of largest clusters to return
	OUTPUT
		Sorted (descending) array of the `n_clusters` largest clusters in `g`
	"""
	# TODO need account for the case when length(g.clusters) < n_clusters
	return sort!(collect(values(g.clusters)), by=length, rev=true)[1:n_clusters]
end


function update_clusters!(g::Graph, t::Int, edge::Tuple)
	"""
	Updates `g` with the newly merged cluster the largest cluster size
	INPUT
		`g`   : An instance of type Graph
		`t`   : Current step in the evolution process
		`edge`: Edge added to `g` at step `t`
	OUTPUT
		None, updates `g` in-place
	"""
	if g.nodes[edge[1]] ≠ g.nodes[edge[2]]
		if g.cluster_sizes[g.nodes[edge[1]]] > g.cluster_sizes[g.nodes[edge[2]]]
			larger_cluster = g.nodes[edge[1]]
			smaller_cluster = g.nodes[edge[2]]
		else
			larger_cluster = g.nodes[edge[2]]
			smaller_cluster = g.nodes[edge[1]]
		end
		union!(g.clusters[larger_cluster], g.clusters[smaller_cluster])
		g.cluster_sizes[larger_cluster] = length(g.clusters[larger_cluster])
		for node in g.clusters[smaller_cluster]
			g.nodes[node] = larger_cluster
		end
		delete!(g.clusters, smaller_cluster)
		g.C[t+1] = maximum((g.C[t], g.cluster_sizes[larger_cluster]))
	else
		g.C[t+1] = g.C[t]
	end
end
