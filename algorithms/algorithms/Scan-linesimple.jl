### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 62405c38-8dfb-11eb-0dfe-b7545eb40047
using ImageDraw, ColorTypes,PlutoUI,ImageMorphology,ImageCore,ImageBinarization,ColorVectorSpace

# ╔═╡ 0a8bbcd6-8df2-11eb-1010-9fa5c200e91b
 begin
	vert=CartesianIndex{2}[]
	push!(vert, CartesianIndex(2,2))
	push!(vert, CartesianIndex(3,2))
    push!(vert, CartesianIndex(4,2))
    push!(vert, CartesianIndex(5,2))
    push!(vert, CartesianIndex(6,2))
	push!(vert, CartesianIndex(7,2))
	push!(vert, CartesianIndex(7,3))
	push!(vert, CartesianIndex(7,4))
	push!(vert, CartesianIndex(7,5))
	push!(vert, CartesianIndex(7,6))
	push!(vert, CartesianIndex(7,7))
	push!(vert, CartesianIndex(7,8))
	push!(vert, CartesianIndex(6,8))
	push!(vert, CartesianIndex(5,8))
	push!(vert, CartesianIndex(4,8))
	push!(vert, CartesianIndex(3,8))
	push!(vert, CartesianIndex(2,8)) 
	push!(vert, CartesianIndex(4,6))
	push!(vert, CartesianIndex(5,5))
	push!(vert, CartesianIndex(4,4))
    push!(vert, CartesianIndex(3,3)) 
	push!(vert, CartesianIndex(2,2))
end

# ╔═╡ af24b01e-8e0a-11eb-2863-2f4f0b02378c
# img = zeros(Bool,8,8)

# ╔═╡ 87876f46-8e0b-11eb-25d2-5fae6c3bf8ba
# begin
# img[2,2] = 1
# img[7,7] = 1blob:http://localhost:1234/8589b890-6624-4ce7-a02f-5ba6887173c0
# img[2,7] = 1
# img[7,2] = 1
# end

# ╔═╡ def9be12-8e0b-11eb-14dd-d1aaa9e97680
# img

# ╔═╡ e71ce920-8e0b-11eb-29c5-9b0d25d6fb96
# chull = convexhull(img)

# ╔═╡ 76b68af4-8dfb-11eb-11df-3f5ecff30aef
img = draw(zeros(Gray{Bool},8,9), Polygon(vert));

# ╔═╡ fc3e886a-8dfc-11eb-28e2-a56245654c9a
#find ymin and ymax
function yminmax(vert)
	ymax = vert[1][1];
	ymin = vert[1][1];
	for i in 1:length(vert)
	   if(vert[i][2] > ymax)
		 ymax = vert[i][2]
	   elseif(vert[i][2] < ymin)
		 ymax = vert[i][2]
	   end
	end
	return ymin, ymax
end

# ╔═╡ bf9b194e-8e03-11eb-25b1-1b1ec032d091
struct edgetabletuple
	initial::CartesianIndex
	final::CartesianIndex
end

# ╔═╡ e728998c-8e03-11eb-383c-63adbbb0a9a7
begin
function createedgetable()
edgetable= []
push!(edgetable, edgetabletuple(CartesianIndex(2,2),CartesianIndex(7,2)))
push!(edgetable, edgetabletuple(CartesianIndex(7,2),CartesianIndex(7,8)))
push!(edgetable, edgetabletuple(CartesianIndex(7,8),CartesianIndex(2,8)))
push!(edgetable, edgetabletuple(CartesianIndex(2,8),CartesianIndex(5,5)))
push!(edgetable, edgetabletuple(CartesianIndex(5,5),CartesianIndex(2,2)))
return edgetable
end
end

