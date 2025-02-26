import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:flutter/material.dart';

mixin AnalyticsPageExtension<T extends StatefulWidget> on State<T> {
  String? screenName;
  String? screenClassOverride;

  @override
  void initState() {
    super.initState();
    _setCurrentView();
  }

  /// Define o nome da tela atual no Analytics.
  Future<void> _setCurrentView() async {
    // Não deve mandar os dados em ambiente de desenvolvimento.
    if (AppManager.isDEV) return;

    // Caso a classe de sobreescrita da tela seja preenchida,
    // sobreescreve o nome da tela padrão.
    if (screenClassOverride?.isEmpty ?? false) {
      await AppManager.analytics.logScreenView(
        screenName: screenName ?? widget.runtimeType.toString(),
        screenClass: screenClassOverride!,
      );
    }

    // Define o nome da tela.
    // Caso a propriedade não esteja preenchida,
    // utiliza o nome do arquivo.
    await AppManager.analytics.logScreenView(
      screenName: screenName ?? widget.runtimeType.toString(),
    );
  }
}
