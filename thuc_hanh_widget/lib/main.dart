import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Sửa lỗi thiếu ColorScheme ở đây
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Bọc phần Column trong Container theo đúng yêu cầu bài TH 8[cite: 7]
        child: Container(
          padding: const EdgeInsets.all(20), //[cite: 7]
          margin: const EdgeInsets.symmetric(horizontal: 24), //[cite: 7]
          decoration: BoxDecoration(
            //[cite: 7]
            color: Colors.white, //[cite: 7]
            borderRadius: BorderRadius.circular(16), //[cite: 7]
            border: Border.all(color: Colors.grey.shade300), //[cite: 7]
            boxShadow: const [
              //[cite: 7]
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Row(
                children: [
                  Icon(Icons.person_outline, size: 20),
                  SizedBox(width: 12),
                  Text('Trần Lê Minh Khánh'),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.school_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Lớp KTPM K47'),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('tranleminhkhanh5734@husc.edu.vn'),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
