import 'package:farmbov/src/common/themes/theme_constants.dart';

import 'package:flutter/material.dart';

class NotificationMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NotificationMenu({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1C1917),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: const Color(0xFF1C1917),
            ),
            onDoubleTap: () => scaffoldKey.currentState?.closeEndDrawer(),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 64,
            color: AppColors.primaryGreen,
            child: SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    "Notificações",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16, color: const Color(0xFFB5C9B8)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            child: SafeArea(
              child: IconButton(
                onPressed: () => scaffoldKey.currentState?.closeEndDrawer(),
                iconSize: 32,
                icon: const Icon(Icons.close),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
