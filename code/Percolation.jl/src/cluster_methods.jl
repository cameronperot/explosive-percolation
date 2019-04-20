function get_cluster(g::Network, node::Int)
	"""
	Determines the cluster to which the given node is a member of
	INPUT
		`g`   : An instance of type Network
		`node`: Integer index of the desired node
	OUTPUT
		`cluster`: The cluster the given node is a member of
	"""
	for cluster in g.clusters
		if node ∈ cluster
			return cluster
		end
	end
end


function get_largest_cluster_size(g::Network)
	"""
	Determines the size of the largest cluster in `g`
	INPUT
		`g`: An instance of type Network
	OUTPUT
		Integer representing the number of nodes in the largest cluster
	"""
	return maximum([length(cluster) for cluster in g.clusters])
end


function get_largest_clusters(g::Network, n_clusters::Int)
	"""
	Determines the `n_clusters` largest clusters in the graph
	INPUT
		`g`         : An instance of type Network
		`n_clusters`: The number of largest clusters to return
	OUTPUT
		Sorted (descending) array of the `n_clusters` largest clusters in `g`
	"""
	return sort(collect(g.clusters), by=length, rev=true)[1:n_clusters]
end


function merge_clusters(g::Network, cluster₁::Set{Int}, cluster₂::Set{Int})
	"""
	Function to merge two clusters in a Network
	INPUT
		`g`       : An instance of type Network
		`cluster₁`: Any cluster within `g`
		`cluster₂`: Any cluster within `g`
	OUTPUT
		None, updates `g` in-place
	"""
	filter!(cluster -> cluster ∉ [cluster₁, cluster₂], g.clusters)
	push!(g.clusters, cluster₁ ∪ cluster₂)
end
