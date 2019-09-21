using DataStructures
using Plots; pyplot(fmt="png")
PyPlot.matplotlib.rc("mathtext", fontset="cm");
PyPlot.matplotlib.rc("text", usetex=true);
PyPlot.matplotlib.rc("font", family="serif", size=12);
using LaTeXStrings
using LsqFit
using Statistics
using JLD

data_dir = "/home/user/thesis/data/scaling";
savepath = "/home/user/thesis/latex/images";
save_bool = true
dpi = 144
if save_bool
	dpi = 300
end
save_bool

# %%


Ns = 2 .^ collect(15:24);
save_file = joinpath(data_dir, "cluster_size_distribution_avgs.jld")
distribution_avgs = load(save_file)["distribution_avgs"]


# %% Plot t_0 data


distribution_avg = distribution_avgs["t_0"]
# distribution_avg = Dict(2^k => distributions["t_0"][2^k][1] for k in 15:24)
plot_0 = plot(dpi=dpi);
Ns = sort(collect(keys(distribution_avg)));
colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(Ns))];
reverse!(colors);
markers = filter((m->begin m in Plots.supported_markers() end), Plots._shape_keys);

for i in 1:length(Ns)
	N = Ns[i]
	distribution = distribution_avg[N]
	s = collect(keys(distribution))
	n_s = collect(values(distribution))
	x = log10.(s)
	y = log10.(n_s)
	scatter!(x, y,
		legend=:topright,
		xaxis=(L"\log_{10} (s)", (-0.2, 5)),
		yaxis=(L"\log_{10} (n_s(t_0))", (-12, 0)),
		marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])),
		label=latexstring("N = 2^{$(Int(log2(N)))}"),
	)
end

@. function f_linear(x, α)
	return α[1] * x + α[2]
end

αs    = [];
σs    = [];
ratio = 0.01;
for N in Ns[end:end]
	d = distribution_avg[N];
	x = log10.(collect(keys(d)));
	y = log10.(collect(values(d)));
	order = sortperm(x);
	x = x[order][1:Int(floor(ratio * length(x)))];
	y = y[order][1:Int(floor(ratio * length(y)))];
	fit = curve_fit(f_linear, x, y, [-0.1, 0])
	push!(αs, fit.param)
	push!(σs, stderror(fit))
end

α = sum(αs) / length(αs)
σ = sum(σs) / length(σs)
τ₀ = -α[1]

d = distribution_avg[2^24];
x = log10.(collect(keys(d)));
order = sortperm(x);
x = x[order][1:Int(floor(ratio * length(x)))];
y = f_linear(x, α);
plot!(x, y,
	label=latexstring("\\mathrm{Fit} (N = 2^{24}) \\sim $(round(α[1], digits=3)) ($(Int(round(σ[1] * 1e3, digits=0)))) \\cdot \\log_{10}(s)"),
	line=(1, :black),
)

if save_bool
	savefig(plot_0, joinpath(savepath, "n_s_t_0.png"));
end

plot_0


# %% Plot t_1 data


distribution_avg = distribution_avgs["t_1"];
plot_1 = plot(dpi=dpi);
Ns = sort(collect(keys(distribution_avg)));
colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(Ns))];
reverse!(colors);
markers = filter((m->begin m in Plots.supported_markers() end), Plots._shape_keys);

for i in 1:length(Ns)
	N = Ns[i]
	distribution = distribution_avg[N]
	s = collect(keys(distribution))
	n_s = collect(values(distribution))
	x = log10.(s ./ N)
	y = log10.(n_s)
	scatter!(x, y,
		legend=:topright,
		xaxis=(L"\log_{10} (s / N)", (-8, 0)),
		yaxis=(L"\log_{10} (n_s(t_1))", (-12, 0)),
		marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])),
		label=latexstring("N = 2^{$(Int(log2(N)))}"),
	)
end

@. function f_linear(x, α)
	return α[1] * x + α[2]
end

αs    = [];
σs    = [];
ratio = 0.10;
for N in Ns[end:end]
	d = distribution_avg[N];
	x = log10.(collect(keys(d)) ./ N);
	y = log10.(collect(values(d)));
	order = sortperm(x);
	x = x[order][1:Int(floor(ratio * length(x)))];
	y = y[order][1:Int(floor(ratio * length(y)))];
	fit = curve_fit(f_linear, x, y, [-0.1, 0])
	push!(αs, fit.param)
	push!(σs, stderror(fit))
end

α = sum(αs) / length(αs)
σ = sum(σs) / length(σs)
τ₁ = -α[1]

