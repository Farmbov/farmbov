import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/domain/stores/common_base_store.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

mixin GenericPageMixin<T extends StatefulWidget> on State<T> {
  CommonBaseStore? _baseStore;
  CommonBaseStore? get baseStore => _baseStore;

  late String title;
  bool allowBackButton = true;

  Widget? _web;
  Widget? _mobile;
  Widget? _noContentPage;

  PreferredSizeWidget? _mobileAppBar;

  Widget get web => _web ?? const SizedBox.shrink();
  Widget get mobile => _mobile ?? const SizedBox.shrink();

  Widget get noContentPage =>
      _noContentPage ??
      NoContentPage(
        title: 'Nada por aqui',
        description: 'Nenhum item foi encontrado.',
        actionTitle: 'Voltar',
        action: () => NavigationService.rootNavigatorKey.currentContext?.pop(),
      );

  PreferredSizeWidget? get mobileAppBar =>
      ResponsiveBreakpoints.of(context).isMobile ? _mobileAppBar : null;

  @override
  void initState() {
    super.initState();
    baseStore?.init();
  }

  @override
  void dispose() {
    baseStore?.disposeStore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile ? mobile : web;
}
