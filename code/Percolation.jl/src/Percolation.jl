module Percolation

using Random

export

# graphs
AbstractGraph,
Network,
Lattice2D,
Lattice3D,

# edge_functions
choose_edge,
add_edge!,
cart2lin,

# cluster_functions
get_cluster,
get_largest_cluster_size,
get_avg_cluster_size,
get_largest_clusters,
update_clusters!,

# evolution_processes
erdos_renyi,
erdos_renyi!,
bohman_frieze,
bohman_frieze!,
product_rule,
product_rule!,

# analysis_functions
compute_Δ_achlioptas,

# plot_functions
plot_order_parameter

include("./AbstractGraphs.jl")
include("./edge_functions.jl")
include("./cluster_functions.jl")
include("./evolution_processes.jl")
include("./analysis_functions.jl")
include("./plot_functions.jl")
include("./animation_functions.jl")

end # module
