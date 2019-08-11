using Statistics
using DataFrames
using CSV
using JLD


# %%


data_dir = "/home/user/Downloads/raw_data/csv";
data_files = readdir(data_dir);
output_file = "/home/user/thesis/data/scaling/Network_stochastic_edge_acceptance.csv";


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


df[!, :Δr]  = df[:, :r_1] .- df[:, :r_0];
df[!, :Δm]  = df[:, :m_1] .- df[:, :m_0];
df[!, :t_0] = Int.(df[:, :r_0] .* df[:, :N]);
df[!, :t_1] = Int.(df[:, :r_1] .* df[:, :N]);

# t_data = Dict();
# for row in 1:size(df)[1]
# 	t_data[(df[row, :N], df[row, :seed])] = (df[row, :t_0], df[row, :t_1])
# end
# t_data
# save("/home/user/thesis/code/scaling/t_data.jld", "t_data", t_data)

df[!, :N] = Int.(df[:, :N]);
df[!, :t] = Int.(df[:, :t]);
df[!, :seed] = Int.(df[:, :seed]);
sort!(df, [:N, :seed]);


# %%


df |> CSV.write(output_file)
