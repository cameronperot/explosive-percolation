path = "/home/user/GraphEvolve.jl/src";
	push!(LOAD_PATH, path);
	using GraphEvolve;
	using Revise
	using BenchmarkTools
	using Profile
	using ProfileView
	using JLD
	using Statistics
	using Plots; gr(fmt="png")
	using LaTeXStrings

# %%

savepath = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/latex/images/";
graph_type = "Network";
save_bool = true
save_bool ? dpi = 300 : dpi = 144
n = 10^6;
n_steps = Int(1.5n);

graph_types = Dict(
	"Network" => Network,
	"Lattice2D" => Lattice2D,
	"Lattice3D" => Lattice3D
);

# %%

@time g_ER = graph_types[graph_type](n);
@time erdos_renyi!(g_ER, n_steps);

# %%

@time g_BF = graph_types[graph_type](n);
@time bohman_frieze!(g_BF, n_steps, K=2);

# %%

@time g_PR = graph_types[graph_type](n);
@time product_rule!(g_PR, n_steps);

# %%

@time g_SEA = graph_types[graph_type](n);
@time stochastic_edge_acceptance!(g_SEA, n_steps);

# %%

plot_ = plot(legend=:right, dpi=dpi);

# %% ER plot

g = g_ER
x = collect(0:g.t) ./ g.n;
y = g.observables.largest_cluster_size ./ g.n;
scatter!(x, y,
	label="ER",
	marker=(2, :orange1, :circle, 0.9, stroke(0)),
	xaxis=(latexstring("r"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/n"), (0, 1), 0:0.2:1)
)

if save_bool
	savefig(plot_, joinpath(savepath, string(graph_type, "_ER_1e6_order_param.png")))
end

# %% ER-BF plot

g = g_BF
x = collect(0:g.t) ./ g.n;
y = g.observables.largest_cluster_size ./ g.n;
scatter!(x, y,
	label="BF",
	marker=(2, :forestgreen, :circle, 0.9, stroke(0)),
	xaxis=(latexstring("r"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/n"), (0, 1), 0:0.2:1)
)

if save_bool
	savefig(plot_, joinpath(savepath, string(graph_type, "_ER_BF_1e6_order_param.png")))
end

# %% ER-BF-PR plot

g = g_PR
x = collect(0:g.t) ./ g.n;
y = g.observables.largest_cluster_size ./ g.n;
scatter!(x, y,
	label="PR",
	marker=(2, :firebrick1, :circle, 0.9, stroke(0)),
	xaxis=(latexstring("r"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/n"), (0, 1), 0:0.2:1)
)

if save_bool
	savefig(plot_, joinpath(savepath, string(graph_type, "_ER_BF_PR_1e6_order_param.png")))
end

# %% ER-BF-PR plot

g = g_SEA
x = collect(0:g.t) ./ g.n;
y = g.observables.largest_cluster_size ./ g.n;
scatter!(x, y,
	label="SEA",
	marker=(2, :dodgerblue, :circle, 0.9, stroke(0)),
	xaxis=(latexstring("r"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/n"), (0, 1), 0:0.2:1)
)

if save_bool
	savefig(plot_, joinpath(savepath, string(graph_type, "_ER_BF_PR_SEA_1e6_order_param.png")))
end
plot_
