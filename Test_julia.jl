#=
Test_julia:
- Julia version: 1.10.0
- Author: hp
- Date: 2024-03-20
=#
 ENV["PYTHON"] = "C:\\Users\\hp\\AppData\\Local\\Programs\\Python\\Python310\\python.exe"

# the problem size, n ∈ [11, 15, 20, 50, 100]
n = 11

# depot coordinates from Uniform[0, 1]
depot_x = rand()
depot_y = rand()

# customer coorindates from Uniform[0, 100]
customers_x = rand(n - 1) .* 100
customers_y = rand(n - 1) .* 100

# the first elements are for the depot
x_coordinates = [depot_x; customers_x]
y_coordinates = [depot_y; customers_y]

@assert n == length(x_coordinates) == length(y_coordinates)
include("D:/Nghien_Cuu_Khoa_Hoc/TSPDrone.jl-master/src/TSPDrone.jl")
using .TSPDrone
result = solve_tspd_RL(x_coordinates, y_coordinates; n_samples = 100)
print_summary(result)