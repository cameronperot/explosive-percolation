function plot_order_parameter(g::AbstractGraph)
	x = collect(1:g.n_steps+1) ./ g.n
	y = g.C / g.n
	plot_out = plot(legend=false, dpi=300)
	scatter!(x, y,
		marker=(3, :red, :hexagon, 0.5, Plots.stroke(0)),
		xaxis=(L"t/n"),
		yaxis=(L"|C|/n"))
	return plot_out
end
