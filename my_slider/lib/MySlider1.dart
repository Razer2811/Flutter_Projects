import 'dart:async';

import 'package:flutter/material.dart';

// PHƯƠNG ÁN 1: SingleChildScrollView -> Row -> Container -> Image
// Cuộn ngang bằng ScrollController, tự chạy bằng Timer.

final List<String> _images = List.generate(
  6,
  (i) => 'https://picsum.photos/seed/slide${i + 1}/800/500',
);

class MySlider1 extends StatefulWidget {
  const MySlider1({super.key});

  @override
  State<MySlider1> createState() => _MySlider1State();
}

class _MySlider1State extends State<MySlider1> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;
  int _current = 0;
  double _itemWidth = 0; // chiều rộng của 1 slide (tính trong build)

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _autoScroll());
  }

  void _autoScroll() {
    if (!_controller.hasClients || _itemWidth == 0) return;

    _current = (_current + 1) % _images.length; // hết ảnh thì quay về đầu

    final target = (_current * _itemWidth).clamp(
      0.0,
      _controller.position.maxScrollExtent,
    );

    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // nhớ hủy Timer để tránh rò rỉ bộ nhớ
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _itemWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complicated image slider demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SizedBox(
          height: 260,
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < _images.length; i++)
                  Container(
                    width: _itemWidth,
                    padding: const EdgeInsets.all(8),
                    child: _SlideCard(url: _images[i], index: i + 1),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SlideCard extends StatelessWidget {
  final String url;
  final int index;

  const _SlideCard({required this.url, required this.index});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Center(child: Icon(Icons.broken_image, size: 48)),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(12),
              child: Text(
                'No. $index image',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
