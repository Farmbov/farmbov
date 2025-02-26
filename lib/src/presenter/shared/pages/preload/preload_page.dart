import 'package:farmbov/src/presenter/shared/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/presenter/features/welcome/welcome_page.dart';
import 'package:farmbov/src/presenter/shared/pages/preload/preload_page_store.dart';

class PreloadPage extends StatefulWidget {
  final PreloadPageStore store;

  const PreloadPage({super.key, required this.store});

  @override
  State<PreloadPage> createState() => _PreloadPageState();
}

class _PreloadPageState extends State<PreloadPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.store.init(context));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder.transition(
      store: widget.store,
      onLoading: (_) => const SplashPage(),
      onState: (_, bool loaded) =>
          loaded ? const WelcomePage() : const SplashPage(),
    );
  }
}
