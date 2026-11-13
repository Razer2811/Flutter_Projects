import 'package:flutter/material.dart';

class DangKy extends StatefulWidget {
  const DangKy({super.key});

  @override
  State<DangKy> createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  final _formKey = GlobalKey<FormState>();

  final _hoTenController = TextEditingController();
  final _emailController = TextEditingController();
  final _matKhauController = TextEditingController();
  final _nhapLaiMatKhauController = TextEditingController();

  bool _dongYDieuKhoan = false;
  bool _hienMatKhau = false;
  bool _hienNhapLaiMatKhau = false;

  @override
  void dispose() {
    _hoTenController.dispose();
    _emailController.dispose();
    _matKhauController.dispose();
    _nhapLaiMatKhauController.dispose();
    super.dispose();
  }

  void _dangKy() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_dongYDieuKhoan) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Thông tin đăng ký hợp lệ!')));
  }

  @override
  Widget build(BuildContext context) {
    final mauChuDao = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo tài khoản'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 28),

                const Text(
                  'Họ và tên',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _hoTenController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Nhập họ và tên',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }

                    if (value.trim().length < 2) {
                      return 'Họ và tên phải có ít nhất 2 ký tự';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Nhập email của bạn',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập email';
                    }

                    final email = value.trim();
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                    if (!emailRegex.hasMatch(email)) {
                      return 'Email không đúng định dạng';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Mật khẩu',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _matKhauController,
                  obscureText: !_hienMatKhau,
                  decoration: InputDecoration(
                    hintText: 'Nhập mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _hienMatKhau = !_hienMatKhau;
                        });
                      },
                      icon: Icon(
                        _hienMatKhau ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }

                    if (value.length < 8) {
                      return 'Mật khẩu phải có ít nhất 8 ký tự';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Nhập lại mật khẩu',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _nhapLaiMatKhauController,
                  obscureText: !_hienNhapLaiMatKhau,
                  decoration: InputDecoration(
                    hintText: 'Nhập lại mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _hienNhapLaiMatKhau = !_hienNhapLaiMatKhau;
                        });
                      },
                      icon: Icon(
                        _hienNhapLaiMatKhau
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu';
                    }

                    if (value != _matKhauController.text) {
                      return 'Mật khẩu nhập lại không trùng khớp';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _dongYDieuKhoan,
                      onChanged: (value) {
                        setState(() {
                          _dongYDieuKhoan = value ?? false;
                        });
                      },
                      activeColor: mauChuDao,
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'Tôi đồng ý với điều khoản sử dụng và chính sách bảo mật.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: _dongYDieuKhoan ? _dangKy : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Đăng ký'),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Đã có tài khoản? ',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Đăng nhập'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
