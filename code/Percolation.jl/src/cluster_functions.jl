function get_largest_cluster_size(g::Graph)
	"""
	Determines the size of the largest cluster in `g`
	Arguments:
		`g`: An instance of type Graph
	Output:
		Integer representing the number of nodes in the largest cluster in `g`
	"""
	return maximum(values(g.cluster_sizes))
end


function get_avg_cluster_size(g::Graph)
	"""
	Determines the average cluster size in `g`
	Arguments:
		`g`: An instance of type Graph
	Output:
		Float64 representing the average cluster size in `g`
	"""
	return mean(values(g.cluster_sizes))
end


function get_largest_clusters(g::Graph, n_clusters::Int)
	"""
	Determines the `n_clusters` largest clusters in 'g'
	Arguments:
		`g`         : An instance of type Graph
		`n_clusters`: The number of largest clusters to return
	Output:
		Sorted (descending) array of the `n_clusters` largest clusters in `g`
	"""
	# TODO need account for the case when length(g.clusters) < n_clusters
	return sort!(collect(values(g.clusters)), by=length, rev=true)[1:n_clusters]
end


function update_clusters!(g::Graph, t::Int, edge::Tuple)
	"""
	Updates `g` with the newly merged cluster and the largest cluster size
	Arguments:
		`g`   : An instance of type Graph
		`t`   : Current step in the evolution process
		`edge`: Edge added to `g` at step `t`
	Output:
		None, updates `g` in-place
	"""
	if g.cluster_ids[edge[1]] ≠ g.cluster_ids[edge[2]]
		if g.cluster_sizes[g.cluster_ids[edge[1]]] > g.cluster_sizes[g.cluster_ids[edge[2]]]
			larger_cluster_id  = g.cluster_ids[edge[1]]
			smaller_cluster_id = g.cluster_ids[edge[2]]
		else
			larger_cluster_id  = g.cluster_ids[edge[2]]
			smaller_cluster_id = g.cluster_ids[edge[1]]
		end
		union!(g.clusters[larger_cluster_id], g.clusters[smaller_cluster_id])
		g.cluster_sizes[larger_cluster_id] = length(g.clusters[larger_cluster_id])
		for node in g.clusters[smaller_cluster_id]
			g.cluster_ids[node] = larger_cluster_id
		end
		delete!(g.clusters, smaller_cluster_id)
		delete!(g.cluster_sizes, smaller_cluster_id)
		g.C[t+1] = maximum((g.C[t], g.cluster_sizes[larger_cluster_id]))
	else
		g.C[t+1] = g.C[t]
	end
end
