// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/helpers/strings_helpers.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/user_circle_avatar.dart';
import 'package:farmbov/src/presenter/shared/pages/side_menu_mobile/side_menu_mobile_model.dart';
import 'package:farmbov/src/presenter/shared/pages/side_menu_mobile/widgets/profile_drawer_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/presenter/shared/pages/side_menu_mobile/side_menu_mobile_store.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/common/router/route_name.dart';

class SideMenuMobile extends StatefulWidget {
  final SideMenuMobileStore store;
  final GlobalKey<ScaffoldState> drawerKey;

  const SideMenuMobile(
      {super.key, required this.store, required this.drawerKey});

  @override
  State<SideMenuMobile> createState() => _SideMenuMobileState();
}

class _SideMenuMobileState extends State<SideMenuMobile> {
  @override
  void initState() {
    super.initState();
    widget.store.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _userProfile();

  Widget _profileDrawerAction(
    String title,
    String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      title: Text(
        title,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
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
    );
  }

  Widget _customDivider({
    double height = 0,
  }) {
    return Divider(
      height: height,
      thickness: 1,
      color: const Color(0xFF83A588),
    );
  }

  Future<CroppedFile?> cropImage(String finalPath) async {
    return await ImageCropper().cropImage(
      sourcePath: finalPath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Ajustar foto',
            toolbarColor: AppColors.feedbackDanger,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Ajustar foto',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
  }

  Widget _userProfile() {
    final sideMenuMobileStore = SideMenuMobileStore();
    return TripleBuilder(
      store: widget.store,
      builder: (context, Triple<SideMenuMobileModel> model) => Drawer(
        backgroundColor: const Color(0xFF1C1917).withOpacity(0.6),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: const Color(0xFF1C1917).withOpacity(0.6),
              ),
              onTap: () => widget.drawerKey.currentState?.closeDrawer(),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 64,
              color: AppColors.primaryGreen,
              child: SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        'assets/images/logos/logo_white.svg',
                        semanticsLabel: 'Farmbov logo',
                        height: 28,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (model.error != null) ...[
                      const Center(
                        child: Text('Falha ao buscar dados'),
                      ),
                    ] else if (model.isLoading) ...[
                      const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ] else ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(child: UserCircleAvatar()),
                          const SizedBox(height: 30),
                          Text(
                            "Meu cadastro",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: 16,
                                    color: const Color(0xFFB5C9B8)),
                          ),
                          const SizedBox(height: 10),
                          _profileDrawerAction(
                            "Nome",
                            model.state.fullName ?? '-',
                          ),
                          _profileDrawerAction(
                            "CPF",
                            (model.state.userDocument?.isEmpty ?? true)
                                ? '-'
                                : StringHelpers.obscureCPF(
                                    model.state.userDocument!),
                          ),
                          _profileDrawerAction(
                            "E-mail",
                            model.state.email ?? '-',
                          ),
                          _profileDrawerAction(
                            "Telefone",
                            model.state.phone ?? '-',
                          ),
                          const SizedBox(height: 20),
                          FFButton(
                            text: 'Atualizar perfil',
                            type: FFButtonType.outlined,
                            textColor: Colors.white,
                            borderColor: Colors.white,
                            splashColor: Colors.white.withOpacity(0.1),
                            onPressed: () {
                              Navigator.pop(context);
                              context.pushNamed(RouteName.account);
                            },
                          )
                        ],
                      ),
                    ],
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.pushNamed(RouteName.faq);
                          },
                          style: TextButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.help_outline,
                                color: Color(0xFFB5C9B8),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Ajuda',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontSize: 16,
                                      color: const Color(0xFFB5C9B8),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (model.state.appVersion.isNotEmpty) ...[
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Farmbov © Versão ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: const Color(0xFF9BB7A0),
                                            fontWeight: FontWeight.normal)),
                                TextSpan(
                                  text: model.state.appVersion,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: const Color(0xFF9BB7A0)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    Wrap(
                      children: [
                        _customDivider(height: 24),
                        ProfileDrawerAction(
                          title: AppManager
                                  .instance.currentUser.user?.displayName ??
                              'Usuário',
                          subtitle:
                              AppManager.instance.currentUser.user?.email ??
                                  '-',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 8,
              child: SafeArea(
                child: IconButton(
                  onPressed: () => widget.drawerKey.currentState?.closeDrawer(),
                  iconSize: 32,
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
