import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserCircleAvatar extends StatelessWidget {
  final void Function()? onPressed;
  final bool small;

  const UserCircleAvatar({
    super.key,
    this.onPressed,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl = AppManager.instance.currentUser.userDetails?.photoUrl;

    return photoUrl?.isEmpty ?? true
        ? CircleAvatar(
            backgroundColor: const Color(0xffE6E6E6),
            child: Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                splashColor: Theme.of(context).primaryColor,
                onTap: () {},
                child: IconButton(
                  onPressed: onPressed ?? () => context.go(RouteName.account),
                  icon: const Icon(Icons.person),
                  color: const Color(0xffCCCCCC),
                ),
              ),
            ),
          )
        : Hero(
            tag: photoUrl!,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: small ? 20 : 30,
              backgroundImage: CachedNetworkImageProvider(photoUrl),
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Theme.of(context).primaryColor,
                  onTap: onPressed ?? () => context.go(RouteName.account),
                ),
              ),
            ),
          );
  }
}
