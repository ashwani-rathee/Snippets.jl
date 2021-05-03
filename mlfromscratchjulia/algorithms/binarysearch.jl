### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 5ff056a8-ab09-11eb-3116-6d7354efe6ad
md"""
# Binary Search
Given a sorted array arr[] of n elements, write a function to search a given element x in arr[].
Time Complexity =  O(Log n)

We basically ignore half of the elements just after one comparison.
- Compare x with the middle element.
- If x matches with the middle element, we return the mid index.
- Else If x is greater than the mid element, then x can only lie in the right half subarray after the mid element. So we recur for the right half.
- Else (x is smaller) recur for the left half.

"""

# ╔═╡ c5f7efe2-ab09-11eb-1499-811bf6e2c44c
""" 
	Binary Search 
"""
function binary_search(arr::AbstractArray{T,1}, l::T, r::T, x::T) where T <: Real
	println("start")
	n = size(arr)[1]
	if(r>=l)
		mid = Int(ceil(l+(r-l)/2));
		println(mid)
		if(arr[mid] == x)
			return "Element present at index $mid"
		elseif(arr[mid] > x)
			binary_search(arr, l, mid-1, x)
		else
			binary_search(arr, mid+1, r, x)
		end
	else 
		return "Element not present in array"
	end
end

# ╔═╡ 6e04d41c-ab11-11eb-2619-2de271fb1c63
""" 
	Binary Search 
"""
function binary_search_itr(arr::AbstractArray{T,1}, l::T, r::T, x::T) where T <: Real
	println("start")
	n = size(arr)[1]
	if(r>=l)
		mid = Int(ceil(l+(r-l)/2));
		println(mid)
		if(arr[mid] == x)
			return "Element present at index $mid"
		elseif(arr[mid] > x)
			binary_search(arr, l, mid-1, x)
		else
			binary_search(arr, mid+1, r, x)
		end
	else 
		return "Element not present in array"
	end
end

# ╔═╡ 0f83c18a-ab0b-11eb-1640-97c7b4611f35
begin
	arr = [1, 2, 3, 4];
	x = 4;
	n = size(arr)[1];
	l = 1;
	r = n;
end

# ╔═╡ 1aeaa886-ab0b-11eb-17e7-294ceabbc007
binary_search(arr, l, r, x)

# ╔═╡ Cell order:
# ╠═5ff056a8-ab09-11eb-3116-6d7354efe6ad
# ╠═c5f7efe2-ab09-11eb-1499-811bf6e2c44c
# ╠═6e04d41c-ab11-11eb-2619-2de271fb1c63
# ╠═0f83c18a-ab0b-11eb-1640-97c7b4611f35
# ╠═1aeaa886-ab0b-11eb-17e7-294ceabbc007
