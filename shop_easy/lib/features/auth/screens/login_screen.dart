import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'profile_screen.dart';

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
  void dispose() {
    _emailController.dispose();
    _matKhauController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL,
              vertical: AppSizes.paddingL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.paddingL),

                CircleAvatar(
                  radius: AppSizes.paddingL + AppSizes.paddingS,
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.lock_outline,
                    size: AppSizes.iconM,
                    color: AppColors.surface,
                  ),
                ),

                const SizedBox(height: AppSizes.paddingM),

                const Text(
                  'ShopEasy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: AppSizes.paddingS),

                const Text(
                  'Đăng nhập để tiếp tục trải nghiệm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: AppSizes.paddingM),

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
                  ),
                ),

                const SizedBox(height: AppSizes.paddingS),

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

                const SizedBox(height: AppSizes.paddingM),

                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _dangNhap,
                    child: const Text('Đăng nhập'),
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                      ),
                      child: Text(
                        'hoặc',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: AppSizes.paddingL),

                SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.g_mobiledata, size: AppSizes.iconM),
                        SizedBox(width: AppSizes.paddingS),
                        Text('Tiếp tục với Google'),
                      ],
                    ),
                  ),
                ),
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
