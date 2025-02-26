import 'package:farmbov/src/common/providers/app_manager.dart';
import 'package:farmbov/src/presenter/shared/pages/global_navigation/global_farm_select.dart';
import 'package:farmbov/src/presenter/shared/pages/side_menu_mobile/widgets/profile_drawer_action.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/common/themes/farm_bov_icons.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/helpers/context_extensions.dart';
import 'package:farmbov/src/presenter/shared/pages/side_menu_mobile/side_menu_mobile.dart';
import 'package:farmbov/src/presenter/shared/pages/side_menu_mobile/side_menu_mobile_store.dart';
import 'package:farmbov/src/presenter/shared/pages/global_navigation/widgets/bottom_navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GlobalNavigationTabs extends StatefulWidget {
  final String location;
  final Widget child;
  final StatefulNavigationShell navigationShell;

  const GlobalNavigationTabs({
    super.key,
    required this.location,
    required this.child,
    required this.navigationShell,
  });

  @override
  GlobalNavigationTabsState createState() => GlobalNavigationTabsState();

  static GlobalNavigationTabsState of(BuildContext context) =>
      context.findAncestorStateOfType<GlobalNavigationTabsState>()!;
}

class GlobalNavigationTabsState extends State<GlobalNavigationTabs> {
  int currentIndex = 0;
  final sideMenuMobileStore = SideMenuMobileStore();
  String? _photoUrl;

  static final tabs = [
    const BottomNavigationItem(
      icon: Icon(FarmBovIcons.house, size: 18),
      label: 'Início',
      initialLocation: RouteName.home,
    ),
    const BottomNavigationItem(
      icon: Icon(FarmBovIcons.calendar, size: 18),
      label: 'Relatórios',
      initialLocation: RouteName.reports,
    ),
    const BottomNavigationItem(
      icon: Icon(FarmBovIcons.cow, size: 18),
      label: 'Animais',
      initialLocation: RouteName.dashboard,
    ),
    // TODO: perguntar se não faz mais sentido colocar Vacinas no lugar de Área
    const BottomNavigationItem(
      icon: Icon(Icons.vaccines, size: 18),
      label: 'Vacinas',
      initialLocation: RouteName.vaccines,
    ),
    const BottomNavigationItem(
      icon: Icon(FarmBovIcons.map, size: 18),
      label: 'Fazendas',
      initialLocation: RouteName.farms,
    ),
    // const BottomNavigationItem(
    //   icon: Icon(FarmBovIcons.dotsGrid, size: 18),
    //   label: 'Lotes',
    //   initialLocation: RouteName.lots,
    // ),
  ];

  @override
  void initState() {
    super.initState();
    sideMenuMobileStore.getAppVersion();
  }

  void _goOtherTab(BuildContext context, int index) {
    // debugPrint('Indo para outra página: index - $index');

    setState(() {
      currentIndex = index;
    });

    widget.navigationShell.goBranch(index);
  }

