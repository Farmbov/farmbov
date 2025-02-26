import 'package:farmbov/src/common/helpers/custom_validators.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/presenter/features/sign_up/sign_up_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/components/init_page_background.dart';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../privacy_policy/privacy_policy_page.dart';
import '../terms_conditions/terms_conditions_page.dart';

class SignUpPage extends StatefulWidget {
  final SignUpPageStore store;

  const SignUpPage({super.key, required this.store});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ValueNotifier<bool> termsAccepted = ValueNotifier<bool>(false);
  final ValueNotifier<bool> privacyAccepted = ValueNotifier<bool>(false);

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

  Widget _actionButtons(BuildContext context) {
    return Observer(
      builder: (_) => Column(
        children: [
          FFButton(
            text: widget.store.createAccountText.value,
            loading: widget.store.isLoading,
            onPressed: () async {
              if (widget.store.formKey.currentState == null ||
                  widget.store.formKey.currentState?.validate() == false) {
                return;
              }

              if (widget.store.pageController.page! < 1) {
                widget.store.pageController
                    .nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.linear)
                    .then((_) => widget.store.changeCreateAccountText());
              } else {
                if (termsAccepted.value == false ||
                    privacyAccepted.value == false) {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return const BaseAlertModal(
                          type: BaseModalType.warning,
                          title: 'Ação Necessária!',
                          description:
                              "Você precisa aceitar os Termos de Uso e a Política de Privacidade antes de prosseguir.",
                          canPop: true,
                          showCancel: false,
                        );
                      });
                  return;
                }
                await widget.store.submitForm(context);
              }
            },
          ),
          const SizedBox(height: 16),
          FFButton(
            text: 'Voltar',
            type: FFButtonType.outlined,
            onPressed: () {
              if (widget.store.pageController.page! > 0) {
                widget.store.pageController
                    .previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.linear)
                    .then((_) => widget.store.changeCreateAccountText());
              } else {
                context.pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _basicInformationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dados pessoais',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 16,
        ),
        FFInput(
          floatingLabel: 'Nome completo',
          labelText: 'Nome completo',
          controller: widget.store.fullNameController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          validator: MultiValidator([
            // TODO: abstracao para todo os campos obrigatórios
            DefaultRequiredValidator(),
            MinLengthValidator(10,
                errorText: 'O nome deve ter no mínimo 10 caracteres.'),
            MaxLengthValidator(50,
                errorText: 'O nome deve ter no máximo 50 caracteres.')
          ]).call,
        ),
        const SizedBox(height: 20),
        FFInput(
          floatingLabel: 'CPF',
          labelText: 'CPF',
          controller: widget.store.documentController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfInputFormatter(),
          ],
          validator: MultiValidator([
            DefaultRequiredValidator(),
          ]).call,
        ),
        const SizedBox(height: 20),
        FFInput(
          floatingLabel: 'E-mail',
          labelText: 'E-mail',
          controller: widget.store.emailController,
          keyboardType: TextInputType.emailAddress,
          validator: MultiValidator([
            DefaultRequiredValidator(),
            EmailValidator(errorText: 'Insira um e-mail válido.'),
          ]).call,
        ),
        const SizedBox(height: 20),
        FFInput(
          floatingLabel: 'Telefone',
          labelText: 'Telefone com DDD',
          controller: widget.store.phoneNumberController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TelefoneInputFormatter(),
          ],
          keyboardType: TextInputType.phone,
          validator: DefaultRequiredValidator().call,
        ),
      ],
    );
  }

  Widget _passwordStep() {
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crie sua senha',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 16,
          ),
          FFInput(
            floatingLabel: 'Senha',
            labelText: 'Crie sua senha',
            controller: widget.store.senhaController,
            maxLines: 1,
            sufixIcon: InkWell(
              onTap: () => widget.store.togglePasswordVisibility(),
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                widget.store.senhaVisibility.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF95A1AC),
                size: 20,
              ),
            ),
            obscureText: !widget.store.senhaVisibility.value,
            validator: MultiValidator([
              DefaultRequiredValidator(),
              MinLengthValidator(6,
                  errorText: 'A senha deve ter no mínimo 6 caracteres.'),
              PatternValidator(
                r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-])[A-Za-z\d!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]{6,}$",
                errorText:
                    '''Insira ao menos uma letra maíuscula e uma minúscula (A-Z).
                    \nAo menos um número (0-9).\nAo menos um caracter especial.''',
              ),
            ]).call,
          ),
          const SizedBox(height: 20),
          FFInput(
            floatingLabel: 'Confirmação de senha',
            labelText: 'Confirme sua senha',
            helperText: 'A senha deve ter no mínimo 6 caracteres.',
            controller: widget.store.confirmeSenhaController,
            maxLines: 1,
            sufixIcon: InkWell(
              onTap: () => widget.store.toggleConfirmPasswordVisibility(),
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                widget.store.confirmeSenhaVisibility.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF95A1AC),
                size: 20,
              ),
            ),
            obscureText: !widget.store.confirmeSenhaVisibility.value,
            validator: (value) =>
                MatchValidator(errorText: 'As senhas não são iguais.')
                    .validateMatch(
              value ?? '',
              widget.store.senhaController?.text ?? '',
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Aceite os termos:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          // Checkbox para os termos de uso
          ValueListenableBuilder<bool>(
            valueListenable: termsAccepted,
            builder: (context, isChecked, _) {
              return CheckboxListTile(
                value: isChecked,
                contentPadding: const EdgeInsets.all(0),
                onChanged: (value) {
                  termsAccepted.value = value ?? false;
                },
                title: const Text("Aceito os Termos de Uso"),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsConditionsPage(),
                      ),
                    );
                  },
                  child: const Text("Ver Termos"),
                ),
              );
            },
          ),
          // Checkbox para a política de privacidade
          ValueListenableBuilder<bool>(
            valueListenable: privacyAccepted,
            builder: (context, isChecked, _) {
              return CheckboxListTile(
                value: isChecked,
                contentPadding: const EdgeInsets.all(0),
                onChanged: (value) {
                  privacyAccepted.value = value ?? false;
                },
                title: const Text("Aceito a Política de Privacidade"),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage(),
                      ),
                    );
                  },
                  child: const Text("Ver Política"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _stepIndicator(int page) {
    return Container(
      width: 90,
      height: 8,
      decoration: BoxDecoration(
        color: widget.store.currentPage.value == page
            ? AppColors.primaryGreen
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSteps(BuildContext context) {
    return Column(
      children: [
        ExpandablePageView(
          controller: widget.store.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _basicInformationStep(),
            //_addressStep(),
            _passwordStep(),
          ],
        ),
        const SizedBox(height: 24),
        _actionButtons(context),
        const SizedBox(height: 32),
        //TODO: currentPage state not updating
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     _stepIndicator(0),
        //     const SizedBox(width: 12),
        //     _stepIndicator(1),
        //     // const SizedBox(width: 12),
        //     // _stepIndicator(2),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return InitPageBackground(
      customTopAlignment: true,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SvgPicture.asset(
                  'assets/images/logos/logo_white.svg',
                  semanticsLabel: 'Farmbov logo',
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          primary: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 40,
                              horizontal: 16,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Cadastrar-se',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.primaryGreenDark,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                const SizedBox(height: 40),
                                Form(
                                  key: widget.store.formKey,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  child: _buildSteps(context),
                                ),
                                const SizedBox(height: 40),
                                TextButton(
                                  onPressed: () =>
                                      context.goNamed(RouteName.signin),
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: 'Já possui uma conta? ',
                                        ),
                                        TextSpan(
                                          text: 'Entrar!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColors.primaryGreenDark,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeb(BuildContext context) {
    return InitPageBackground(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Cadastre-se',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primaryGreenDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 40),
        Form(
          key: widget.store.formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: _buildSteps(context),
        ),
        const SizedBox(height: 40),
        TextButton(
          onPressed: () => context.goNamed(RouteName.signin),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: <TextSpan>[
                const TextSpan(
                  text: 'Já possui uma conta? ',
                ),
                TextSpan(
                  text: 'Entrar!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreenDark),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
