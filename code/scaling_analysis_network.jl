using Statistics
using DataFrames
using CSV
using Plots; pyplot(fmt="png")
PyPlot.matplotlib.rc("mathtext", fontset="cm");
PyPlot.matplotlib.rc("text", usetex=true);
PyPlot.matplotlib.rc("font", family="serif", size=12);
using LaTeXStrings
using LsqFit

path = "/home/user/thesis/data/scaling/";
graph_type = "Network";
evolution_method = "stochastic_edge_acceptance";
data_file = string(path, graph_type, "_", evolution_method, ".csv");

savepath = "/home/user/thesis/latex/images"
save_bool = false
dpi = 144
if save_bool
	dpi = 300
end


# %% loading and computing df


df_raw = CSV.read(data_file) |> DataFrame;

Int.(df_raw[:, :N] .* df_raw[:, :r_1])
maximum(df_raw[:, :r_1])
cols = [
	:N,
	:r_0,
	:r_1,
	:m_0,
	:m_1,
	:Δr,
	:Δm,
];

df = aggregate(df_raw[:, cols], :N, [mean, std, median]);


# %% plotting Δr


x_min  = 15;
Δ_x    = 1;
x_max  = 24;
border = 0.25;
y_min  = 0.68;
Δ_y    = 0.01;
y_max  = 0.74;

plot_ = plot(legend=:right, dpi=dpi);
plot!(log2.(df[:, :N]), df[:, :r_0_mean], yerror=df[:, :r_0_std],
	label=L"t_0/N",
	line=(1, :black, 0.8),
	marker=(5, :dodgerblue, :circle, 0.8, stroke(:dodgerblue)),
	xaxis=(latexstring("\\log_2 (N)"), (x_min-border, x_max+border), x_min:Δ_x:x_max),
	yaxis=(latexstring("t/N"), (y_min, y_max), y_min:Δ_y:y_max)
);
plot!(log2.(df[:, :N]), df[:, :r_1_mean], yerror=df[:, :r_1_std],
	label=L"t_1/N",
	line=(1, :black, 0.8),
	marker=(5, :firebrick1, :circle, 0.8, stroke(:firebrick1)),
);

if save_bool
	savefig(plot_, joinpath(savepath, "r_scaling.png"))
end

plot_


# %% plotting and fitting Δm



@. function f_linear(x, α)
	return α[1] * x + α[2]
end

α     = [-0.1, -1.5];
α_exp = [1., -1e6, 0.];
x     = log2.(df[:, :N]);
y     = log2.(df[:, :Δr_mean]);
σ     = df[:, :Δr_std];
fit   = curve_fit(f_linear, x, y, α);
y_fit = f_linear(x, fit.param);
α     = fit.param
σ     = stderror(fit)

plot_ = plot(dpi=dpi);
plot!(x, y_fit,
	label=latexstring("$(round(α[1], digits=3)) ($(Int(round(σ[1] * 1e3, digits=0)))) \\cdot \\log_2(N) + $(round(α[2], digits=3)) ($(Int(round(σ[2] * 1e3, digits=0))))"),
	line=(1, :black, 0.8)
);
scatter!(x, y,
	label="Observed",
	markerstrokecolor=:black,
	marker=(6, :dodgerblue, :circle, 0.8, stroke(:dodgerblue)),
	xaxis=(L"\log_2 (N)", 15:1:24),
	yaxis=(L"\log_2 (\Delta m)", (-3.8, -2), -3.8:0.2:-2)
);

if save_bool
	savefig(plot_, joinpath(savepath, "delta_r_scaling.png"))
end

plot_


# %%


@. function f_linear(x, α)
	return α[1] * x + α[2]
end

α     = [-0.1, -1.5];
α_exp = [1., -1e6, 0.];
x     = log2.(df[:, :N]);
y     = log2.(df[:, :Δm_mean]);
σ     = df[:, :Δm_std];
fit   = curve_fit(f_linear, x, y, α);
y_fit = f_linear(x, fit.param);
α     = fit.param
σ     = stderror(fit)

plot_ = plot(dpi=dpi);
plot!(x, y_fit,
	label=latexstring("$(round(α[1], digits=3)) ($(Int(round(σ[1] * 1e3, digits=0)))) \\cdot \\log_2(N) + $(round(α[2], digits=3)) ($(Int(round(σ[2] * 1e3, digits=0))))"),
	line=(1, :black, 0.8)
);
scatter!(x, y,
	label="Observed",
	markerstrokecolor=:black,
	marker=(6, :dodgerblue, :circle, 0.8, stroke(:dodgerblue)),
	xaxis=(L"\log_2 (N)", 15:1:24),
	yaxis=(L"\log_2 (\Delta m)", (-3.8, -2), -3.8:0.2:-2)
);

if save_bool
	savefig(plot_, joinpath(savepath, "delta_m_scaling.png"))
end

plot_
