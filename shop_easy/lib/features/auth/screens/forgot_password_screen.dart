import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class QuenMatKhau extends StatefulWidget {
  const QuenMatKhau({super.key});

  @override
  State<QuenMatKhau> createState() => _QuenMatKhauState();
}

class _QuenMatKhauState extends State<QuenMatKhau> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _guiYeuCau() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Liên kết đặt lại mật khẩu đã được gửi đến email.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quên mật khẩu')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingL,
            vertical: AppSizes.paddingL,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: AppSizes.paddingL + AppSizes.paddingS,
                    backgroundColor: AppColors.primary,
                    child: const Icon(
                      Icons.lock_reset,
                      size: AppSizes.iconM,
                      color: AppColors.surface,
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                const Text(
                  'Đặt lại mật khẩu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: AppSizes.paddingS),

                const Text(
                  'Nhập email đã đăng ký để nhận liên kết đặt lại mật khẩu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),

                const SizedBox(height: AppSizes.paddingL),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Nhập email của bạn',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';

                    if (email.isEmpty) {
                      return 'Vui lòng nhập email';
                    }

                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(email)) {
                      return 'Email không đúng định dạng';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: AppSizes.paddingL),

                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _guiYeuCau,
                    child: const Text('Gửi liên kết đặt lại mật khẩu'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
