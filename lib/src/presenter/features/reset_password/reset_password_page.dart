import 'package:farmbov/src/common/helpers/custom_validators.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/features/reset_password/reset_password_store.dart';
import 'package:farmbov/src/presenter/shared/components/init_page_background.dart';

import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResetPasswordPage extends StatefulWidget {
  final ResetPasswordStore store;

  const ResetPasswordPage({super.key, required this.store});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  void initState() {
    super.initState();
    widget.store.init();
  }

  @override
  void dispose() {
    widget.store.dispose();
    super.dispose();
  }

  Widget _buildMobile(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.primaryGreen,
          ),
          onPressed: () => context.goNamed(RouteName.root),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: Column(
            children: buildWidgets(context),
          ),
        ),
      ),
    );
  }

  Widget _buildWeb(BuildContext context) {
    return Observer(
      builder: (_) => InitPageBackground(
        children: buildWidgets(context),
      ),
    );
  }

  List<Widget> buildWidgets(BuildContext context) {
    return [
      SvgPicture.asset(
        'assets/images/icons/featured_key.svg',
        semanticsLabel: 'Chave',
      ),
      const SizedBox(height: 20),
      Text(
        'Esqueceu sua senha?',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 4),
      Text('Não se preocupe, iremos te enviar as instruções por e-mail.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 40),
      Form(
        key: widget.store.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: FFInput(
          floatingLabel: 'E-mail',
          prefixIconData: Icons.email_outlined,
          controller: widget.store.emailController,
          validator: MultiValidator(
            [
              DefaultRequiredValidator(),
              EmailValidator(
                errorText: 'Insira um e-mail válido (nome@email.com)',
              ),
            ],
          ).call,
        ),
      ),
      const SizedBox(height: 40),
      FFButton(
        text: 'Recuperar senha',
        onPressed: () => widget.store.send(context),
        loading: widget.store.isLoading,
      ),
      const SizedBox(height: 16),
      FFButton(
        text: 'Cancelar',
        onPressed: () => context.goNamed(RouteName.root),
        type: FFButtonType.outlined,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBreakpoints.of(context).isMobile
          ? _buildMobile(context)
          : _buildWeb(context),
    );
  }
}