  Widget _buildMobile(BuildContext context) {
    // O índice atual é coletado para alternar entre as páginas.
    //No entanto, ao acessar a FarmsPage (índice 4), que chama outras três branches (índices 5, 6 e 7),
    //mantemos o índice fixo em 4 para evitar mudanças na aba selecionada.
    final currentIndex = widget.navigationShell.currentIndex;
    final index = currentIndex <= 4 ? currentIndex : 4;
    return Scaffold(
      key: NavigationService.mobileMenuKey,
      body: widget.child,
      drawer: SideMenuMobile(
        store: sideMenuMobileStore,
        drawerKey: NavigationService.mobileMenuKey,
      ),
      //TODO:Todo Notification Menu
      // endDrawer: NotificationMenu(scaffoldKey: NavigationService.mobileMenuKey),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 12,
              color: AppColors.primaryGreenDark,
              fontWeight: FontWeight.bold),
          unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppColors.neutralBlack,
              ),
          selectedItemColor: AppColors.primaryGreenDark,
          unselectedItemColor: const Color(0xFF44403C),
          onTap: (int index) => _goOtherTab(context, index),
          currentIndex: index < 0 ? 0 : index,
          items: tabs,
        ),
      ),
    );
  }

  Widget _buildWeb(BuildContext context) {
    return Scaffold(
      key: NavigationService.mobileMenuKey,
      body: Row(
        children: [
          Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: AppColors.primaryGreen,
            child: SafeArea(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => context.goHome(),
                              child: SvgPicture.asset(
                                'assets/images/logos/logo_white.svg',
                                semanticsLabel: 'Farmbov logo',
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ..._menuAction(
                          "Início",
                          FarmBovIcons.house,
                          route: RouteName.home,
                        ),
                        ..._menuAction(
                          "Meus animais",
                          FarmBovIcons.cow,
                          route: RouteName.dashboard,
                        ),
                        ..._menuAction(
                          "Vacinas",
                          FarmBovIcons.health,
                          route: RouteName.vaccines,
                          submenus: [
                            // TODO:LATER
                            // _subMenuActionContent(
                            //   "Adicionar vacina",
                            //   RouteName.vaccineCreate,
                            // ),
                            //TODO: Aplicação unitária.
                            _subMenuActionContent(
                              "Vacinação em lote",
                              RouteName.vaccineLot,
                            ),
                          ],
                        ),
                        ..._menuAction(
                          "Relatórios",
                          FarmBovIcons.calendar,
                          submenus: [
                            _subMenuActionContent(
                              "Baixa no Rebanho",
                              RouteName.animalsDown,
                            ),
                            _subMenuActionContent(
                              "Relatório de Manejo",
                              RouteName.animalsHandling,
                            ),
                            _subMenuActionContent(
                              "Inventário de Animais",
                              RouteName.animalsInventory,
                            ),
                          ],
                        ),
                        ..._menuAction(
                          "Áreas",
                          FarmBovIcons.map,
                          route: RouteName.areas,
                        ),
                        ..._menuAction(
                          "Lotes de animais",
                          FarmBovIcons.dotsGrid,
                          route: RouteName.lots,
                        ),
                        ..._menuAction(
                          "Fazendas",
                          FarmBovIcons.house,
                          route: RouteName.farms,
                        ),
                        const Spacer(),
                        ..._menuAction(
                          "Configurações",
                          Icons.settings_outlined,
                          route: RouteName.settings,
                        ),
                        ..._menuAction(
                          "Ajuda",
                          Icons.help_outline,
                          route: RouteName.faq,
                        ),
                        _customDivider(height: 24),
                        ProfileDrawerAction(
                          title: Provider.of<AppManager>(context)
                                  .currentUser
                                  .user
                                  ?.displayName ??
                              'Usuário',
                          subtitle: Provider.of<AppManager>(context)
                                  .currentUser
                                  .user
                                  ?.email ??
                              '-',
                          photoUrl: _photoUrl,
                          onPressed: () =>
                              context.goNamedAuth(RouteName.account),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Observer(
                            builder: (_) {
                              if (sideMenuMobileStore
                                  .state.appVersion.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'Farmbov © Versão ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontSize: 10,
                                                color: const Color(0xFF9BB7A0),
                                                fontWeight: FontWeight.normal)),
                                    TextSpan(
                                      text:
                                          sideMenuMobileStore.state.appVersion,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 10,
                                            color: const Color(0xFF9BB7A0),
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          offset: Offset(0, 1),
                          blurRadius: 0,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          offset: Offset(0, 2),
                          blurRadius: 2,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message: 'Fazenda atual',
                            child: Icon(
                              FarmBovIcons.house,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          SizedBox(width: 15),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: GlobalFarmSelect(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: widget.child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _menuAction(
    String title,
    IconData icon, {
    String? route,
    List<Widget>? submenus,
  }) {
    return [
      _menuActionContent(title, icon, route: route),
      ...submenus ?? const [],
      const SizedBox(height: 15),
    ];
  }

  Widget _menuActionContent(
    String title,
    IconData icon, {
    String? route,
  }) {
    final isActive = GoRouterState.of(context).uri.toString() == route;

    return Material(
      color: isActive ? const Color(0xFFB5C9B8) : AppColors.primaryGreen,
      borderRadius: BorderRadius.circular(8),
      child: route == null
          ? _menuActionContentLabel(title, icon, isActive)
          : InkWell(
              onTap: () => context.goNamed(route),
              child: _menuActionContentLabel(title, icon, isActive),
            ),
    );
  }

  Widget _menuActionContentLabel(
    String title,
    IconData icon,
    bool isActive,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primaryGreen : const Color(0xFFB5C9B8),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? AppColors.primaryGreen
                      : const Color(0xFFB5C9B8),
                ),
          ),
        ],
      ),
    );
  }

  Widget _subMenuActionContent(
    String title,
    String route,
  ) {
    final isActive = GoRouterState.of(context).uri.toString() == route;

    return Container(
      margin: const EdgeInsets.only(left: 20, top: 4),
      child: Material(
        color: isActive ? const Color(0xFFB5C9B8) : AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => context.goNamed(route),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 5,
                  color: isActive
                      ? AppColors.primaryGreen
                      : const Color(0xFFB5C9B8),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? AppColors.primaryGreen
                            : const Color(0xFFB5C9B8),
                      ),
                ),
              ],
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile
        ? _buildMobile(context)
        : _buildWeb(context);
  }
}
