path = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/code/Percolation.jl/src";
	push!(LOAD_PATH, path);
	using Percolation;
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
save_bool = true
save_bool ? dpi = 300 : dpi = 144
n = 10^6;
n_steps = Int(1.5n);

# %%

@time g_ER = Network(n);
@time erdos_renyi!(g_ER, n_steps);

# %%

@time g_BF = Network(n);
@time bohman_frieze!(g_BF, n_steps, K=2);

# %%

@time g_PR = Network(n);
@time product_rule!(g_PR, n_steps);

# %%

@time g_SEA = Network(n);
@time p_rule_2!(g_SEA, n_steps);

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

save_bool ? savefig(plot_, joinpath(savepath, "ER_1e6_order_param.png")) : nothing

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

save_bool ? savefig(plot_, joinpath(savepath, "ER_BF_1e6_order_param.png")) : nothing

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

save_bool ? savefig(plot_, joinpath(savepath, "ER_BF_PR_1e6_order_param.png")) : nothing

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

save_bool ? savefig(plot_, joinpath(savepath, "ER_BF_PR_SEA_1e6_order_param.png")) : nothing
plot_
