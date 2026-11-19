import 'package:dio/dio.dart';

import 'product.dart';

Future<void> layMotSanPham() async {
  final dio = Dio();
  final response = await dio.get('https://dummyjson.com/products/1');

  print(response.statusCode); // 200
  print(response.data['title']); // Essence Mascara Lash Princess
  print(response.data['price']); // 9.99
}

Future<product> layMotSanPham_ver2(int id) async {
  final dio = Dio();
  final response = await dio.get('https://dummyjson.com/products/$id');
  return product.fromJson(response.data);
}

Future<List<product>?> layDanhSachSanPham() async {
  try {
    final dio = Dio();
    // Link này không có số ở đuôi, nó sẽ trả về 30 sản phẩm
    final response = await dio.get('https://dummyjson.com/products');

    // API DummyJSON bọc mảng sản phẩm bên trong một key tên là 'products'
    List<dynamic> data = response.data['products'];

    // Chuyển đổi mảng JSON thành một danh sách (List) các object 'product'
    List<product> danhSach = data
        .map((json) => product.fromJson(json))
        .toList();

    return danhSach;
  } catch (e) {
    print('Lỗi khi lấy danh sách: $e');
    return null;
  }
}