d = distribution_avg[2^24];
x = log10.(collect(keys(d)) ./ 2^24);
order = sortperm(x);
x = x[order][1:Int(floor(ratio * length(x)))];
y = f_linear(x, α)
plot!(x, y,
	label=latexstring("\\mathrm{Fit} (N = 2^{24}) \\sim $(round(α[1], digits=3)) ($(Int(round(σ[1] * 1e3, digits=0)))) \\cdot \\log_{10}(s/N)"),
	line=(1, :black),
)

if save_bool
	savefig(plot_1, joinpath(savepath, "n_s_t_1.png"));
end

plot_1


# %% Plot FSS collapse for τ₀


distribution_avg = distribution_avgs["t_0"]
plot_a = plot(dpi=dpi);
Ns = sort(collect(keys(distribution_avg)));
colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(Ns))]
reverse!(colors)
markers = filter((m->begin m in Plots.supported_markers() end), Plots._shape_keys)

for i in 1:length(Ns)
	N = Ns[i]
	distribution = distribution_avg[N]
	s = collect(keys(distribution))
	n_s = collect(values(distribution))
	x = log10.(s ./ N^(1/τ₁))
	y = log10.(s.^τ₁ .* n_s)
	scatter!(x, y,
		legend=:topleft,
		xaxis=(L"\log_{10} (s / N^{1/\tau})", (-4, 2), -4:1:2),
		yaxis=(L"\log_{10} (s^\tau n_s(t_0))", (-1.5, 0.5), -1.5:0.5:0.5),
		marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])),
		label=latexstring("N = 2^{$(Int(log2(N)))}"),
	)
	annotate!(-2, 0, text(latexstring("\\tau_1 \\approx $(round(τ₁, digits=3))")))
end

if save_bool
	savefig(plot_a, joinpath(savepath, "fss_collapse.png"));
end

plot_a


# %% Plot FSS collapse for τ₀


distribution_avg = distribution_avgs["t_0"]
plot_b = plot(dpi=dpi);
Ns = sort(collect(keys(distribution_avg)));
colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(Ns))]
reverse!(colors)
markers = filter((m->begin m in Plots.supported_markers() end), Plots._shape_keys)

for i in 1:length(Ns)
	N = Ns[i]
	distribution = distribution_avg[N]
	s = collect(keys(distribution))
	n_s = collect(values(distribution))
	x = log10.(s ./ N^(1/τ₀))
	y = log10.(s.^τ₀ .* n_s)
	scatter!(x, y,
		legend=false,
		xaxis=(L"\log_{10} (s / N^{1/\tau})", (-4, 2), -4:1:2),
		yaxis=(L"\log_{10} (s^\tau n_s(t_0))", (-1.5, 0.5), -1.5:0.5:0.5),
		marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])),
		label=latexstring("N = 2^{$(Int(log2(N)))}"),
	)
	annotate!(-2, 0, text(latexstring("\\tau_0 \\approx $(round(τ₀, digits=3))")))
end

plot_b


# %% Plot FSS collapse for τ₀


τ_ref = τ₁ + 0.05
distribution_avg = distribution_avgs["t_0"]
plot_c = plot(dpi=dpi);
Ns = sort(collect(keys(distribution_avg)));
colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(Ns))]
reverse!(colors)
markers = filter((m->begin m in Plots.supported_markers() end), Plots._shape_keys)

for i in 1:length(Ns)
	N = Ns[i]
	distribution = distribution_avg[N]
	s = collect(keys(distribution))
	n_s = collect(values(distribution))
	x = log10.(s ./ N^(1/τ_ref))
	y = log10.(s.^τ_ref .* n_s)
	scatter!(x, y,
		legend=false,
		xaxis=(L"\log_{10} (s / N^{1/\tau})", (-4, 2), -4:1:2),
		yaxis=(L"\log_{10} (s^\tau n_s(t_0))", (-1.5, 0.5), -1.5:0.5:0.5),
		marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])),
		label=latexstring("N = 2^{$(Int(log2(N)))}"),
	)
	annotate!(-2, 0, text(latexstring("\\tau_1 + 0.05")))
end

plot_c


# %% Plot FSS comparison


l = @layout [a{0.6h}; [b{0.5w} c]]
plot_triple = plot(plot_a, plot_b, plot_c, layout=l, size=(800, 600))

if save_bool
	savefig(plot_triple, joinpath(savepath, "fss_collapse_triple.png"));
end

plot_triple


# %% Maximual decay exponent calculation


δ = 0.302;
exponent_of_decay = -δ * (τ₁ - 2) / (τ₁ - 1)
