import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../product/models/product.dart';
import 'widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';
  int _selectedNavigationIndex = 0;

  final List<String> _categories = [
    'Tất cả',
    'Điện thoại',
    'Laptop',
    'Phụ kiện',
  ];

  // Dữ liệu sản phẩm mẫu
  final List<Product> _products = const [
    Product(
      name: 'iPhone 15',
      description: 'Điện thoại Apple, màn hình Super Retina',
      category: 'Điện thoại',
      imageUrl:
          'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=600',
      price: 21.990,
    ),
    Product(
      name: 'Samsung Galaxy',
      description: 'Điện thoại Samsung, thiết kế hiện đại',
      category: 'Điện thoại',
      imageUrl:
          'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=600',
      price: 18.990,
    ),
    Product(
      name: 'MacBook Air',
      description: 'Laptop Apple mỏng nhẹ, hiệu năng cao',
      category: 'Laptop',
      imageUrl:
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600',
      price: 27.990,
    ),
    Product(
      name: 'Laptop ASUS',
      description: 'Laptop học tập và làm việc',
      category: 'Laptop',
      imageUrl:
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=600',
      price: 19.990,
    ),
    Product(
      name: 'Tai nghe Bluetooth',
      description: 'Tai nghe không dây, âm thanh rõ nét',
      category: 'Phụ kiện',
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
      price: 1.990,
    ),
    Product(
      name: 'Đồng hồ thông minh',
      description: 'Theo dõi hoạt động và sức khỏe',
      category: 'Phụ kiện',
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
      price: 3.490,
    ),
  ];

  // Lọc sản phẩm theo từ khóa và danh mục
  List<Product> get _filteredProducts {
    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'Tất cả' ||
          product.category == _selectedCategory;

      final query = _searchQuery.toLowerCase().trim();

      final matchesSearch =
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryList(),
            Expanded(child: _buildProductGrid()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF10417F),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const Text(
            'ShopEasy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          // Nút tìm kiếm
          IconButton(
            onPressed: () {
              _searchFocusNode.requestFocus();
            },
            icon: const Icon(Icons.search, color: Colors.white, size: 26),
          ),

          // Giỏ hàng có huy hiệu số lượng
          IconButton(
            onPressed: () {},
            icon: Badge(
              label: const Text('2'),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SEARCH BAR
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Tìm sản phẩm...',
          hintStyle: const TextStyle(color: Color(0xFF94A8C0)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF94A8C0)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.close),
                )
              : null,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // CATEGORY CHIPS
  Widget _buildCategoryList() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedCategory = category;
              });
            },
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.divider,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  // PRODUCT GRID
  Widget _buildProductGrid() {
    final products = _filteredProducts;

    if (products.isEmpty) {
      return const Center(
        child: Text(
          'Không tìm thấy sản phẩm',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }

  // BOTTOM NAVIGATION
  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedNavigationIndex,
      onTap: (index) {
        setState(() {
          _selectedNavigationIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: const Color(0xFFB8C7DA),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Yêu thích',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
