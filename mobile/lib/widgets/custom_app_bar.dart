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
    final showText = screenWidth > 460;

    return AppBar(
      backgroundColor: MyTheme.secondary,
      elevation: 0,
      leading: showBack
          ? SafeArea(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back_ios, size: 18, color: MyTheme.primary),
                      if (showText)
                        const Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Text(
                            'Atrás',
                            style: TextStyle(
                              fontSize: 16,
                              color: MyTheme.primary,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(16), // altura del espacio
        child: SizedBox(height: 16), // espacio visible
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
