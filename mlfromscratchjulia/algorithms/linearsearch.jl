### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 991bfc60-ab05-11eb-0c86-8b5db8a99b7c
md"""
# Linear Search
Problem: Given an array arr[] of n elements, write a function to search a given element x in arr[].

A simple approach is to do a linear search, i.e  
- Start from the leftmost element of arr[] and one by one compare x with each element of arr[]
- If x matches with an element, return the index.
- If x doesn’t match with any of elements, return -1.
"""

# ╔═╡ 03a80a06-ab06-11eb-0e8e-0d25cbf9a16f
"""
	Linear Search in 1-D array
"""
function linear_search(arr:: AbstractArray{T,1}, x:: T) where { T <: Real}
	n = size(arr)[1]
	for i in 1:n
		if (arr[i] == x)
			return "Element present at index $i"
		end
	end
	return "Element not present in array"
end

# ╔═╡ ea26a5bc-ab08-11eb-0510-af66a1a50944
begin
	arr = [1.0, 2.0, 3.0, 4.0];
	x = 3.0;
end

# ╔═╡ b69a5382-ab06-11eb-20f3-8d8009b96ba7
linear_search(arr, x)

# ╔═╡ 7853d8e2-ab15-11eb-1bf0-c58c5dfbcdea


# ╔═╡ Cell order:
# ╠═991bfc60-ab05-11eb-0c86-8b5db8a99b7c
# ╠═03a80a06-ab06-11eb-0e8e-0d25cbf9a16f
# ╠═ea26a5bc-ab08-11eb-0510-af66a1a50944
# ╠═b69a5382-ab06-11eb-20f3-8d8009b96ba7
# ╠═7853d8e2-ab15-11eb-1bf0-c58c5dfbcdea
