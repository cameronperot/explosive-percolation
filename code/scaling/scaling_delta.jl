# path = "/home/user/GraphEvolve.jl/src";
# savepath = "/tmp"
path = "/home/perot/julia/GraphEvolve.jl/src";
savepath = "/home/perot/julia/scaling";
	push!(LOAD_PATH, path);
	using GraphEvolve;
	using DataFrames;
	using Dates;
	using ArgParse;

# %%

function simulate_parallel_seeds(graph_type, evolution_method, system_size, n_sims, starting_seed)
	row(g) = [
		replace(string(graph_type), "GraphEvolve." => ""),
		replace(replace(string(evolution_method), "GraphEvolve." => ""), "!" => ""),
		g.n,
		g.t,
		Int(g.rng.seed[1]),
		g.observables.Δ_method_1[1],
		g.observables.Δ_method_1[2],
		g.observables.Δ_method_1[3],
		g.observables.Δ_method_2[1],
		g.observables.Δ_method_2[2],
		g.observables.Δ_method_2[3]
	]

	t₀ = now()
	n_steps = Int(system_size)
	rows = Array{Any, 1}(undef, n_sims)
	seeds = collect(starting_seed:starting_seed+n_sims-1)

	Threads.@threads for i in 1:n_sims
		rows[i] = row(
			evolution_method(
				graph_type(system_size, seed=seeds[i]),
				n_steps
			)
		)
	end

	t₁ = now()
	runtime = Dates.value(t₁ - t₀) / 1000

	return rows, runtime
end

function write_rows_to_csv(rows, file_name)
	open(file_name, "a") do f
    	for row in rows
			write(f, string(join(row, ","), "\n"))
		end
	end
end

function simulate_system_sizes(graph_type, evolution_method, system_sizes, n_sims, starting_seed, file_name)
	# write the header row
	header = [
		"graph_type",
		"evolution_method",
		"n",
		"t",
		"seed",
		"Δ_method_1",
		"Δ_method_1_t_0",
		"Δ_method_1_t_1",
		"Δ_method_2",
		"Δ_method_2_t_0",
		"Δ_method_2_t_1"
	]

	open(file_name, "w") do f
		write(f, string(join(header, ","), "\n"))
	end

	# run the simulations for the given sizes
	runtimes = []
	for system_size in system_sizes
		rows, runtime = simulate_parallel_seeds(graph_type, evolution_method, system_size, n_sims, starting_seed)
		push!(runtimes, (system_size, n_sims, Threads.nthreads(), runtime))
		write_rows_to_csv(rows, file_name)
	end

	# save the average run times
	open(joinpath(savepath, string("runtimes_", Dates.now(), ".csv")), "w") do f
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
		"--starting_seed"
			help = "Inital seed value with which to seed the rng"
			arg_type = Int
			default = 1
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

evolution_methods["erdos_renyi"]

parsed_args   = parse_commandline()

graph_type       = graph_types[parsed_args["graph_type"]]
evolution_method = evolution_methods[parsed_args["evolution_method"]]
n_sims           = parsed_args["n_sims"]
starting_seed    = parsed_args["starting_seed"]

println(string("Available n_threads: ", Threads.nthreads()))
free_mem = Int(Sys.free_memory()) / 1024^3
println(string("Availabe memory [GB]: ", free_mem))

simulate_system_sizes(
	graph_type,
	evolution_method,
	2 .^ [24],
	n_sims,
	starting_seed,
	joinpath(
		savepath,
		string(
			parsed_args["graph_type"], "_",
			parsed_args["evolution_method"], "_",
			Dates.now(),
			".csv"
		)
	)
)
