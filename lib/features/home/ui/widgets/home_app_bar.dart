import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/localization/language_provider.dart';
import '../../../product/ui/widgets/export_allthings.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: AppColors.textDark),
        onPressed: () {},
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.promoBannerGradient,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            context.l10n.brandName,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        const LanguageDropdown(),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => context.go('/profile'),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                Icons.person_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.language_rounded, color: AppColors.textDark, size: 24),
      initialValue: locale.languageCode,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        ref.read(languageProvider.notifier).changeLanguage(value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'en',
          child: Text('English', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        const PopupMenuItem(
          value: 'ar',
          child: Text('العربية', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
