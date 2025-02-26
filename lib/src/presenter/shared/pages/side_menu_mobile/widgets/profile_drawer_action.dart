import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/shared/components/user_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:farmbov/src/presenter/shared/pages/side_menu_mobile/side_menu_mobile_store.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProfileDrawerAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? photoUrl;
  final String? attribute;
  final bool nextLineSubtitle;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function()? onPressed;

  const ProfileDrawerAction({
    super.key,
    required this.title,
    required this.subtitle,
    this.photoUrl,
    this.nextLineSubtitle = false,
    this.attribute,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final sideMenuMobileStore = SideMenuMobileStore();

    return Row(
      children: [
        Flexible(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            onTap: () => context.goNamedAuth(RouteName.account),
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            leading: ResponsiveBreakpoints.of(context).isMobile
                ? null
                : const UserCircleAvatar(),
            subtitle: Text(
              subtitle,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF9BB7A0),
                  ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.exit_to_app_outlined,
            color: Color(0xFF83A588),
          ),
          onPressed: () => sideMenuMobileStore.signOut(context),
        ),
      ],
    );
  }
}
