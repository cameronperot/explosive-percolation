input_data_path = "/home/user/Downloads/raw_data_old"
output_data_path = "/home/user/Downloads/raw_data"

input_dir = joinpath(input_data_path, "csv");
output_dir = joinpath(output_data_path, "csv");

input_files = joinpath.(input_dir, readdir(input_dir));
output_files = joinpath.(output_dir, readdir(input_dir));


# %%


for i in 1:length(input_files)
	open(input_files[i], "r") do f
		data = read(f, String)
		new_data = replace(data,
			"graph_type,evolution_method,n,t,seed,r_0,r_1,m_0,m_1" =>
			"graph_type,evolution_method,N,t,seed,r_0,r_1,m_0,m_1")
		open(output_files[i], "w") do g
			write(g, new_data)
		end
	end
end


# %%

for t in ["t_0", "t_1"]
	input_dir = joinpath(input_data_path, "cluster_size_distribution", t);
	output_dir = joinpath(output_data_path, "cluster_size_distribution", t);

	input_files = joinpath.(input_dir, readdir(input_dir));
	output_files = joinpath.(output_dir, readdir(input_dir));

	for i in 1:length(input_files)
		open(output_files[i], "w") do file
			for (j, line) in enumerate(eachline(input_files[i]))
				if j == 1
					write(file, string(replace(line, "# n = " => "# N = "), "\n"))
					a    = maximum(findfirst("_seed_", input_files[i])) + 1
					b    = minimum(findfirst(".csv", input_files[i])) - 1
					seed = parse(Int, input_files[i][a:b])
					write(file, "# seed = $(seed)\n")
					continue
				end
				write(file, string(line, "\n"))
			end
		end
	end
end
