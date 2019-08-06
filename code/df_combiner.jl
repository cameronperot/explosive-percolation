using Statistics
using DataFrames
using CSV

# %%

data_dir = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/data/scaling/raw/Network/stochastic_edge_acceptance";
data_files = readdir(data_dir);
output_file = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/data/scaling/Network_stochastic_edge_acceptance.csv";

# %%

dfs_raw = [];
for data_file in data_files
	df_raw = CSV.read(joinpath(data_dir, data_file)) |> DataFrame
	push!(dfs_raw, df_raw)
end

df = dfs_raw[1];
for df_raw in dfs_raw[2:end]
	append!(df, df_raw)
end

# %%

df[:graph_type] = ["Network" for i in 1:nrow(df)];
df[:evolution_method] = ["stochastic_edge_acceptance" for i in 1:nrow(df)];
cols = [
	:graph_type,
	:evolution_method,
	:n,
	:t,
	:seed,
	:Δ_method_1,
	:Δ_method_1_t_0,
	:Δ_method_1_t_1,
	:Δ_method_2,
	:Δ_method_2_t_0,
	:Δ_method_2_t_1
]
df = df[cols];

# %%

df[:n] = Int.(df[:n]);
df[:t] = Int.(df[:t]);
df[:seed] = Int.(df[:seed]);
sort!(df, [:n, :seed]);

df |> CSV.write(output_file)
