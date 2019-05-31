path = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/code/Percolation.jl/src";
	push!(LOAD_PATH, path);
	using Percolation;
	using Revise
	using BenchmarkTools
	using Profile
	using ProfileView
	using Plots; pyplot(); using LaTeXStrings
	using JLD
	using Statistics
	using Plots; gr()
	using LaTeXStrings

# %%

savepath = "/home/user/rsync/education/uni-leipzig/semester-6/thesis/latex/images/";
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

# %% ER plot

x_ER = collect(0:g_ER.t) ./ g_ER.n;
y_ER = g_ER.C ./ g_ER.n;
plot_ER = plot(legend=:right, dpi=300);
scatter!(x_ER, y_ER,
	label="ER",
	marker=(2, :blue, :circle, 0.7, stroke(0)),
	xaxis=(latexstring("r"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/n"), (0, 1), 0:0.2:1))
savefig(plot_ER, string(savepath, "ER_1e6_order_param.png"))

# %% ER-BF plot

x_BF = collect(0:g_BF.t) ./ g_BF.n;
y_BF = g_BF.C ./ g_BF.n;
scatter!(x_BF, y_BF,
	label="BF",
	marker=(2, :green, :diamond, 0.7, stroke(0)),
	xaxis=(latexstring("r"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/n"), (0, 1), 0:0.2:1))
savefig(plot_ER, string(savepath, "ER_BF_1e6_order_param.png"))

# %% ER-BF-PR plot

x_PR = collect(0:g_PR.t) ./ g_PR.n;
y_PR = g_PR.C ./ g_PR.n;
scatter!(x_PR, y_PR,
	label="PR",
	marker=(2, :red, :hex, 0.7, stroke(0)),
	xaxis=(latexstring("r"), (0, 1.5), 0:0.5:1.5),
	yaxis=(latexstring("|C|/n"), (0, 1), 0:0.2:1))
savefig(plot_ER, string(savepath, "ER_BF_PR_1e6_order_param.png"))
