import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/features/sign_in/sign_in_page_model.dart';
import 'package:farmbov/src/presenter/features/sign_in/sign_in_page_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/components/init_page_background.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SignInPage extends StatefulWidget {
  final SignInPageStore store;

  const SignInPage({super.key, required this.store});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailFocusNode = FocusNode(skipTraversal: true);
  final passwordFocusNode = FocusNode(skipTraversal: true);

  @override
  void dispose() {
    widget.store.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Widget _buildMobile(Triple<SignInPageModel> model, BuildContext context) {
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
                                  'Entrar',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.primaryGreen,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                const SizedBox(height: 40),
                                AutofillGroup(
                                  child: Form(
                                    key: widget.store.formKey,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    child: AutofillGroup(
                                      child: Column(
                                        children: [
                                          Column(
                                            children: [
                                              FFInput(
                                                autoFocus: true,
                                                floatingLabel: 'E-mail',
                                                showTwoPointsFloatingLabel:
                                                    false,
                                                prefixIconData:
                                                    Icons.email_outlined,
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: widget.store
                                                    .emailAddressLoginController,
                                                autofillHints: const [
                                                  AutofillHints.email,
                                                  AutofillHints.username
                                                ],
                                                validator: MultiValidator([
                                                  RequiredValidator(
                                                      errorText:
                                                          'Este campo é obrigatório.'),
                                                  EmailValidator(
                                                    errorText:
                                                        'Insira um e-mail válido (nome@email.com)',
                                                  ),
                                                ]).call,
                                              ),
                                              const SizedBox(height: 20),
                                              FFInput(
                                                floatingLabel: 'Senha',
                                                showTwoPointsFloatingLabel:
                                                    false,
                                                maxLines: 1,
                                                prefixIconData:
                                                    Icons.lock_open_outlined,
                                                textInputAction:
                                                    TextInputAction.done,
                                                autofillHints: const [
                                                  AutofillHints.password
                                                ],
                                                sufixIcon: InkWell(
                                                  onTap: () =>
                                                      widget.store.update(
                                                    model.state.copyWith(
                                                      passwordLoginVisibility:
                                                          !model.state
                                                              .passwordLoginVisibility,
                                                    ),
                                                  ),
                                                  focusNode: passwordFocusNode,
                                                  child: Icon(
                                                    model.state.passwordLoginVisibility
                                                        ? Icons
                                                            .visibility_outlined
                                                        : Icons
                                                            .visibility_off_outlined,
                                                    color:
                                                        const Color(0xFF95A1AC),
                                                    size: 20,
                                                  ),
                                                ),
                                                obscureText: !model.state
                                                    .passwordLoginVisibility,
                                                controller: widget.store
                                                    .passwordLoginController,
                                                validator: MultiValidator([
                                                  RequiredValidator(
                                                      errorText:
                                                          'Este campo é obrigatório.'),
                                                ]).call,
                                                onFieldSubmitted: (_) {
                                                  passwordFocusNode.unfocus();
                                                  widget.store.login(context);
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child: Checkbox(
                                                          value: model
                                                              .state.saveLogin,
                                                          onChanged: (value) =>
                                                              widget.store
                                                                  .update(
                                                            model.state
                                                                .copyWith(
                                                              saveLogin: value!,
                                                            ),
                                                          ),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          materialTapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          activeColor: AppColors
                                                              .primaryGreen,
                                                          side:
                                                              MaterialStateBorderSide
                                                                  .resolveWith(
                                                            (Set<MaterialState>
                                                                states) {
                                                              if (states.contains(
                                                                  MaterialState
                                                                      .selected)) {
                                                                return const BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .transparent,
                                                                );
                                                              }

                                                              return const BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xffD7D3D0),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              AppColors
                                                                  .primaryGreen,
                                                        ),
                                                        onPressed: () =>
                                                            widget.store.update(
                                                          model.state.copyWith(
                                                            saveLogin: !model
                                                                .state
                                                                .saveLogin,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "Lembrar-me",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                    color: AppColors
                                                                        .primaryGreenDark,
                                                                  ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: AppColors
                                                          .primaryGreen,
                                                    ),
                                                    onPressed: () => context.go(
                                                        RouteName
                                                            .resetPassword),
                                                    child: Text(
                                                      'Esqueci a senha',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color: AppColors
                                                                .primaryGreenDark,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 40),
                                              FFButton(
                                                text: 'Entrar',
                                                onPressed: () =>
                                                    widget.store.login(context),
                                                loading: widget.store.isLoading,
                                              ),
                                              const SizedBox(height: 40),
                                              TextButton(
                                                onPressed: () =>
                                                    context.goNamed(
                                                  RouteName.signup,
                                                ),
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    children: <TextSpan>[
                                                      const TextSpan(
                                                        text:
                                                            'Ainda não possui uma conta? ',
                                                      ),
                                                      TextSpan(
                                                        text: 'Cadastre-se!',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .primaryGreenDark,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
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
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeb(Triple<SignInPageModel> model, BuildContext context) {
    return InitPageBackground(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Entrar',
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
          child: AutofillGroup(
            child: Column(
              children: [
                FFInput(
                  autoFocus: true,
                  floatingLabel: 'E-mail',
                  showTwoPointsFloatingLabel: false,
                  prefixIconData: Icons.email_outlined,
                  controller: widget.store.emailAddressLoginController,
                  autofillHints: const [
                    AutofillHints.email,
                    AutofillHints.username
                  ],
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Este campo é obrigatório.'),
                    EmailValidator(
                      errorText: 'Insira um e-mail válido (nome@email.com)',
                    ),
                  ]).call,
                ),
                const SizedBox(height: 20),
                FFInput(
                  floatingLabel: 'Senha',
                  showTwoPointsFloatingLabel: false,
                  maxLines: 1,
                  prefixIconData: Icons.lock_open_outlined,
                  autofillHints: const [AutofillHints.password],
                  sufixIcon: InkWell(
                    onTap: () => widget.store.update(
                      model.state.copyWith(
                        passwordLoginVisibility:
                            !model.state.passwordLoginVisibility,
                      ),
                    ),
                    focusNode: FocusNode(skipTraversal: true),
                    child: Icon(
                      model.state.passwordLoginVisibility
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF95A1AC),
                      size: 20,
                    ),
                  ),
                  obscureText: !model.state.passwordLoginVisibility,
                  controller: widget.store.passwordLoginController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Este campo é obrigatório.'),
                  ]).call,
                  onFieldSubmitted: (_) {
                    emailFocusNode.unfocus();
                    widget.store.login(context);
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          // TODO: use the same inputs (componentize)
                          child: Checkbox(
                            value: model.state.saveLogin,
                            onChanged: (value) => widget.store.update(
                              model.state.copyWith(
                                saveLogin: value!,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            activeColor: AppColors.primaryGreen,
                            side: MaterialStateBorderSide.resolveWith(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return const BorderSide(
                                    width: 1,
                                    color: Colors.transparent,
                                  );
                                }

                                return const BorderSide(
                                  width: 1,
                                  color: Color(0xffD7D3D0),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryGreen,
                          ),
                          onPressed: () => widget.store.update(
                            model.state.copyWith(
                              saveLogin: !model.state.saveLogin,
                            ),
                          ),
                          child: Text(
                            "Lembrar-me",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.primaryGreenDark),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                      ),
                      onPressed: () => context.goNamed(
                        RouteName.resetPassword,
                      ),
                      child: Text(
                        'Esqueci a senha',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.primaryGreenDark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                FFButton(
                  text: 'Entrar',
                  onPressed: () {
                     passwordFocusNode.unfocus();
                      emailFocusNode.unfocus();
                    return widget.store.login(context);
                  },
                  loading: widget.store.isLoading,
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () => context.goNamed(RouteName.signup),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Ainda não possui uma conta? ',
                        ),
                        TextSpan(
                          text: 'Cadastre-se!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreenDark),
                        ),
                      ],
                    ),
                  ),
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
      body: TripleBuilder(
        store: widget.store,
        builder: (context, Triple<SignInPageModel> model) =>
            ResponsiveBreakpoints.of(context).isMobile
                ? _buildMobile(model, context)
                : _buildWeb(model, context),
      ),
    );
  }
}
