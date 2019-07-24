# function plot_order_parameter(g::AbstractGraph)
# 	x = collect(0:g.t) ./ g.n
# 	y = g.largest_cluster_size ./ g.n
# 	plot_out = plot(legend=false, dpi=300)
# 	scatter!(x, y,
# 		marker=(3, :red, :hexagon, 0.5, Plots.stroke(0)),
# 		xaxis=(L"t/n"),
# 		yaxis=(L"|C|/n"))
# 	return plot_out
# end


function plot_order_parameter(g::AbstractGraph, file="plot.png", title="")
	x = collect(0:g.t) ./ g.n
	y = g.largest_cluster_size ./ g.n
	plot_out = Plots.plot(legend=false, dpi=300)
	Plots.scatter!(x, y,
		title=title,
		marker=(3, :red, :hexagon, 0.5, Plots.stroke(0)),
		xaxis=(latexstring("t/n")),
		yaxis=(latexstring("|C|/n")))
	Plots.savefig(file)
end
