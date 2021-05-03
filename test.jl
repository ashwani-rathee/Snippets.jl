# 

"""


"""
function merge_sort(arr::AbstractArray{T,1}, l::T, r::T) where {T <: Real}
    if r > l 
        mid = Int(ceil(l + (r-l)/2))
        println(mid)
        merge_sort(arr, l, mid)
        merge_sort(arr, mid, r)
    end
    return "Hello"
end

# Arguments
arr = [5 ,3, 1, 4, 2]
n = size(arr)[1]
l = 0
r = n
# Function call
merge_sort(arr, l, r)