# 

function missingnum(array::AbstractArray, n::Tuple{Int64})
    # println(array, n);
    total = ( n[1] + 1) * ( n[1] + 2) / 2; # 
    for i in 1:n[1]
        total = total - array[i];
    end
    return total;
end

arr = [8, 7, 6, 5, 4, 3, 1] # 2 is missing
n = size(arr) # returns dimension wise size tuple  

missingnum(arr, n) # main function