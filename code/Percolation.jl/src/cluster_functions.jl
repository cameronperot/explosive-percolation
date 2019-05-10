function get_cluster(g::AbstractGraph, node)
	"""
	Determines the cluster in `g` which `node` is a member of
	Arguments
		`g`   : An instance of type AbstractGraph
		`node`: Node in `keys(g.cluster_ids)`
	Return
		Set of nodes representing the cluster which `node` is a member of
	"""

	return g.clusters[g.cluster_ids[node]]

end


function get_largest_cluster_size(g::AbstractGraph)
	"""
	Determines the size of the largest cluster in `g`
	Arguments
		`g`: An instance of type AbstractGraph
	Return
		Integer representing the number of nodes in the largest cluster in `g`
	"""

	return maximum(keys(g.cluster_sizes))

end


function get_avg_cluster_size(g::AbstractGraph)
	"""
	Determines the average cluster size in `g`
	Arguments
		`g`: An instance of type AbstractGraph
	Return
		Float64 representing the average cluster size in `g`
	"""

	return mean([length(cluster) for cluster in values(g.clusters)])

end


function get_largest_clusters(g::AbstractGraph, n_clusters::Int)
	"""
	Determines the `n_clusters` largest clusters in 'g'
	Arguments
		`g`         : An instance of type AbstractGraph
		`n_clusters`: The number of largest clusters to return
	Return
		Sorted (descending) array of the `n_clusters` largest clusters in `g`
	"""

	return sort!(collect(values(g.clusters)), by=length, rev=true)[1:n_clusters]

end


function update_clusters!(g::AbstractGraph, edge::Tuple)
	"""
	Updates `g` with the newly merged cluster and the largest cluster size
	Arguments
		`g`   : An instance of type AbstractGraph
		`edge`: Edge added to `g` at step `g.t`
	Return
		None, updates `g` in-place
	"""

	if length(g.clusters[g.cluster_ids[edge[1]]]) > length(g.clusters[g.cluster_ids[edge[2]]])
		larger_cluster_id  = g.cluster_ids[edge[1]]
		smaller_cluster_id = g.cluster_ids[edge[2]]
	else
		larger_cluster_id  = g.cluster_ids[edge[2]]
		smaller_cluster_id = g.cluster_ids[edge[1]]
	end

	if g.cluster_ids[edge[1]] ≠ g.cluster_ids[edge[2]]
		update_cluster_sizes!(g, larger_cluster_id, smaller_cluster_id)
		update_cluster_ids!(g, larger_cluster_id, smaller_cluster_id)
		merge_clusters!(g, larger_cluster_id, smaller_cluster_id)
		update_observables!(g, larger_cluster_id, smaller_cluster_id)
	else
		update_observables!(g, larger_cluster_id, smaller_cluster_id)
	end

end

function update_cluster_sizes!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
	"""
	Updates the cluster size distribution dictionary
	Arguments
	`g`                 : An instance of type AbstractGraph
	`larger_cluster_id` : Cluster ID of the larger cluster
	`smaller_cluster_id`: Cluster ID of the smaller cluster
	Return
	None, updates `g` in-place
	"""

	if g.cluster_sizes[length(g.clusters[smaller_cluster_id])] ≠ 1
		g.cluster_sizes[length(g.clusters[smaller_cluster_id])] -= 1
	else
		delete!(g.cluster_sizes, length(g.clusters[smaller_cluster_id]))
	end

	if g.cluster_sizes[length(g.clusters[larger_cluster_id])] ≠ 1
		g.cluster_sizes[length(g.clusters[larger_cluster_id])] -= 1
	else
		delete!(g.cluster_sizes, length(g.clusters[larger_cluster_id]))
	end

	if haskey(g.cluster_sizes, (length(g.clusters[larger_cluster_id]) + length(g.clusters[smaller_cluster_id])))
		g.cluster_sizes[(length(g.clusters[larger_cluster_id]) + length(g.clusters[smaller_cluster_id]))] += 1
	else
		g.cluster_sizes[(length(g.clusters[larger_cluster_id]) + length(g.clusters[smaller_cluster_id]))] = 1
	end

end

function update_cluster_ids!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
	"""
	Updates the cluster IDs of the nodes in the smaller cluster to that of the larger cluster it is being merged into
	Arguments
	`g`                 : An instance of type AbstractGraph
	`larger_cluster_id` : Cluster ID of the larger cluster
	`smaller_cluster_id`: Cluster ID of the smaller cluster
	Return
	None, updates `g` in-place
	"""

	for node in g.clusters[smaller_cluster_id]
		g.cluster_ids[node] = larger_cluster_id
	end

end

function merge_clusters!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
	"""
	Mergers the smaller cluster into the larger cluster in-place
	Arguments
		`g`                 : An instance of type AbstractGraph
		`larger_cluster_id` : Cluster ID of the larger cluster
		`smaller_cluster_id`: Cluster ID of the smaller cluster
	Return
		None, updates `g` in-place
	"""

	union!(g.clusters[larger_cluster_id], g.clusters[smaller_cluster_id])
	delete!(g.clusters, smaller_cluster_id)

end

function update_observables!(g::AbstractGraph, larger_cluster_id::Int, smaller_cluster_id::Int)
	"""
	Updates the largest cluster size and cluster heterogeneity
	Arguments
		`g`                 : An instance of type AbstractGraph
		`larger_cluster_id` : Cluster ID of the larger cluster
		`smaller_cluster_id`: Cluster ID of the smaller cluster
	Return
		None, updates `g` in-place
	"""

	push!(g.C, maximum((g.C[g.t], length(g.clusters[larger_cluster_id]))))
	push!(g.heterogeneity, length(g.cluster_sizes))

end
