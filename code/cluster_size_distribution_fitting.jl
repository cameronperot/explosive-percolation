using DataStructures
using Statistics
using JLD

raw_data_dir  = "/home/user/Downloads/raw_data";
data_dir = "/home/user/thesis/data/scaling";
t_0_dir   = joinpath(raw_data_dir, "cluster_size_distribution/t_0");
t_1_dir   = joinpath(raw_data_dir, "cluster_size_distribution/t_1");
t_0_files = joinpath.(t_0_dir, readdir(t_0_dir));
t_1_files = joinpath.(t_1_dir, readdir(t_1_dir));


# %%


function μ(x)
	return sum(x) / length(x)
end


function σ(x)
	return sqrt(sum((x .- μ(x)).^2 / length(x)))
end


file_dict = Dict(
	"t_0" => joinpath.(t_0_dir, readdir(t_0_dir)),
	"t_1" => joinpath.(t_1_dir, readdir(t_1_dir))
);


function compute_distributions(file_dict)
	t_dicts = Dict()
	for (t, files) in file_dict
		t_dicts[t] = Dict()

		for file in files
			for (i, line) in enumerate(eachline(file))
				i ∈ (1, 2, 3) ? continue : nothing

				s, n_s = parse.(Int, split(line, ","))
				if s ∈ keys(t_dicts[t])
					push!(t_dicts[t][s], n_s)
				else
					t_dicts[t][s] = [n_s]
				end
			end
		end
	end

	t_dicts_out = Dict()
	for (t, distribution_arrays) in t_dicts
		s      = []
		counts = []
		n_s    = []
		σ_n_s  = []
		for (s_, distribution_array) in distribution_arrays
			push!(s, s_)
			push!(counts, length(n_s))
			push!(n_s, μ(distribution_array))
			push!(σ_n_s, std(distribution_array))
		end
		t_dicts_out[t] = Dict(
			"s"     => s,
			"counts" => counts,
			"n_s"   => n_s,
			"σ_n_s" => σ_n_s
		)
	end

	return t_dicts_out
end


t_dicts = compute_distributions(file_dict);
t_dicts["t_0"]
t_dicts["t_1"]

# %% Save and load data


save_file = joinpath(data_dir, "cluster_size_distribution_data.jld");
save(save_file, "distribution_avgs", t_dicts)


using PyCall
np = pyimport("numpy")
