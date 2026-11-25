import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _dangTheoDoi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ cá nhân'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 170,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1000',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -45,
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.paddingS),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: AppSizes.paddingL * 2,
                        backgroundColor: AppColors.background,
                        child: Icon(
                          Icons.person,
                          size: AppSizes.iconM + AppSizes.paddingL * 2,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.paddingL * 2 + AppSizes.paddingS),

              const Text(
                'Trần Lê Minh Khánh',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: AppSizes.paddingS),

              const Text(
                'Sinh viên Kỹ thuật Phần mềm',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),

              const SizedBox(height: AppSizes.paddingL),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildThongKe('12', 'Bài viết')),
                    const SizedBox(
                      height: 48,
                      child: VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: AppColors.border,
                      ),
                    ),
                    Expanded(child: _buildThongKe('350', 'Người theo dõi')),
                    const SizedBox(
                      height: 48,
                      child: VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: AppColors.border,
                      ),
                    ),
                    Expanded(child: _buildThongKe('180', 'Đang theo dõi')),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingL,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _dangTheoDoi = !_dangTheoDoi;
                            });
                          },
                          child: Text(
                            _dangTheoDoi ? 'Đang theo dõi' : 'Theo dõi',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 46,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Chức năng nhắn tin đang được phát triển',
                                ),
                              ),
                            );
                          },
                          child: const Text('Nhắn tin'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              const Divider(height: 1, color: AppColors.border),

              const SizedBox(height: AppSizes.paddingS),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThongKe(String soLuong, String tieuDe) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          soLuong,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSizes.paddingS),
        Text(
          tieuDe,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
