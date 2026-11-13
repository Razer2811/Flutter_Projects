import 'package:flutter/material.dart';

import 'dangky.dart';
import 'quenmatkhau.dart';
import 'profile.dart';

class DangNhap extends StatefulWidget {
  const DangNhap({super.key});

  @override
  State<DangNhap> createState() => _DangNhapState();
}

class _DangNhapState extends State<DangNhap> {
  bool _isPasswordVisible = false;

  final _emailController = TextEditingController();
  final _matKhauController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.lock_outline,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'My App',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  'Đăng nhập để tiếp tục trải nghiệm',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 36),

                // const Text(
                //   'Email',
                //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                // ),
                const SizedBox(height: 8),

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // const Text(
                //   'Mật khẩu',
                //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                // ),
                const SizedBox(height: 8),

                TextField(
                  controller: _matKhauController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DangKy(),
                          ),
                        );
                      },
                      child: const Text('Đăng ký'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuenMatKhau(),
                          ),
                        );
                      },
                      child: const Text('Quên mật khẩu?'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _dangNhap,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Đăng nhập'),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('hoặc', style: TextStyle(color: Colors.grey)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata, size: 28),
                      SizedBox(width: 8),
                      Text('Tiếp tục với Google'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _dangNhap() {
    final email = _emailController.text.trim();
    final matKhau = _matKhauController.text;

    if (email == 'test@gmail.com' && matKhau == '12345') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Profile()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email hoặc mật khẩu không chính xác!')),
      );
    }
  }
}
