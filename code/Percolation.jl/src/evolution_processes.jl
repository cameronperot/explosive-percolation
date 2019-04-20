function erdos_renyi(g::Network, τ::Int)
	for t in 1:τ
		add_edge(g, choose_edge(g))
	end
	return g
end

function bohman_frieze(g::Network, τ::Int)
end

function product_rule(g::Network, τ::Int)
end
