import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmbov/src/common/helpers/custom_validators.dart';
import 'package:farmbov/src/presenter/features/account/account_update_page.store.dart';
import 'package:farmbov/src/presenter/features/account/account_update_page_model.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mobx_triple/mobx_triple.dart';

class AccountUpdatePage extends StatefulWidget {
  final AccountUpdatePageStore store;

  const AccountUpdatePage({super.key, required this.store});

  @override
  AccountUpdatePageState createState() => AccountUpdatePageState();
}

class AccountUpdatePageState extends State<AccountUpdatePage> {
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

  Widget _defaultLoading() {
    return const SizedBox(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        color: AppColors.primaryGreen,
      ),
    );
  }

  Widget defaultAvatar({
    bool isLoading = false,
  }) {
    return CircleAvatar(
      backgroundColor: Colors.black12,
      radius: 60,
      child: isLoading
          ? _defaultLoading()
          : const Icon(
              Icons.person,
              color: Color(0xffCCCCCC),
              size: 60,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TripleBuilder(
      store: widget.store,
      builder: (context, Triple<AccountUpdatePageModel?> model) =>
          BaseModalBottomSheet(
        title: 'Meu Perfil',
        crossAxisAlignment: CrossAxisAlignment.start,
        showCloseButton: true,
        children: [
          if (model.isLoading) ...[
            const SizedBox(height: 40),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ] else ...[
            const SizedBox(height: 40),
            Form(
              key: widget.store.formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informações pessoais',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF292524),
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: InkWell(
                      onTap: (model.state?.isMediaUploading ?? false)
                          ? null
                          : () => widget.store.uploadImage(context),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          model.state?.user?.photoUrl == null
                              ? defaultAvatar(
                                  isLoading:
                                      model.state?.isMediaUploading ?? false)
                              : Hero(
                                  tag: model.state!.user!.photoUrl!,
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      model.state!.user!.photoUrl!,
                                    ),
                                    radius: 60,
                                    backgroundColor: Colors.black12,
                                    child:
                                        model.state?.isMediaUploading ?? false
                                            ? _defaultLoading()
                                            : null,
                                  ),
                                ),
                          const Icon(
                            Icons.file_upload,
                            color: AppColors.primaryGreen,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FFInput(
                    floatingLabel: 'Nome completo',
                    labelText: 'Insira um nome',
                    controller: widget.store.nameController,
                    keyboardType: TextInputType.name,
                    validator: MultiValidator([
                      DefaultRequiredValidator(),
                      MinLengthValidator(10,
                          errorText:
                              'O nome deve ter no mínimo 10 caracteres.'),
                      MaxLengthValidator(50,
                          errorText: 'O nome deve ter no máximo 50 caracteres.')
                    ]).call,
                  ),
                  const SizedBox(height: 16),
                  FFInput(
                    readOnly: true,
                    floatingLabel: 'CPF',
                    labelText: 'CPF',
                    controller: widget.store.documentController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FFInput(
                    readOnly: true,
                    floatingLabel: 'E-mail',
                    labelText: 'E-mail',
                    controller: widget.store.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: MultiValidator([
                      DefaultRequiredValidator(),
                      EmailValidator(errorText: 'Insira um e-mail válido.'),
                    ]).call,
                  ),
                  const SizedBox(height: 16),
                  FFInput(
                    floatingLabel: 'Telefone',
                    labelText: 'Telefone',
                    controller: widget.store.telefoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    validator: RequiredValidator(
                            errorText: 'Este campo é obrigatório.')
                        .call,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            FFButton(
              text: 'Salvar alterações',
              onPressed: () => widget.store.edit(context),
              loading: model.isLoading,
            ),
          ],
        ],
      ),
    );
  }
}
