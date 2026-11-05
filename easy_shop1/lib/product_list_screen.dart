import 'package:flutter/material.dart';

import 'products.dart';
import 'product.dart';
import 'product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  String _query = '';
  String _selectedCategory = 'Tất cả';
  int _cartCount = 0;
  int _navIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<Product> get _filtered {
    final q = _query.trim().toLowerCase();
    return kProducts.where((p) {
      final okCategory =
          _selectedCategory == 'Tất cả' || p.category == _selectedCategory;
      final okSearch = q.isEmpty || p.name.toLowerCase().contains(q);
      return okCategory && okSearch;
    }).toList();
  }

  void _addToCart(Product p) {
    setState(() => _cartCount++);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Đã thêm "${p.name}" vào giỏ'),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final products = _filtered;

    return Scaffold(
      // 1. Thanh tiêu đề: nút tìm kiếm + giỏ hàng có huy hiệu số lượng
      appBar: AppBar(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        title: const Text('Cửa hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Tìm kiếm',
            onPressed: () => _searchFocus.requestFocus(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Giỏ hàng',
              onPressed: () {},
              icon: Badge(
                isLabelVisible: _cartCount > 0,
                label: Text('$_cartCount'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 2. Ô tìm kiếm bo tròn, gõ tới đâu lọc tới đó
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Tìm sản phẩm...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 3. Hàng chip danh mục cuộn ngang, chip đang chọn đổi màu nền
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: kCategories.map((c) {
                final selected = c == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(c),
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: scheme.primary,
                    backgroundColor: scheme.surfaceContainerHighest,
                    labelStyle: TextStyle(
                      color: selected ? scheme.onPrimary : scheme.onSurface,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = c),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // 4. Lưới sản phẩm 2 cột dùng GridView.builder
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('Không tìm thấy sản phẩm'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          // Chiều cao cố định -> không bị tràn khi xoay ngang
                          mainAxisExtent: 290,
                        ),
                    itemBuilder: (context, index) {
                      final p = products[index];
                      return ProductCard(
                        product: p,
                        onAdd: () => _addToCart(p),
                      );
                    },
                  ),
          ),
        ],
      ),

      // 5. Thanh điều hướng dưới với 3 mục
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Yêu thích',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
