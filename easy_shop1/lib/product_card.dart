import 'package:flutter/material.dart';

import 'product.dart';
import 'format.dart';

/// Card sản phẩm: ảnh, tên, mô tả, giá (tái dùng từ bài GD 5).
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAdd;

  const ProductCard({super.key, required this.product, this.onAdd});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh sản phẩm
            SizedBox(
              height: 140,
              width: double.infinity,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const Center(child: CircularProgressIndicator()),
                errorBuilder: (context, error, stack) => Container(
                  color: scheme.surfaceContainerHighest,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 40,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Mô tả
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    // Giá + nút thêm vào giỏ
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatPrice(product.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onAdd,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 18,
                              color: scheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
