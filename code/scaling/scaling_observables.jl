path = "/home/user/GraphEvolve.jl/src"
# path = "/home/perot/julia/GraphEvolve.jl/src";
push!(LOAD_PATH, path);
using GraphEvolve;
using Plots; gr(fmt="png");
using LaTeXStrings
using Printf

# %%

function plot_Network(ns, evolution_method, savepath)
	colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(ns))]
	reverse!(colors)
	markers = filter((m->begin m in Plots.supported_markers() end), Plots._shape_keys)

	plot_C = plot(dpi=300,
		legend=:topleft,
		xaxis=(L"r"),
		yaxis=(L"|C|/n"))
	plot_S = plot(dpi=300,
		legend=false,
		xaxis=(L"r"),
		yaxis=(L"\overline{s}"))
	plot_H = plot(dpi=300,
		legend=false,
		xaxis=(L"r"),
		yaxis=(L"H"))

	for (i, n) in enumerate(ns)
		println(Int(log2(n)))
		g = Network(n)
		evolution_method(g, Int(floor(1.5 * n)))

		n_string = @sprintf("%.1e", n)
		n_string = Int(log2(n))
		x = collect(0:g.t) ./ n

		scatter!(plot_C, x, g.observables.largest_cluster_size ./n,
			label=latexstring("\$\\log_2 n = $(n_string)\$"),
			marker=(2, colors[i], :circle, stroke(0)))
		scatter!(plot_S, x, g.observables.avg_cluster_size,
			label=latexstring("\$\\log_2 n = $(n_string)\$"),
			marker=(2, colors[i], :circle, stroke(0)))
		scatter!(plot_H, x, g.observables.heterogeneity,
			label=latexstring("\$\\log_2 n = $(n_string)\$"),
			marker=(2, colors[i], :circle, stroke(0)))
	end

	# savefig(plot_C, joinpath(savepath, "Network_C.png"))
	# savefig(plot_S, joinpath(savepath, "Network_S.png"))
	# savefig(plot_H, joinpath(savepath, "Network_H.png"))

	l = @layout [a{0.6h}; [b{0.5w} c]]
	plot_ = plot(plot_C, plot_H, plot_S, layout=l)
	savefig(plot_,
		joinpath(savepath,
			string("Network",
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

	plot_C = plot(title="2D Lattice", dpi=300,
		legend=:topleft,
		xaxis=(L"r"),
		yaxis=(L"|C|/n"))
	plot_S = plot(title="2D Lattice", dpi=300,
		legend=:topleft,
		xaxis=(L"r"),
		yaxis=(L"\overline{s}"))
	plot_H = plot(title="2D Lattice", dpi=300,
		legend=:topleft,
		xaxis=(L"r"),
		yaxis=(L"H"))

	for (i, L) in enumerate(Ls)
		n = L^2
		g = Lattice2D(L)
		evolution_method(g, Int(floor(1.5 * n)))

		x = collect(0:g.t) ./ n
		scatter!(plot_C, x, g.observables.largest_cluster_size ./n,
			label=latexstring("\$n = $(L)\$"),
			marker=(2, colors[i], :circle, stroke(0)))
		scatter!(plot_S, x, g.observables.avg_cluster_size,
			label=latexstring("\$n = $(L)\$"),
			marker=(2, colors[i], :circle, stroke(0)))
		scatter!(plot_H, x, g.observables.heterogeneity,
			label=latexstring("\$n = $(L)\$"),
			marker=(2, colors[i], :circle, stroke(0)))
	end

	savefig(plot_C, joinpath(savepath, "Lattice2D_C.png"))
	savefig(plot_S, joinpath(savepath, "Lattice2D_S.png"))
	savefig(plot_H, joinpath(savepath, "Lattice2D_H.png"))

	l = @layout [a{0.6h}; [b{0.5w} c]]
	plot_ = plot(plot_C, plot_H, plot_S, layout=l)
	savefig(plot_, joinpath(savepath, "Lattice2D_observables.png"))
end


function plot_Lattice3D(Ls, evolution_method, savepath)
	colors = RGB[cgrad(:plasma)[z] for z=range(0, stop=1, length=length(Ls))]
	reverse!(colors)
	markers = filter((m->begin m in Plots.supported_markers() end), Plots._shape_keys)

	plot_C = plot(title="3D Lattice", dpi=300,
		legend=:topleft,
		xaxis=(L"r"),
		yaxis=(L"|C|/n"))
	plot_S = plot(title="3D Lattice", dpi=300,
		legend=:topleft,
		xaxis=(L"r"),
		yaxis=(L"\overline{s}"))
	plot_H = plot(title="3D Lattice", dpi=300,
		legend=:topleft,
		xaxis=(L"r"),
		yaxis=(L"H"))

	for (i, L) in enumerate(Ls)
		n = L^3
		g = Lattice3D(L)
		evolution_method(g, Int(floor(1.5 * n)))

		x = collect(0:g.t) ./ n
		scatter!(plot_C, x, g.observables.largest_cluster_size ./n,
			label=latexstring("\$L = $(L)\$"),
			marker=(2, colors[i], :circle, stroke(0)))
		scatter!(plot_S, x, g.observables.avg_cluster_size,
			label=latexstring("\$L = $(L)\$"),
			marker=(2, colors[i], :circle, stroke(0)))
		scatter!(plot_H, x, g.observables.heterogeneity,
			label=latexstring("\$L = $(L)\$"),
			marker=(2, colors[i], :circle, stroke(0)))
	end

	savefig(plot_C, joinpath(savepath, "Lattice3D_C.png"))
	savefig(plot_S, joinpath(savepath, "Lattice3D_S.png"))
	savefig(plot_H, joinpath(savepath, "Lattice3D_H.png"))

	l = @layout [a{0.6h}; [b{0.5w} c]]
	plot_ = plot(plot_C, plot_H, plot_S, layout=l)
	savefig(plot_, joinpath(savepath, "Lattice3D_observables.png"))
end

# %%

evolution_method = stochastic_edge_acceptance!
ns = 2 .^ collect(15:24);
Ls_2D = Int.(floor.(collect(range(200, stop=8000, length=11))));
Ls_3D = Int.(floor.(collect(range(40, stop=400, length=11))));
savepath = "/home/user/thesis/latex/images"
# savepath = "/home/perot/julia/scaling/images"

plot_Network(ns, evolution_method, savepath)
# plot_Lattice2D(Ls_2D, evolution_method, savepath)
# plot_Lattice3D(Ls_3D, evolution_method, savepath)
