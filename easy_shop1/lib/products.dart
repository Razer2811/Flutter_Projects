import 'product.dart';

const List<String> kCategories = ['Tất cả', 'Điện thoại', 'Laptop', 'Phụ kiện'];

const List<Product> kProducts = [
  Product(
    name: 'iPhone 15',
    description: 'Màn hình 6.1 inch, chip A16 Bionic, camera 48MP',
    price: 21990000,
    category: 'Điện thoại',
    image: 'https://picsum.photos/seed/iphone/400/400',
  ),
  Product(
    name: 'Samsung Galaxy S24',
    description: 'Màn hình AMOLED 120Hz, tích hợp Galaxy AI',
    price: 19990000,
    category: 'Điện thoại',
    image: 'https://picsum.photos/seed/galaxy/400/400',
  ),
  Product(
    name: 'MacBook Air M2',
    description: 'Mỏng nhẹ, pin 18 giờ, màn hình Liquid Retina',
    price: 26990000,
    category: 'Laptop',
    image: 'https://picsum.photos/seed/macbook/400/400',
  ),
  Product(
    name: 'Dell XPS 13',
    description: 'Viền màn hình siêu mỏng, Core i7, RAM 16GB',
    price: 32990000,
    category: 'Laptop',
    image: 'https://picsum.photos/seed/dell/400/400',
  ),
  Product(
    name: 'Tai nghe AirPods Pro',
    description: 'Chống ồn chủ động, sạc không dây MagSafe',
    price: 5490000,
    category: 'Phụ kiện',
    image: 'https://picsum.photos/seed/airpods/400/400',
  ),
  Product(
    name: 'Sạc nhanh 65W',
    description: 'Cổng USB-C, sạc được laptop và điện thoại',
    price: 590000,
    category: 'Phụ kiện',
    image: 'https://picsum.photos/seed/charger/400/400',
  ),
  Product(
    name: 'Chuột Logitech MX',
    description: 'Chuột không dây ergonomic, pin 70 ngày',
    price: 1890000,
    category: 'Phụ kiện',
    image: 'https://picsum.photos/seed/mouse/400/400',
  ),
  Product(
    name: 'Xiaomi 14T',
    description: 'Camera Leica, sạc nhanh 67W, màn hình 144Hz',
    price: 12990000,
    category: 'Điện thoại',
    image: 'https://picsum.photos/seed/xiaomi/400/400',
  ),
];
