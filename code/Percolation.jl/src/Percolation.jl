module Percolation

using Random

export

# graphs
Graph,
Network,

# edge_functions
choose_edge,
add_edge,

# cluster_functions
get_cluster,
get_largest_cluster_size,
get_largest_clusters,
merge_clusters,

# evolution_processes
erdos_renyi,
bohman_frieze,
product_rule

include("./graphs.jl")
include("./edge_functions.jl")
include("./cluster_functions.jl")
include("./evolution_processes.jl")

end # module