# ╔═╡ de65743e-8e06-11eb-01b2-d95b8522d54c
begin
function findintersections(edgetable, yvalue)
	points =[]
    for i in 1:length(edgetable)
		if(edgetable[i].final[2] > yvalue && edgetable[i].initial[2] > yvalue)
			continue 
		end
		if(edgetable[i].final[2] <= yvalue && edgetable[i].initial[2] <= yvalue)
			continue 
		end
		x=1
		deltay = edgetable[i].final[1]-edgetable[i].initial[1]
		deltax = edgetable[i].final[2]-edgetable[i].initial[2]
		alpha = deltay/deltax
		constant = edgetable[i].initial[1]
		x = alpha*(yvalue - edgetable[i].initial[2]) + constant
		# println(x)
		if (x == -Inf || isnan(x) || x == Inf) continue end
		push!(points,CartesianIndex(ceil(Int,x),yvalue))
	end
	return points
end
end

# ╔═╡ f044ef28-8e14-11eb-086f-9d17d7d0d783
function timetocolor(points, fill_color::T)where T<:Colorant
   # points = [CartesianIndex(p[2], p[1]) for p in points]
   for i in 1:2:length(points)-1
	  draw!(img, LineSegment(points[i], points[i+1]),fill_color)
   end
end

# ╔═╡ 0c0ff75e-8dff-11eb-255b-c12540f37c4a
function scanline(vert, fill_color::T, boundary_color::T) where T<:Colorant
	ymin, ymax = yminmax(vert)
	edgetable = createedgetable()
	# println(edgetable)
	# println(vert)
	# println("Boundary Color : ", boundary_color)
	# println("Fill Color : ", fill_color)
	# println("Y Minimum : ", ymin)
	# println("Y Maximum : ", ymax)
	# println("EdgeTable : ", edgetable)
	pyramid = []
	for i in ymin:ymax
		y = i
		points = findintersections(edgetable, y)
		points = sort!(points, by = x -> x[1])
		println(points)
		println(unique(points))
		timetocolor(points, fill_color)
		push!(pyramid,img[:,:])
	end
	pyramid
end

# ╔═╡ 3d28390c-8e13-11eb-33fb-ed995ed827f9
length(vert)

# ╔═╡ d0b6a552-8e17-11eb-1bb6-a5f1ae6022d8
typeof(img[1,1])

# ╔═╡ 18edf7fa-8e13-11eb-1310-652ccc794329
yminmax(vert)

# ╔═╡ 7f369560-8e01-11eb-214b-83d8210ca559
with_terminal() do 
# begin
	boundary_color = Gray{Bool}(1.0)
	fill_color = Gray{Bool}(1.0)
    pyramid = scanline(vert, fill_color, boundary_color)
	pyramid
end

# ╔═╡ 39846fb2-8e1d-11eb-2696-e38fbd4a1a88


# ╔═╡ Cell order:
# ╠═62405c38-8dfb-11eb-0dfe-b7545eb40047
# ╠═0a8bbcd6-8df2-11eb-1010-9fa5c200e91b
# ╠═af24b01e-8e0a-11eb-2863-2f4f0b02378c
# ╠═87876f46-8e0b-11eb-25d2-5fae6c3bf8ba
# ╠═def9be12-8e0b-11eb-14dd-d1aaa9e97680
# ╠═e71ce920-8e0b-11eb-29c5-9b0d25d6fb96
# ╠═76b68af4-8dfb-11eb-11df-3f5ecff30aef
# ╠═fc3e886a-8dfc-11eb-28e2-a56245654c9a
# ╠═bf9b194e-8e03-11eb-25b1-1b1ec032d091
# ╠═e728998c-8e03-11eb-383c-63adbbb0a9a7
# ╠═de65743e-8e06-11eb-01b2-d95b8522d54c
# ╠═f044ef28-8e14-11eb-086f-9d17d7d0d783
# ╠═0c0ff75e-8dff-11eb-255b-c12540f37c4a
# ╠═3d28390c-8e13-11eb-33fb-ed995ed827f9
# ╠═d0b6a552-8e17-11eb-1bb6-a5f1ae6022d8
# ╠═18edf7fa-8e13-11eb-1310-652ccc794329
# ╠═7f369560-8e01-11eb-214b-83d8210ca559
# ╠═39846fb2-8e1d-11eb-2696-e38fbd4a1a88
