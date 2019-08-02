path = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/code/Percolation.jl/src";
	push!(LOAD_PATH, path);
	using Percolation;
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
n = 10^6;
n_steps = Int(1.5n);

# %%

@time g = Network(n);
@time stochastic_edge_acceptance!(g, n_steps);
O = g.observables;
O.Δ_method_2

# %%

x = collect(0:n_steps) ./ n;
y = O.largest_cluster_size ./ n;
plot_largest_cluster_size = plot(legend=:right, dpi=dpi);
scatter!(x, y,
	legend=false,
	marker=(2, :dodgerblue, :circle, stroke(0)),
	xaxis=(latexstring("r"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/n"), (0, 1), 0:0.2:1)
)

# %%

x = collect(0:n_steps) ./ n;
y = O.heterogeneity;
plot_heterogeneity = plot(legend=:right, dpi=dpi);
scatter!(x, y,
	legend=false,
	marker=(2, :dodgerblue, :circle, stroke(0)),
	xaxis=(latexstring("r"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("H"))
)

# %%

x = collect(0:n_steps) ./ n;
y = O.avg_cluster_size;
plot_avg_cluster_size = plot(legend=:right, dpi=dpi);
scatter!(x, y,
	legend=false,
	marker=(2, :dodgerblue, :circle, stroke(0)),
	xaxis=(latexstring("r"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("\\overline{s}"), (0, 10), 0:2:10)
)

# %%

l = @layout [a{0.6h}; [b{0.5w} c]]
plot(plot_largest_cluster_size, plot_heterogeneity, plot_avg_cluster_size, layout=l)
