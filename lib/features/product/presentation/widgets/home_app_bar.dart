import 'package:flutter/material.dart';
import 'export_allthings.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: HomeColors.white,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: HomeColors.textDark),
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
              gradient: HomeColors.promoBannerGradient,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: HomeColors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Stylish',
            style: TextStyle(
              color: HomeColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: HomeColors.primaryLight,
              child: Icon(
                Icons.person_rounded,
                color: HomeColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
