# 
function venus_symbol()
    n=5
    for i in 1:n
        for j in 1:n
            if( i ^ 2 + j ^ 2 == n ^ 2 ./ 4)
                println("x")
            end
        end
        println("\n")
    end

end

venus_symbol()