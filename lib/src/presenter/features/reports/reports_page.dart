import 'package:farmbov/src/presenter/features/reports/report_inventory_animals/report_inventory_animals_page.dart';
import 'package:farmbov/src/presenter/features/reports/report_inventory_animals/report_inventory_animals_page_store.dart';
import 'package:farmbov/src/presenter/features/reports/report_management_animals/report_management_animals_page.dart';
import 'package:farmbov/src/presenter/features/reports/report_management_animals/report_management_animals_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_section_button.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/presenter/shared/components/generic_page_content.dart';
import 'package:farmbov/src/presenter/features/reports/report_down_animals/report_down_animals_page_store.dart';
import 'package:farmbov/src/presenter/features/reports/reports_page_store.dart';
import 'package:farmbov/src/presenter/features/reports/report_down_animals/report_down_animals_page.dart';
import 'package:farmbov/src/presenter/shared/components/no_content_page.dart';
import 'package:farmbov/src/presenter/shared/components/page_appbar.dart';
import 'package:farmbov/src/presenter/shared/pages/generic_page/generic_page_mixin.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ReportsPage extends StatefulWidget {
  final ReportsPageStore store;

  const ReportsPage({super.key, required this.store});

  @override
  ReportsPageState createState() => ReportsPageState();
}

class ReportsPageState extends State<ReportsPage> with GenericPageMixin {
  @override
  ReportsPageStore get baseStore => widget.store;

  @override
  Widget get web => _buildContentWeb(context);

  @override
  Widget get mobile => _buildContentWeb(context);

  @override
  PreferredSizeWidget? get mobileAppBar => const PageAppBar(
        title: "Relatórios",
        backButton: false,
      );

  @override
  Widget get noContentPage => NoContentPage(
        title: 'Nenhum animal cadastrado',
        description: 'Você ainda não cadastrou nenhum animal.',
        actionTitle: 'Cadastrar animal',
        action: () {},
      );

  EdgeInsetsGeometry _getPadding(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile
          ? const EdgeInsets.all(0)
          : const EdgeInsets.all(24);

  EdgeInsetsGeometry _getTitlePadding(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile
          ? const EdgeInsets.only(left: 24, top: 24)
          : const EdgeInsets.all(0);

  Widget _buildContentWeb(BuildContext context) {
    return GenericPageContent(
      title: 'Relatórios',
      useGridRows: false,
      padding: _getPadding(context),
      titlePadding: _getTitlePadding(context),
      children: _buildListing(context),
    );
  }

  Widget _buildContentMobile(BuildContext context) {
    return GenericPageContent(
      title: 'Relatórios',
      appBar: mobileAppBar,
      useGridRows: false,
      padding: _getPadding(context),
      titlePadding: _getTitlePadding(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      actionWidget: FFSectionButton(
        title: 'Baixas no rebanho',
        icon: Icons.arrow_drop_down,
        onPressed: () => {},
        height: 40,
        width: 170,
      ),
      children: _buildListing(context),
    );
  }

  List<Widget> _buildListing(BuildContext context) {
    return [
      ReportDownAnimalsPage(
        store: ReportDownAnimalsPageStore(),
        baseStore: widget.store,
      ),
      const Divider(height: 80),
      ReportManagementAnimalsPage(
        store: ReportManagementAnimalsPageStore(),
        baseStore: widget.store,
      ),
      const Divider(height: 80),
      ReportInventoryAnimalsPage(
        store: ReportInventoryAnimalsPageStore(),
        baseStore: widget.store,
      ),
      const SizedBox(height: 80),
    ];
  }
}
