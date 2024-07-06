#=
Test_Input:
- Julia version: 1.10.0
- Author: hp
- Date: 2024-03-27
=#
# Đọc dữ liệu từ file data.txt
using PyCall

 include("D:/Nghien_Cuu_Khoa_Hoc/TSPDrone.jl-master/src/TSPDrone.jl")
 using .TSPDrone
# Open the file and read data
file_path = "D:/Nghien_Cuu_Khoa_Hoc/TSPDrone.jl-master/test/data.txt"
file = open(file_path)

# Initialize variables to store data
n = parse(Int, readline(file))  # Đọc giá trị của n
depot_x = parse(Float64, readline(file))  # Đọc tọa độ x của depot
depot_y = parse(Float64, readline(file))  # Đọc tọa độ y của depot

# Đọc tọa độ của các khách hàng
customers_x_str = readline(file)
customers_y_str = readline(file)

# Chuyển đổi chuỗi tọa độ của khách hàng thành mảng số thực
customers_x = parse.(Float64, split(customers_x_str, ","))
customers_y = parse.(Float64, split(customers_y_str, ","))

# Đóng file
close(file)

#Xây dựng mảng tọa độ x và y
x_coordinates = [depot_x; customers_x]
y_coordinates = [depot_y; customers_y]


# Giải bài toán TSPDrone
result = solve_tspd_RL(x_coordinates, y_coordinates; n_samples = 100)

# In kết quả tổng hợp
print_summary(result)

# Hàm vẽ tuyến đường
function draw_routes(result::TSPDroneResult, x::Vector{Float64}, y::Vector{Float64})
    # Nhập module matplotlib
    matplotlib = pyimport("matplotlib")
    pyplot = pyimport("matplotlib.pyplot")

    # Biểu diễn dữ liệu dưới dạng đồ thị
    pyplot.scatter(x, y, label="Customers", color="black")
    pyplot.scatter(x[1], y[1], label="Depot", color="red")

    # Vẽ tuyến đường của xe tải
    for i in 1:length(result.truck_route) - 1
        x_truck = [x[result.truck_route[i]], x[result.truck_route[i+1]]]
        y_truck = [y[result.truck_route[i]], y[result.truck_route[i+1]]]
        pyplot.plot(x_truck, y_truck, color="blue")  # Màu xanh cho tuyến đường xe tải
    end

    # Vẽ tuyến đường của drone
    for i in 1:length(result.drone_route) - 1
        x_drone = [x[result.drone_route[i]], x[result.drone_route[i+1]]]
        y_drone = [y[result.drone_route[i]], y[result.drone_route[i+1]]]
        pyplot.plot(x_drone, y_drone, color="green",linestyle="--")  # Màu xanh lá cây cho tuyến đường drone
    end
    # Thêm nhãn cho mỗi điểm
     for i in 1:length(x)
        # Điều chỉnh kích thước và vị trí của nhãn
        pyplot.text(x[i], y[i], string(i), fontsize=10, ha="right", va="bottom")
    end
    # Hiển thị biểu đồ
    pyplot.xlabel("X Coordinates")
    pyplot.ylabel("Y Coordinates")
    pyplot.title("Truck and Drone Routes")
    pyplot.legend()
    pyplot.show()
end
# ve
draw_routes(result, x_coordinates, y_coordinates)

