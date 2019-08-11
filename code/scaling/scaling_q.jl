path = "/home/user/GraphEvolve.jl/src"
push!(LOAD_PATH, path);
using GraphEvolve;
using Plots; pyplot(fmt="png");
PyPlot.matplotlib.rc("mathtext", fontset="cm");
PyPlot.matplotlib.rc("text", usetex=true);
PyPlot.matplotlib.rc("font", family="serif", size=12)
using LaTeXStrings
using Printf
using Dates


# %%


function plot_Network(N, qs, evolution_method, savepath)
	colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(qs))]
	reverse!(colors)
	markers = filter((m->begin m in Plots.supported_markers() end), Plots._shape_keys)

	plot_C = plot(dpi=300,
		legend=:topleft,
		xaxis=(L"t/N", (0, 1.5), 0:0.5:1.5),
		yaxis=(latexstring("|C|/N"), (0, 1), 0:0.2:1))
	plot_S = plot(dpi=300,
		legend=false,
		xaxis=(L"t/N", (0, 1.5), 0:0.5:1.5),
		yaxis=(L"\overline{s}"), (0, 10))
	plot_H = plot(dpi=300,
		legend=false,
		xaxis=(L"t/N", (0, 1.5), 0:0.5:1.5),
		yaxis=(L"H/N"), (0, 0.004))

	for (i, q) in enumerate(qs)
		t₀ = now()
		g = Network(N)
		evolution_method(g, Int(floor(1.5N)), q)

		x = collect(0:g.t) ./ N

		scatter!(plot_C, x, g.observables.largest_cluster_size ./ N,
			label=latexstring("q = $(q)"),
			marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])))
		scatter!(plot_S, x, g.observables.avg_cluster_size,
			label=latexstring("q = $(q)"),
			marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])))
		scatter!(plot_H, x, g.observables.heterogeneity ./ N,
			label=latexstring("q = $(q)"),
			marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])))

		t₁ = now()
		runtime = Dates.value(t₁ - t₀) / 1000
		println("q = $(q), time to run: $(runtime)s")
	end

	savefig(plot_C, joinpath(savepath, "q_scaling.png"))

	l = @layout [a{0.6h}; [b{0.5w} c]]
	plot_ = plot(plot_C, plot_H, plot_S, layout=l)
	savefig(plot_,
		joinpath(savepath,
			string("Network_",
				replace(replace(string(evolution_method), "GraphEvolve." => ""), "!" => ""),
				"_q.png"
			)
		)
	)
end


# %%


evolution_method = stochastic_edge_acceptance!
N = 10^6;
qs = 2:8
savepath = "/home/user/thesis/latex/images"

plot_Network(N, qs, evolution_method, savepath)
