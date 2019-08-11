path = "/home/user/GraphEvolve.jl/src";
	push!(LOAD_PATH, path);
	using GraphEvolve;
	using Revise
	using BenchmarkTools
	using Profile
	using ProfileView
	using JLD
	using Statistics
	using Plots; pyplot(fmt="png")
	PyPlot.matplotlib.rc("mathtext", fontset="cm");
	PyPlot.matplotlib.rc("text", usetex=true);
	PyPlot.matplotlib.rc("font", family="serif", size=12);
	using LaTeXStrings


# %%


savepath = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/latex/images/";
graph_type = "Network";
save_bool = true
save_bool ? dpi = 300 : dpi = 144
N = 10^6;
n_steps = Int(1.5N);
legend_location = :right
if graph_type == "Lattice2D"
	N = 1000
	legend_location = :left
elseif graph_type == "Lattice3D"
	N = 100
	legend_location = :left
end

graph_types = Dict(
	"Network" => Network,
	"Lattice2D" => Lattice2D,
	"Lattice3D" => Lattice3D
);

# %%

@time g_ER = graph_types[graph_type](N);
@time erdos_renyi!(g_ER, n_steps);

# %%

@time g_BF = graph_types[graph_type](N);
@time bohman_frieze!(g_BF, n_steps, K=2);

# %%

@time g_PR = graph_types[graph_type](N);
@time product_rule!(g_PR, n_steps);

# %%

@time g_SEA = graph_types[graph_type](N);
@time stochastic_edge_acceptance!(g_SEA, n_steps);

# %%

plot_ = plot(legend=:right, dpi=dpi);

# %% ER plot

g = g_ER
x = collect(0:g.t) ./ g.N;
y = g.observables.largest_cluster_size ./ g.N;
scatter!(x, y,
	legend=legend_location,
	label="ER",
	marker=(2, :orange1, :circle, 0.667, stroke(:orange1)),
	xaxis=(latexstring("t/N"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/N"), (0, 1), 0:0.2:1)
)

if save_bool
	savefig(plot_, joinpath(savepath, string(graph_type, "_ER_1e6_order_param.png")))
end

# %% ER-BF plot

g = g_BF
x = collect(0:g.t) ./ g.N;
y = g.observables.largest_cluster_size ./ g.N;
scatter!(x, y,
	legend=legend_location,
	label="BF",
	marker=(2, :forestgreen, :circle, 0.667, stroke(:forestgreen)),
	xaxis=(latexstring("t/N"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/N"), (0, 1), 0:0.2:1)
)

if save_bool
	savefig(plot_, joinpath(savepath, string(graph_type, "_ER_BF_1e6_order_param.png")))
end

# %% ER-BF-PR plot

g = g_PR
x = collect(0:g.t) ./ g.N;
y = g.observables.largest_cluster_size ./ g.N;
scatter!(x, y,
	legend=legend_location,
	label="PR",
	marker=(2, :firebrick1, :circle, 0.667, stroke(:firebrick1)),
	xaxis=(latexstring("t/N"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/N"), (0, 1), 0:0.2:1)
)

if save_bool
	savefig(plot_, joinpath(savepath, string(graph_type, "_ER_BF_PR_1e6_order_param.png")))
end

# %% ER-BF-PR-SEA plot

g = g_SEA
x = collect(0:g.t) ./ g.N;
y = g.observables.largest_cluster_size ./ g.N;
scatter!(x, y,
	legend=legend_location,
	label="SEA",
	marker=(2, :dodgerblue, :circle, 0.667, stroke(:dodgerblue)),
	xaxis=(latexstring("t/N"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/N"), (0, 1), 0:0.2:1)
)

if save_bool
	savefig(plot_, joinpath(savepath, string(graph_type, "_ER_BF_PR_SEA_1e6_order_param.png")))
end
plot_
