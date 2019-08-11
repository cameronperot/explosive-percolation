using DataStructures
using Plots; pyplot(fmt="png")
PyPlot.matplotlib.rc("mathtext", fontset="cm");
PyPlot.matplotlib.rc("text", usetex=true);
PyPlot.matplotlib.rc("font", family="serif", size=12);
using LaTeXStrings
using LsqFit
using Statistics
using JLD

raw_data_dir  = "/home/user/Downloads/raw_data";
data_dir = "/home/user/thesis/data/scaling";
t_0_dir   = joinpath(raw_data_dir, "cluster_size_distribution/t_0");
t_1_dir   = joinpath(raw_data_dir, "cluster_size_distribution/t_1");
t_0_files = joinpath.(t_0_dir, readdir(t_0_dir));
t_1_files = joinpath.(t_1_dir, readdir(t_1_dir));

savepath = "/home/user/thesis/latex/images"
save_bool = true
dpi = 144
if save_bool
	dpi = 300
end


# %%


file_dict = Dict(
	"t_0" => joinpath.(t_0_dir, readdir(t_0_dir)),
	"t_1" => joinpath.(t_1_dir, readdir(t_1_dir))
);

function distribution_files_to_dict(file_dict, Ns)
	distributions = Dict(
		t => Dict(N => Dict() for N in Ns) for t in keys(file_dict)
	)
	N_counts = Dict(
		t => Dict() for t in keys(file_dict)
	)

	for (t, file_list) in file_dict
		N_counts[t] = Dict(
			N => sum([1 for file_name in file_list if occursin(string("_", Int(log2(N)), "_"), file_name)])
			for N in Ns
		)

		for file in file_list
			a             = maximum(findfirst("acceptance_", file)) + 1
			b             = minimum(findfirst("_t_", file)) - 1
			N             = 2^parse(Int, file[a:b])
			a             = maximum(findfirst("_seed_", file)) + 1
			b             = minimum(findfirst(".csv", file)) - 1
			seed          = parse(Int, file[a:b])
			distribution  = Dict()

			for (i, line) in enumerate(eachline(file))
				i ∈ (1, 2, 3) ? continue : nothing

				s, N_s = parse.(Int, split(line, ","))
				distribution[s] = N_s / N
			end

			distributions[t][N][seed] = distribution
		end
	end

	distribution_avgs = Dict(
		t => Dict(N => DefaultDict{Int, Float64}(0.) for N in Ns) for t in keys(file_dict)
	)
	for (t, N_dicts) in distributions
		for (N, seed_dicts) in N_dicts
			for (seed, distribution) in seed_dicts
				for (s, n_s) in distribution
					distribution_avgs[t][N][s] += n_s / N_counts[t][N]
				end
			end
		end
	end

	distribution_avgs_ = Dict()
	for (t, N_dicts) in distribution_avgs
		t_dict = Dict()
		for (N, distribution) in N_dicts
			t_dict[N] = Dict(distribution)
		end
		distribution_avgs_[t] = t_dict
	end

	return distributions, distribution_avgs_
end


function distribution_file_to_dict(file)
	N = 0
	distribution = Dict()

	for (i, ln) in enumerate(eachline(file))
		if i == 1
			N = parse(Int, ln[7:end])
			continue
		end
		if i == 2
			continue
		end
		s, N_s = parse.(Int, split(ln, ","))
		distribution[s] = N_s / N
	end

	return (distribution, N)
end


# %% Save and load data


Ns = 2 .^ collect(15:24);
distributions, distribution_avgs = distribution_files_to_dict(file_dict, Ns);

save_file = joinpath(data_dir, "cluster_size_distribution_avgs.jld")
save(save_file, "distribution_avgs", distribution_avgs)
