import 'dart:async';

import 'package:flutter/material.dart';

// PHƯƠNG ÁN 3 (dùng nhiều nhất): PageView
// PageController có viewportFraction < 1 để thấy ảnh trước/sau ló ra hai bên.

final List<String> _images = List.generate(
  6,
  (i) => 'https://picsum.photos/seed/slide${i + 1}/800/500',
);

class MySlider3 extends StatefulWidget {
  const MySlider3({super.key});

  @override
  State<MySlider3> createState() => _MySlider3State();
}

class _MySlider3State extends State<MySlider3> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_controller.hasClients) return;

      final next = (_current + 1) % _images.length; // hết ảnh thì về đầu

      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complicated image slider demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 260,
            child: PageView.builder(
              controller: _controller,
              itemCount: _images.length,
              onPageChanged: (i) {
                setState(() => _current = i);
                _startTimer(); // người dùng vuốt tay thì reset lại bộ đếm giờ
              },
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: _SlideCard(url: _images[i], index: i + 1),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Dấu chấm chỉ vị trí slide hiện tại
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_images.length, (i) {
              final active = i == _current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
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
