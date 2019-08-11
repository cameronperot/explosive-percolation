path = "/home/user/GraphEvolve.jl/src"
# path = "/home/perot/julia/GraphEvolve.jl/src";
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


function plot_Network(Ns, evolution_method, savepath)
	colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(Ns))]
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

	for (i, N) in enumerate(Ns)
		t₀ = now()
		g = Network(N)
		evolution_method(g, Int(floor(1.5N)))

		n_string = @sprintf("%.1e", N)
		n_string = Int(log2(N))
		x = collect(0:g.t) ./ N

		scatter!(plot_C, x, g.observables.largest_cluster_size ./ N,
			label=latexstring("\$\\log_2 N = $(n_string)\$"),
			marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])))
		scatter!(plot_S, x, g.observables.avg_cluster_size,
			label=latexstring("\$\\log_2 N = $(n_string)\$"),
			marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])))
		scatter!(plot_H, x, g.observables.heterogeneity ./ N,
			label=latexstring("\$\\log_2 N = $(n_string)\$"),
			marker=(2, colors[i], markers[i], 0.8, stroke(colors[i])))

		t₁ = now()
		runtime = Dates.value(t₁ - t₀) / 1000
		println("k = $(n_string), time to run: $(runtime)s")
	end

	l = @layout [a{0.6h}; [b{0.5w} c]]
	plot_ = plot(plot_C, plot_H, plot_S, layout=l)
	savefig(plot_,
		joinpath(savepath,
			string("Network_",
				replace(replace(string(evolution_method), "GraphEvolve." => ""), "!" => ""),
				"_observables.png"
			)
		)
	)
end


function plot_Lattice2D(Ls, evolution_method, savepath)
	colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(Ls))]
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

	for (i, L) in enumerate(Ls)
		N = L^2
		g = Lattice2D(L)
		evolution_method(g, Int(floor(1.5N)))

		x = collect(0:g.t) ./ N
		scatter!(plot_C, x, g.observables.largest_cluster_size ./ N,
			label=latexstring("\$N = $(L)\$"),
			marker=(2, colors[i], markers[i], stroke(0)))
		scatter!(plot_S, x, g.observables.avg_cluster_size,
			label=latexstring("\$N = $(L)\$"),
			marker=(2, colors[i], markers[i], stroke(0)))
		scatter!(plot_H, x, g.observables.heterogeneity ./ N,
			label=latexstring("\$N = $(L)\$"),
			marker=(2, colors[i], markers[i], stroke(0)))
	end

	# savefig(plot_C, joinpath(savepath, "Lattice2D_C.png"))
	# savefig(plot_S, joinpath(savepath, "Lattice2D_S.png"))
	# savefig(plot_H, joinpath(savepath, "Lattice2D_H.png"))

	l = @layout [a{0.6h}; [b{0.5w} c]]
	plot_ = plot(plot_C, plot_H, plot_S, layout=l)
	savefig(plot_, joinpath(savepath, "Lattice2D_observables.png"))
end


function plot_Lattice3D(Ls, evolution_method, savepath)
	colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(Ls))]
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

	for (i, L) in enumerate(Ls)
		N = L^3
		g = Lattice3D(L)
		evolution_method(g, Int(floor(1.5N)))

		x = collect(0:g.t) ./ N
		scatter!(plot_C, x, g.observables.largest_cluster_size ./ N,
			label=latexstring("\$L = $(L)\$"),
			marker=(2, colors[i], markers[i], stroke(0)))
		scatter!(plot_S, x, g.observables.avg_cluster_size,
			label=latexstring("\$L = $(L)\$"),
			marker=(2, colors[i], markers[i], stroke(0)))
		scatter!(plot_H, x, g.observables.heterogeneity ./ N,
			label=latexstring("\$L = $(L)\$"),
			marker=(2, colors[i], markers[i], stroke(0)))
	end

	# savefig(plot_C, joinpath(savepath, "Lattice3D_C.png"))
	# savefig(plot_S, joinpath(savepath, "Lattice3D_S.png"))
	# savefig(plot_H, joinpath(savepath, "Lattice3D_H.png"))

	l = @layout [a{0.6h}; [b{0.5w} c]]
	plot_ = plot(plot_C, plot_H, plot_S, layout=l)
	savefig(plot_, joinpath(savepath, "Lattice3D_observables.png"))
end

# %%

evolution_method = stochastic_edge_acceptance!
Ns = 2 .^ collect(15:23);
Ls_2D = Int.(floor.(collect(range(200, stop=8000, length=11))));
Ls_3D = Int.(floor.(collect(range(40, stop=400, length=11))));
savepath = "/home/user/thesis/latex/images"
# savepath = "/home/perot/julia/scaling"

plot_Network(Ns, evolution_method, savepath)
# plot_Lattice2D(Ls_2D, evolution_method, savepath)
# plot_Lattice3D(Ls_3D, evolution_method, savepath)
