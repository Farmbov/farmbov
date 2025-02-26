// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/router/route_name.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/farm_bov_icons.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> with GenericPageMixin {
  @override
  Widget get web => _buildContent(context);

  @override
  Widget get mobile => _buildContent(context);

  @override
  String get title => 'Configurações';

  @override
  bool get allowBackButton => true;

  Widget _buildAreaCard(
      BuildContext context, String cardTitle, IconData icon, String routeName) {
    return Card(
      child: InkWell(
        onTap: () {
          GoRouter.of(context).pushNamed(routeName);
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffD7D3D0),
              style: BorderStyle.solid,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: AppColors.neutralBlack,
              ),
              const SizedBox(height: 20),
              Text(
                cardTitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDeleteFarmDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir fazenda'),
        content: const Text('Deseja realmente excluir sua fazenda?'),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => GoRouter.of(context).pop(true),
            child: const Text('Entrar em contato com o suporte'),
          ),
        ],
      ),
    );

    if (result == true) {
      final url = Uri(
        scheme: 'mailto',
        path: 'surpote@farmbov.com.br',
        queryParameters: {
          'subject': '[Suporte] Apagar fazenda',
        },
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        // TODO: use notify
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Erro ao entrar em contato com o suporte. Tente novamente mais tarde.'),
          ),
        );
      }
    }
  }

  Widget _buildContent(BuildContext context) => GenericPageContent(
        title: 'Configurações',
        showBackButton:
            ResponsiveBreakpoints.of(context).isDesktop ? false : true,
        onBackButtonPressed: () {
          //Lida com a navegação de subpáginas dentro do botão "Outras Páginas"
          final shell = StatefulNavigationShell.of(context);
          shell.goBranch(4, initialLocation: true);
        },
        useGridRows: true,
        childrenCrossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _animalBreedRegistrationCard(context),
          _animalDownReasonsCard(context),
          _drugAdministrationTypesCard(context),
          _vaccinesCard(context),
          _deleteFarmButton(context),
        ],
      );

  SizedBox _animalBreedRegistrationCard(BuildContext context) {
    return SizedBox(
      width: 200,
      child: _buildAreaCard(context, 'Raças dos Animais', FarmBovIcons.cow,
          RouteName.animalBreeds),
    );
  }

  SizedBox _animalDownReasonsCard(BuildContext context) {
    return SizedBox(
      width: 200,
      child: _buildAreaCard(context, 'Motivos de Baixa', FarmBovIcons.attention,
          RouteName.animalDownReasons),
    );
  }

  SizedBox _drugAdministrationTypesCard(BuildContext context) {
    return SizedBox(
      width: 200,
      child: _buildAreaCard(context, 'Via de Administração de Vacinas',
          FarmBovIcons.health, RouteName.drugAdministrationTypes),
    );
  }

  SizedBox _vaccinesCard(BuildContext context) {
    return SizedBox(
      width: 200,
      child: _buildAreaCard(context, 'Vacinas', Icons.vaccines_outlined,
          RouteName.vaccinesConfiguration),
    );
  }

  Widget _deleteFarmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => _openDeleteFarmDialog(),
            icon: const Icon(Icons.delete),
            label: RichText(
              text: TextSpan(
                text: 'Desejo ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.red,
                    ),
                children: const [
                  TextSpan(
                    text: 'excluir',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' minha fazenda',
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
