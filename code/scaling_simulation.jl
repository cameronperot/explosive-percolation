# path = "~/thesis/code/GraphEvolve.jl/src";
# savepath = "/tmp"
path = "/home/perot/julia/GraphEvolve.jl/src";
savepath = "/home/perot/julia/scaling";
	push!(LOAD_PATH, path);
	using GraphEvolve;
	using DataFrames;
	using Dates;

# %%

function simulate_parallel_seeds(graph_type, evolution_method, system_size, n_sims)
	row(g) = [
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
	n_steps = Int(floor(1.5 * system_size))
	rows = Array{Any, 1}(undef, n_sims)
	Threads.@threads for seed in 1:n_sims
		rows[seed] = row(
			evolution_method(
				graph_type(system_size, seed=seed),
				n_steps
			)
		)
	end
	t₁ = now()
	avg_runtime = Dates.value(t₁ - t₀) / 1000 / n_sims

	return rows, avg_runtime
end

function write_rows_to_csv(rows, file_name)
	open(file_name, "a") do f
    	for row in rows
			write(f, string(join(row, ","), "\n"))
		end
	end
end

function simulate_system_sizes(graph_type, evolution_method, system_sizes, n_sims, file_name)
	# write the header row
	header = [
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
	avg_runtimes = []
	for system_size in system_sizes
		rows, avg_runtime = simulate_parallel_seeds(Network, stochastic_edge_acceptance!, system_size, n_sims)
		push!(avg_runtimes, (system_size, avg_runtime))
		write_rows_to_csv(rows, file_name)
	end

	# save the average run times
	open(joinpath(savepath, string("runtimes_", Dates.now(), ".csv")), "w") do f
		write(f, "system_size,time\n")
		for avg_runtime in avg_runtimes
			write(f, string(join(avg_runtime, ","), "\n"))
		end
	end
end

# %%

simulate_system_sizes(
	Network,
	product_rule!,
	2 .^ collect(15:25),
	1000,
	joinpath(savepath, string("scaling_data_", Dates.now(), ".csv")))
