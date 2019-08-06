using Statistics
using DataFrames
using CSV
using Plots; gr(fmt="png")
using LaTeXStrings

path = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/data/scaling/";
graph_type = "Network";
evolution_method = "stochastic_edge_acceptance";
data_file = string(path, graph_type, "_", evolution_method, ".csv");

savepath = "/home/user/thesis/latex/images"
save_bool = true
dpi = 144
if save_bool
	dpi = 300
end

# %%

df_raw = CSV.read(data_file) |> DataFrame;

df = DataFrame(
	graph_type            =[],
	evolution_method      =[],
	n                     =[],
	mean_Δ_method_1       =[],
	mean_Δ_method_1_t_0   =[],
	mean_Δ_method_1_t_1   =[],
	mean_Δ_method_2       =[],
	mean_Δ_method_2_t_0   =[],
	mean_Δ_method_2_t_1   =[],
	median_Δ_method_1     =[],
	median_Δ_method_1_t_0 =[],
	median_Δ_method_1_t_1 =[],
	median_Δ_method_2     =[],
	median_Δ_method_2_t_0 =[],
	median_Δ_method_2_t_1 =[],
	stdev_Δ_method_1      =[],
	stdev_Δ_method_1_t_0  =[],
	stdev_Δ_method_1_t_1  =[],
	stdev_Δ_method_2      =[],
	stdev_Δ_method_2_t_0  =[],
	stdev_Δ_method_2_t_1  =[]
);

ns = unique(df_raw[:n]);
for n in ns
	df_ = df_raw[df_raw[:n] .== n, :]
	row = [
		"Network",
		"stochastic_edge_acceptance",
		n,
		mean(df_[:Δ_method_1]),
		mean(df_[:Δ_method_1_t_0]),
		mean(df_[:Δ_method_1_t_1]),
		mean(df_[:Δ_method_2]),
		mean(df_[:Δ_method_2_t_0]),
		mean(df_[:Δ_method_2_t_1]),
		median(df_[:Δ_method_1]),
		median(df_[:Δ_method_1_t_0]),
		median(df_[:Δ_method_1_t_1]),
		median(df_[:Δ_method_2]),
		median(df_[:Δ_method_2_t_0]),
		median(df_[:Δ_method_2_t_1]),
		std(df_[:Δ_method_1]),
		std(df_[:Δ_method_1_t_0]),
		std(df_[:Δ_method_1_t_1]),
		std(df_[:Δ_method_2]),
		std(df_[:Δ_method_2_t_0]),
		std(df_[:Δ_method_2_t_1]),
	]
	push!(df, row)
end

df

# %%

x_min = 15;
Δ_x   = 1;
x_max = 24;
border = 0.25;
y_min = 0.62;
Δ_y   = 0.02;
y_max = 0.78;

plot_ = plot(legend=:right, dpi=dpi);
plot!(log2.(df[:n]), df[:mean_Δ_method_1_t_0], yerror=df[:stdev_Δ_method_1_t_0],
	label=L"t_0",
	line=(1.5, :dodgerblue),
	markerstrokecolor=:black,
	xaxis=(latexstring("\\log_2 n"), (x_min-border, x_max+border), x_min:Δ_x:x_max),
	yaxis=(latexstring("r"), (y_min, y_max), y_min:Δ_y:y_max)
);
plot!(log2.(df[:n]), df[:mean_Δ_method_1_t_1], yerror=df[:stdev_Δ_method_1_t_1],
	label=L"t_1",
	line=(1.5, :orange1),
	markerstrokecolor=:black,
	xaxis=(latexstring("\\log_2 n")),
	yaxis=(latexstring("r"))
);

plot_

if save_bool
	savefig(plot_, joinpath(savepath, "Δ_scaling_1.png"))
end

# %%

x_min  = 15;
Δ_x    = 1;
x_max  = 24;
border = 0.25;
y_min  = 0.68;
Δ_y    = 0.01;
y_max  = 0.74;

plot_ = plot(legend=:right, dpi=dpi);
plot!(log2.(df[:n]), df[:mean_Δ_method_2_t_0], yerror=df[:stdev_Δ_method_2_t_0],
	label=L"t_0",
	line=(1.5, :dodgerblue),
	markerstrokecolor=:black,
	xaxis=(latexstring("\\log_2 n"), (x_min-border, x_max+border), x_min:Δ_x:x_max),
	yaxis=(latexstring("r"), (y_min, y_max), y_min:Δ_y:y_max)
);
plot!(log2.(df[:n]), df[:mean_Δ_method_2_t_1], yerror=df[:stdev_Δ_method_2_t_1],
	label=L"t_1",
	line=(1.5, :orange1),
	markerstrokecolor=:black,
	xaxis=(latexstring("\\log_2 n")),
	yaxis=(latexstring("r"))
);

plot_

if save_bool
	savefig(plot_, joinpath(savepath, "Δ_scaling_2.png"))
end
