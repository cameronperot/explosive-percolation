module Percolation

using Random

export

# graphs
AbstractGraph,
AbstractNetwork,
AbstractLattice,
Network,
Lattice2D,
Lattice3D,

# edge_methods
choose_edge,
add_edge!,
nearest_neighbors,
cart_to_lin,

# cluster_methods
get_cluster,
get_largest_cluster_size,
get_avg_cluster_size,
get_largest_clusters,
update_clusters!,
update_cluster_sizes!,
update_cluster_ids!,
merge_clusters!,
update_observables!,

# evolution_methods
erdos_renyi,
erdos_renyi!,
bohman_frieze,
bohman_frieze!,
product_rule,
product_rule!,
p_rule_1!,
p_rule_2!,

# analysis_methods
compute_Δ_method_1,
compute_Δ_method_2,
finalize_observables

# includes
include("./AbstractGraphs.jl")
include("./edge_methods.jl")
include("./cluster_methods.jl")
include("./evolution_methods.jl")
include("./analysis_methods.jl")
include("./plot_methods.jl")
include("./animation_methods.jl")

end # module
