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
	return node
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
	return sort(collect(g.clusters), by=length, rev=true)[1:n_clusters]
end


function update_clusters(g::Network, cluster₁::Set{Int}, cluster₂::Set{Int})
	"""
	Updates `g` with the newly merged cluster the largest cluster size
	INPUT
		`g`       : An instance of type Network
		`cluster₁`: Any cluster within `g`
		`cluster₂`: Any cluster within `g`
	OUTPUT
		None, updates `g` in-place
	"""
	filter!(cluster -> cluster ∉ (cluster₁, cluster₂), g.clusters)
	merged_cluster = cluster₁ ∪ cluster₂
	C = maximum((g.C[end], length(merged_cluster)))
	push!(g.clusters, merged_cluster)
	push!(g.C, C)
end


function update_clusters(g::Network, cluster₁::Set{Int}, cluster₂::Set{Int}, merged_cluster::Set{Int})
	"""
	Updates `g` with the newly merged cluster and the largest cluster size
	INPUT
		`g`             : An instance of type Network
		`cluster₁`      : Any cluster within `g`
		`cluster₂`      : Any cluster within `g`
		`merged_cluster`: cluster₁ ∪ cluster₂
	OUTPUT
		None, updates `g` in-place
	"""
	filter!(cluster -> cluster ∉ (cluster₁, cluster₂), g.clusters)
	C = maximum((g.C[end], length(merged_cluster)))
	push!(g.clusters, merged_cluster)
	push!(g.C, C)
end
