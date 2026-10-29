import 'dart:async';

import 'package:flutter/material.dart';

// PHƯƠNG ÁN 2: ListView.builder với scrollDirection: Axis.horizontal
// Tự chạy bằng Timer + ScrollController.

final List<String> _images = List.generate(
  6,
  (i) => 'https://picsum.photos/seed/slide${i + 1}/800/500',
);

class MySlider2 extends StatefulWidget {
  const MySlider2({super.key});

  @override
  State<MySlider2> createState() => _MySlider2State();
}

class _MySlider2State extends State<MySlider2> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;
  int _current = 0;
  double _itemWidth = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _autoScroll());
  }

  void _autoScroll() {
    if (!_controller.hasClients || _itemWidth == 0) return;

    _current = (_current + 1) % _images.length;

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
    _timer?.cancel();
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
          child: ListView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal, // "axis" trong ghi chú trên bảng
            itemCount: _images.length,
            itemExtent: _itemWidth, // mỗi item rộng cố định => cuộn chính xác
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: _SlideCard(url: _images[i], index: i + 1),
              );
            },
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
