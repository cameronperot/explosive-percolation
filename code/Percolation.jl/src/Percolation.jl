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

# edge_functions
choose_edge,
add_edge!,
cart2lin,
nearest_neighbors,
cart2lin,

# cluster_functions
get_cluster,
get_largest_cluster_size,
get_avg_cluster_size,
get_largest_clusters,
update_clusters!,
update_cluster_sizes!,
update_cluster_ids!,
merge_clusters!,
update_observables!,

# evolution_processes
erdos_renyi,
erdos_renyi!,
bohman_frieze,
bohman_frieze!,
product_rule,
product_rule!,
p_rule_1!,
p_rule_2!,

# analysis_functions
compute_Δ_achlioptas

include("./AbstractGraphs.jl")
include("./edge_functions.jl")
include("./cluster_functions.jl")
include("./evolution_processes.jl")
include("./analysis_functions.jl")
include("./animation_functions.jl")

end # module
