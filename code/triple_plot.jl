path = "/home/user/GraphEvolve.jl/src";
	push!(LOAD_PATH, path);
	using GraphEvolve;
	using Revise
	using BenchmarkTools
	using Profile
	using ProfileView
	using LaTeXStrings
	using JLD
	using Statistics
	using Plots; gr(fmt="png")
	using LaTeXStrings

# %%

savepath = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/latex/images/";
dpi = 144
N = 10^6;
n_steps = Int(1.5N);

# %%

@time g = Network(N);
@time stochastic_edge_acceptance!(g, n_steps);
O = g.observables;

# %%

x = collect(0:n_steps) ./ N;
y = O.largest_cluster_size ./ N;
plot_largest_cluster_size = plot(legend=:right, dpi=dpi);
scatter!(x, y,
	legend=false,
	marker=(2, :dodgerblue, :circle, stroke(0)),
	xaxis=(latexstring("t/N"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/N"), (0, 1), 0:0.2:1)
)

# %%

x = collect(0:n_steps) ./ N;
y = O.heterogeneity;
plot_heterogeneity = plot(legend=:right, dpi=dpi);
scatter!(x, y,
	legend=false,
	marker=(2, :dodgerblue, :circle, stroke(0)),
	xaxis=(latexstring("t/N"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("H"))
)

# %%

x = collect(0:n_steps) ./ N;
y = O.avg_cluster_size;
plot_avg_cluster_size = plot(legend=:right, dpi=dpi);
scatter!(x, y,
	legend=false,
	marker=(2, :dodgerblue, :circle, stroke(0)),
	xaxis=(latexstring("t/N"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("\\overline{s}"), (0, 10), 0:2:10)
)

# %%

l = @layout [a{0.6h}; [b{0.5w} c]]
plot(plot_largest_cluster_size, plot_heterogeneity, plot_avg_cluster_size, layout=l)
