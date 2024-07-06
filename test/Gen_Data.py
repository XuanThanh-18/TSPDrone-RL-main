import random

# Số lượng thành phố
num_cities = int(input("Nhập số lượng thành phố: "))

# Tạo tọa độ của kho
warehouse_coordinates = (random.uniform(0, 1), random.uniform(0, 1))

# Tạo tọa độ của các điểm giao hàng
delivery_coordinates = [(random.uniform(0, 100), random.uniform(0, 100)) for _ in range(num_cities-1)]

# Tạo và ghi dữ liệu vào file
with open("data.txt", "w") as file:
    # Ghi số lượng thành phố vào file
    file.write(str(num_cities) + "\n")

    # Ghi tọa độ của kho vào file
    file.write(str(warehouse_coordinates[0]) + "\n")
    file.write(str(warehouse_coordinates[1]) + "\n")

    # Ghi tọa độ của các điểm giao hàng vào file
    for coord in delivery_coordinates:
        file.write(str(coord[0]) + ", " )
        # Di chuyển đến vị trí cuối cùng của file
    file.seek(0, 2)
    # Di chuyển con trỏ lùi lại hai ký tự từ vị trí hiện tại
    file.seek(file.tell() - 2, 0)
    # Xóa hai ký tự cuối cùng
    file.truncate()
    file.write("\n")
    for coord in delivery_coordinates:
        file.write(str(coord[1]) + ", ")
    file.seek(0, 2)
    # Di chuyển con trỏ lùi lại hai ký tự từ vị trí hiện tại
    file.seek(file.tell() - 2, 0)
    # Xóa hai ký tự cuối cùng
    file.truncate()
print("Dữ liệu đã được lưu vào file 'data.txt'")
