import 'package:flutter/material.dart';

class MyIndicator extends StatefulWidget {
  const MyIndicator({super.key});

  @override
  State<MyIndicator> createState() => _MyIndicatorState();
}

class _MyIndicatorState extends State<MyIndicator> {
  List<String> items = {
    'item 1',
    'item 2',
    'item 3',
    'item 4',
    'item 5',
  }.toList();

  double height = 100;
  int currentIndex = 0;

  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextItem() {
    if (currentIndex == items.length - 1) {
      pageController.jumpToPage(0);
    } else {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousItem() {
    if (currentIndex == 0) {
      pageController.jumpToPage(items.length - 1);
    } else {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.blue.shade50,
          child: Stack(
            children: [
              // Phần item
              PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: items.map((item) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

              // Nút Back ở giữa bên trái
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: previousItem,
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),

              // Nút Forward ở giữa bên phải
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: nextItem,
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
              ),

              // Indicator nằm ở footer của item
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: items.map((item) {
                    return currentIndex == items.indexOf(item)
                        ? buildIndicator(Colors.blue)
                        : buildIndicator(Colors.grey);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildIndicator(Color index) {
  return Container(
    margin: EdgeInsets.all(5),
    width: 15,
    height: 15,
    decoration: BoxDecoration(shape: BoxShape.circle, color: index),
  );
}
