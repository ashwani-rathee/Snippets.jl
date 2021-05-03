### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 0a5732a4-abb6-11eb-2576-d794f4298250
md"""
# Exponential Search
It works in O(Log n) time

Exponential search involves two steps:  
- Find range where element is present
- Do Binary Search in above found range.

### Time Complexity : 
O(Log n) 

### Auxiliary Space :
The above implementation of Binary Search is recursive and requires O(Log n) space. With iterative Binary Search, we need only O(1) space.
Applications of Exponential Search: 

Exponential Binary Search is particularly useful for unbounded searches, where size of array is infinite. Please refer Unbounded Binary Search for an example.
It works better than Binary Search for bounded arrays, and also when the element to be searched is closer to the first element.
"""

# ╔═╡ e75a2ade-abbc-11eb-0731-1d50cc24e806
begin
""" 
	Binary Search 
"""
function binary_search(arr::AbstractArray{T,1}, l::T, r::T, x::T) where T <: Real
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
end

# ╔═╡ 53d72c9e-abb7-11eb-0719-7933cb32bee2
begin
"""
	 exponential_search(arr::AbstractArray{T,1}, x::T) where {T <: Real}
	
Exponential Search in 1-D array
Time Complexity:  O(Log n)

"""
function exponential_search(arr::AbstractArray{T,1}, x::T) where {T <: Real}
	n = size(arr)[1]
	if(arr[1] == x)
		return "Elemenet present at index 1"
	end
	
	i = 1
	while( i<n && arr[i]<=x)
		i = i * 2
	end
	return binary_search( arr, Int(ceil(i / 2)),
                         min(i, n), x)
     
end

end

# ╔═╡ 55bd7c34-abb7-11eb-2b7c-e33b79fe0fb4
begin
# Arguments
arr = [1, 2, 3, 4, 13, 15, 20];
x = 4;
n = size(arr)[1]
l = 1;
r = n;
end

# ╔═╡ 5648bca4-abb7-11eb-2169-896e26d9a19e
# Function call
exponential_search(arr, x)

# ╔═╡ Cell order:
# ╠═0a5732a4-abb6-11eb-2576-d794f4298250
# ╠═e75a2ade-abbc-11eb-0731-1d50cc24e806
# ╠═53d72c9e-abb7-11eb-0719-7933cb32bee2
# ╠═55bd7c34-abb7-11eb-2b7c-e33b79fe0fb4
# ╠═5648bca4-abb7-11eb-2169-896e26d9a19e
