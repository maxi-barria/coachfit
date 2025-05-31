import 'package:flutter/material.dart';
import '../themes/themes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showText = screenWidth > 460; // 👈 si es mayor a 360px, muestra "Atrás"

    return AppBar(
      backgroundColor: MyTheme.secondary,
      elevation: 0,
      leading: showBack
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_ios, size: 18, color: MyTheme.primary),
                  if (showText) ...[
                    const SizedBox(width: 2),
                    const Text(
                      'Atrás',
                      style: TextStyle(
                        fontSize: 16,
                        color: MyTheme.primary,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
