import 'package:farmbov/src/common/themes/theme_constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final bool invertedColors;
  final void Function()? onBackButtonPressed;
  // TODO: ver se é necessário ainda
  //final bool previousTab;

  const PageAppBar({
    super.key,
    required this.title,
    this.backButton = false,
    this.invertedColors = false,
    this.onBackButtonPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      backgroundColor:
          invertedColors ? Colors.transparent : AppColors.primaryGreen,
      surfaceTintColor: Colors.black12,
      elevation: 0,
      leading: backButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined,
                  color:
                      invertedColors ? AppColors.primaryGreen : Colors.white),
              onPressed: onBackButtonPressed ?? () => context.pop(),
              // onPressed: () => previousTab
              //     ? NavBarPage.of(context).previousTab()
              //     : context.pop(),
            )
          : null,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: invertedColors ? AppColors.primaryGreen : Colors.white),
      ),
      centerTitle: true,
    );
  }
}
