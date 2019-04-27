module Percolation

using Random
using Statistics

export

# graphs
Graph,
Network,
Lattice2D,

# edge_functions
choose_edge,
add_edge!,

# cluster_functions
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
new_rule!

include("./graphs.jl")
include("./edge_functions.jl")
include("./cluster_functions.jl")
include("./evolution_processes.jl")

end # module
