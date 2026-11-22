// File: lib/demo.dart
import 'package:material_ui/material_ui.dart';

import 'test/api.dart';
import 'product.dart';

class ProductGridScreen extends StatefulWidget {
  const ProductGridScreen({super.key});

  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  // Đổi từ 1 biến thành một mảng (List) để lưu nhiều sản phẩm
  List<product>? _danhSach;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _taiDanhSach(); // Tự động tải dữ liệu khi mở app
  }

  Future<void> _taiDanhSach() async {
    List<product>? ketQua = await layDanhSachSanPham();

    setState(() {
      _danhSach = ketQua;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey.shade100, // Đổ màu nền xám nhạt cho nổi bật Card
      appBar: AppBar(
        title: const Text('Danh sách Sản Phẩm'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      // Xử lý các trạng thái hiển thị
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Đang tải
          : (_danhSach == null || _danhSach!.isEmpty)
          ? const Center(child: Text('Không có dữ liệu')) // Lỗi hoặc trống
          : GridView.builder(
              // Đã có dữ liệu -> Vẽ Lưới
              padding: const EdgeInsets.all(10),

              // --- CẤU HÌNH LƯỚI ---
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Chia làm 2 cột
                childAspectRatio:
                    0.7, // Tỉ lệ khung hình (chiều rộng / chiều cao của 1 ô)
                crossAxisSpacing: 10, // Khoảng cách giữa 2 cột dọc
                mainAxisSpacing: 10, // Khoảng cách giữa các hàng ngang
              ),
              itemCount: _danhSach!.length, // Tổng số ô cần vẽ
              // --- VẼ TỪNG Ô (ITEM) ---
              itemBuilder: (context, index) {
                final sp = _danhSach![index]; // Lấy sản phẩm thứ i ra

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Phần Ảnh (chiếm hết khoảng trống phía trên)
                      Expanded(
                        child: ClipRRect(
                          // Cắt bo tròn 2 góc trên của ảnh
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: Image.network(
                            sp.thumbnail,
                            width: double.infinity, // Rộng full ô
                            fit: BoxFit.cover, // Cắt cho vừa khung
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image, size: 50),
                          ),
                        ),
                      ),

                      // 2. Phần chữ thông tin phía dưới
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sp.title,
                              maxLines: 2, // Tối đa 2 dòng, dài quá thì thành 3 chấm ...
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '\$${sp.price}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
