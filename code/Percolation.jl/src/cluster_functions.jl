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
	return maximum(values(g.cluster_sizes))
end


function get_avg_cluster_size(g::AbstractGraph)
	"""
	Determines the average cluster size in `g`
	Arguments
		`g`: An instance of type AbstractGraph
	Return
		Float64 representing the average cluster size in `g`
	"""
	return mean(values(g.cluster_sizes))
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
	# TODO need account for the case when length(g.clusters) < n_clusters
	return sort!(collect(values(g.clusters)), by=length, rev=true)[1:n_clusters]
end


function update_clusters!(g::AbstractNetwork, edge::Tuple)
	"""
	Updates `g` with the newly merged cluster and the largest cluster size
	Arguments
		`g`   : An instance of type AbstractGraph
		`edge`: Edge added to `g` at step `g.t`
	Return
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

		push!(g.C, maximum((g.C[g.t], g.cluster_sizes[larger_cluster_id])))
	else

		push!(g.C, g.C[g.t])
	end
end


function update_clusters!(g::AbstractLattice, edge::Tuple)
	"""
	Updates `g` with the newly merged cluster and the largest cluster size
	Arguments
		`g`   : An instance of type AbstractGraph
		`edge`: Edge added to `g` at step `g.t`
	Return
		None, updates `g` in-place
	"""
	if g.cluster_ids[edge[1]...] ≠ g.cluster_ids[edge[2]...]

		if g.cluster_sizes[g.cluster_ids[edge[1]...]] > g.cluster_sizes[g.cluster_ids[edge[2]...]]
			larger_cluster_id  = g.cluster_ids[edge[1]...]
			smaller_cluster_id = g.cluster_ids[edge[2]...]
		else
			larger_cluster_id  = g.cluster_ids[edge[2]...]
			smaller_cluster_id = g.cluster_ids[edge[1]...]
		end

		union!(g.clusters[larger_cluster_id], g.clusters[smaller_cluster_id])
		g.cluster_sizes[larger_cluster_id] = length(g.clusters[larger_cluster_id])

		for node in g.clusters[smaller_cluster_id]
			g.cluster_ids[node...] = larger_cluster_id
		end

		delete!(g.clusters, smaller_cluster_id)
		delete!(g.cluster_sizes, smaller_cluster_id)

		push!(g.C, maximum((g.C[g.t], g.cluster_sizes[larger_cluster_id])))
	else

		push!(g.C, g.C[g.t])
	end
end
