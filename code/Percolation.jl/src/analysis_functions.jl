function compute_Δ_achlioptas(g::AbstractGraph)
	"""
	Determines Δ, t₀, and t₁ for the given evolved `g`
	Arguments
		`g`   : An evolved instance of type AbstractGraph
	Return
		Three-tuple (Δ, t₀, t₁)
		`Δ` : t₁ - t₀
		`t₀`: The last step in the evolution process satisfying `g.C < sqrt(g.n)`
		`t₁`: The first step in the evolution process satisfying `g.C > 0.5g.n`
	"""

	t₀ = sum(g.C .< sqrt(g.n))
	t₁ = sum(g.C .<= 0.5g.n) + 1
	return (t₁-t₀, t₀, t₁)
	
end
