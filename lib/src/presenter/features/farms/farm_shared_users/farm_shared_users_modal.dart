// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx_triple/mobx_triple.dart';

import 'package:farmbov/src/domain/models/firestore/farm_model.dart';
import 'package:farmbov/src/domain/models/firestore/share_model.dart';
import 'package:farmbov/src/presenter/features/farms/farm_update/farm_update_page.store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_modal_bottom_sheet.dart';

class FarmSharedUsersModal extends StatefulWidget {
  final String? farmId;
  final FarmUpdatePageStore store;

  const FarmSharedUsersModal({
    super.key,
    this.farmId,
    required this.store,
  });

  @override
  State<FarmSharedUsersModal> createState() => _FarmSharedUsersModalState();
}

class _FarmSharedUsersModalState extends State<FarmSharedUsersModal> {
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

  @override
  Widget build(BuildContext context) {
    return TripleBuilder(
      store: widget.store,
      builder: (context, Triple<FarmModel?> model) => BaseModalBottomSheet(
        title: 'Usuários compartilhados',
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          FutureBuilder<List<ShareModel>>(
              future: widget.store.sharedUsers(context, widget.farmId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case ConnectionState.done:
                    final shares = snapshot.data as List<ShareModel>;

                    return shares.isEmpty
                        ? const Column(
                            children: [
                              Center(
                                  child: Text(
                                'Você ainda não compartilhou com ninguém essa fazenda!',
                                style: TextStyle(fontSize: 16),
                              ))
                            ],
                          )
                        : Column(
                            children: [
                              for (final share in shares)
                                ListTile(
                                  title: Text(share.documentOrEmail),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
                                    onPressed: () =>
                                        widget.store.removeSharedUser(
                                      context,
                                      share,
                                    ),
                                  ),
                                ),
                            ],
                          );

                  default:
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                }
              }),
          const SizedBox(height: 40),
          FFButton(
            text: 'Fechar',
            onPressed: () => GoRouter.of(context).pop(),
            loading: widget.store.isLoading,
          ),
        ],
      ),
    );
  }
}
