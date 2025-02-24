import 'package:flutter/material.dart';
import '../../app/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? leadingWidgets;
  final bool hasMenu;
  final Color backgroundColor;

  const CustomAppBar({
    Key? key,
    this.title,
    this.leadingWidgets,
    this.hasMenu = true,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = 
        MediaQuery.of(context).orientation == Orientation.landscape &&
        MediaQuery.of(context).size.width >= 600;
    
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = isLandscape ? screenWidth * 0.1 : 16.0;

    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 8.0,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Leading widgets (left side)
              if (leadingWidgets != null)
                Row(
                  children: leadingWidgets!,
                ),
              
              // Menu button (right side)
              if (hasMenu)
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: AppTheme.kTextBrown),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}