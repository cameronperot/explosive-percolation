function χ²(y, y_fit, σ)
	return sum(((y .- y_fit) ./ σ).^2)
end

function χ²_fit(x, y, σ)
	num = sum(y ./ σ.^2) * sum(x.^2 ./ σ.^2) - sum(x ./ σ.^2) * sum(y .* x ./ σ.^2)
	den = sum(1 ./ σ.^2) * sum(x.^2 ./ σ.^2) - sum(x ./ σ.^2)^2
	a = num / den

	num = sum(y .* x ./ σ.^2) * sum(1 ./ σ.^2) - sum(x ./ σ.^2) * sum(y ./ σ.^2)
	den = sum(1 ./ σ.^2) * sum(x.^2 ./ σ.^2) - sum(x ./ σ.^2)^2
	b = num / den

	y_fit = a .+ b .* x

	return Dict(
		"y_fit"  => y_fit,
		"a"      => a,
		"b"      => b,
		"χ²/dof" => χ²(y, y_fit, σ) / (length(x)-2)
	)
end
