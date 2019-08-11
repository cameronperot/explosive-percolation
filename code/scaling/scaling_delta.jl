path = "/home/user/GraphEvolve.jl/src";
savepath = "/tmp";
# path = "/home/perot/julia/GraphEvolve.jl/src";
# savepath = "/home/perot/julia/scaling/data";
	push!(LOAD_PATH, path);
	using GraphEvolve;
	using DataFrames;
	using Dates;
	using ArgParse;
	using JLD;


# %%


function simulate_parallel_seeds(
	graph_type,
	evolution_method,
	system_size,
	n_steps,
	n_sims,
	starting_seed,
	t_data
	)
	row(g) = [
		replace(string(graph_type), "GraphEvolve." => ""),
		replace(replace(string(evolution_method), "GraphEvolve." => ""), "!" => ""),
		g.N,
		g.t,
		Int(g.rng.seed[1]),
		g.observables.delta[1],
		g.observables.delta[2],
		g.observables.delta[3],
		g.observables.delta[4],
	]

	rows = Array{Any, 1}(undef, n_sims)
	seeds = collect(starting_seed:starting_seed+n_sims-1)

	t₀ = now()
	Threads.@threads for i in 1:n_sims
		rows[i] = row(evolution_method(graph_type(system_size, seed=seeds[i]), n_steps, t_data, joinpath(savepath, "cluster_size_distribution")))
	end
	t₁ = now()

	runtime = Dates.value(t₁ - t₀) / 1000
	println("Time to run k = $(Int(log2(system_size))): $(runtime)s")

	return rows, runtime
end


function write_rows_to_csv(rows, file_name)
	open(file_name, "a") do f
    	for row in rows
			write(f, string(join(row, ","), "\n"))
		end
	end
end


function simulate_system_sizes(
	graph_type,
	evolution_method,
	system_sizes,
	n_sims,
	n_steps_ratio,
	starting_seed,
	t_data,
	file_name
	)
	# write the header row
	header = [
		"graph_type",
		"evolution_method",
		"N",
		"t",
		"seed",
		"r_0",
		"r_1",
		"m_0",
		"m_1"
	]

	open(file_name, "w") do f
		write(f, string(join(header, ","), "\n"))
	end

	# run the simulations for the given sizes
	runtimes = []
	for system_size in system_sizes
		rows, runtime = simulate_parallel_seeds(graph_type,
			evolution_method,
			system_size,
			Int(floor(n_steps_ratio * system_size))+1,
			n_sims,
			starting_seed,
			t_data,
		)
		push!(runtimes, (system_size, n_sims, Threads.nthreads(), runtime))
		write_rows_to_csv(rows, file_name)
	end

	# save the average run times
	open(joinpath(savepath, string("runtimes_$(Int(log2(system_sizes[1]))):$(Int(log2(system_sizes[end])))_$(starting_seed)_", Dates.now(), ".csv")), "w") do f
		write(f, "system_size,n_sims,n_threads,time\n")
		for runtime in runtimes
			write(f, string(join(runtime, ","), "\n"))
		end
	end
end


function parse_commandline()
	s = ArgParseSettings()

	@add_arg_table s begin
		"--graph_type"
			help = "Network, Lattice2D, or Lattice3D"
			arg_type = String
			default = "Network"
		"--evolution_method"
			help = "erdos_renyi, bohman_frieze, product_rule, or stochastic_edge_acceptance"
			arg_type = String
			default = "stochastic_edge_acceptance"
		"--n_sims"
			help = "Number of simulations to run for a given system size"
			arg_type = Int
			default = 100
		"--n_steps_ratio"
			help = "Relative (to n) number of edges to add to the graph"
			arg_type = Float64
			default = 0.8
		"--starting_seed"
			help = "Inital seed value with which to seed the rng"
			arg_type = Int
			default = 1
		"--k_min"
			help = "Minimum system size 2^k"
			arg_type = Int
			default = 15
		"--k_max"
			help = "Maximum system size 2^k"
			arg_type = Int
			default = 22
	end

	return parse_args(s)
end


# %%


graph_types = Dict(
	"Network" => Network,
	"Lattice2D" => Lattice2D,
	"Lattice3D" => Lattice3D
)

evolution_methods = Dict(
	"erdos_renyi" => erdos_renyi!,
	"bohman_frieze" => bohman_frieze!,
	"product_rule" => product_rule!,
	"stochastic_edge_acceptance" => stochastic_edge_acceptance!
)

parsed_args      = parse_commandline()
graph_type       = graph_types[parsed_args["graph_type"]]
evolution_method = evolution_methods[parsed_args["evolution_method"]]
n_sims           = parsed_args["n_sims"]
n_steps_ratio    = parsed_args["n_steps_ratio"]
starting_seed    = parsed_args["starting_seed"]
k_min            = parsed_args["k_min"]
k_max            = parsed_args["k_max"]


# %%


println(string("Available n_threads: ", Threads.nthreads()))
free_mem = Int(Sys.free_memory()) / 1024^3
println(string("Availabe memory [GB]: ", free_mem))

t_data = load("/home/user/thesis/code/scaling/t_data.jld")["t_data"]
# t_data = load("/home/perot/julia/scaling/t_data.jld")["t_data"]


# %%


simulate_system_sizes(
	graph_type,
	evolution_method,
	2 .^ collect(k_min:k_max),
	n_sims,
	n_steps_ratio,
	starting_seed,
	t_data,
	joinpath(
		savepath,
		"csv",
		string(
			parsed_args["graph_type"], "_",
			parsed_args["evolution_method"], "_",
			k_min, ":", k_max, "_",
			starting_seed, "_",
			Dates.today(),
			".csv"
		)
	)
)

# %%

# simulate_system_sizes(Network, stochastic_edge_acceptance!, 2 .^ [15, 16], 10, 0.8, 10, t_data, "/tmp/test.csv")
