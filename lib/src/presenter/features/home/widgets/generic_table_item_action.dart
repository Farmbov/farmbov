import 'package:farmbov/src/common/themes/farm_bov_icons.dart';
import 'package:farmbov/src/common/themes/theme_constants.dart';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

enum ActionTableType { add, edit, delete, details }

class GenericTableItemAction extends StatefulWidget {
  final String id;
  final VoidCallback? addAction;
  final VoidCallback? detailsAction;
  final VoidCallback? editAction;
  final VoidCallback? deleteAction;

  const GenericTableItemAction({
    super.key,
    required this.id,
    this.addAction,
    this.detailsAction,
    this.editAction,
    this.deleteAction,
  });

  @override
  State<GenericTableItemAction> createState() => _GenericTableItemActionState();
}

class _GenericTableItemActionState extends State<GenericTableItemAction> {
  ActionTableType? selectedItem;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile
        ? Center(
            child: PopupMenuButton<ActionTableType>(
              initialValue: selectedItem,
              // icon: const Text('Ações'),
              onSelected: (ActionTableType item) {
                setState(() {
                  selectedItem = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ActionTableType>>[
                if (widget.addAction != null)
                  PopupMenuItem<ActionTableType>(
                    value: ActionTableType.add,
                    onTap: widget.addAction,
                    child: Text(
                      'Adicionar',
                      style: TextStyle(
                        color: Colors.white,
                        background: Paint()
                          ..color = Colors.transparent // Cor de fundo
                          ..style = PaintingStyle.fill,
                      ),
                    ),
                  ),
                if (widget.detailsAction != null)
                  PopupMenuItem<ActionTableType>(
                    value: ActionTableType.details,
                    onTap: widget.detailsAction,
                    child: Text('Detalhes',
                        style: TextStyle(
                          color: Colors.white,
                          background: Paint()
                            ..color = Colors.transparent // Cor de fundo
                            ..style = PaintingStyle.fill,
                        )),
                  ),
                if (widget.editAction != null)
                  PopupMenuItem<ActionTableType>(
                    value: ActionTableType.edit,
                    onTap: widget.editAction,
                    child: Text('Editar',
                        style: TextStyle(
                          color: Colors.white,
                          background: Paint()
                            ..color = Colors.transparent // Cor de fundo
                            ..style = PaintingStyle.fill,
                        )),
                  ),
                if (widget.deleteAction != null)
                  PopupMenuItem<ActionTableType>(
                    value: ActionTableType.delete,
                    onTap: widget.deleteAction,
                    child: Text('Deletar',
                        style: TextStyle(
                          color: Colors.white,
                          background: Paint()
                            ..color = Colors.transparent // Cor de fundo
                            ..style = PaintingStyle.fill,
                        )),
                  ),
              ],
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (widget.addAction != null) ...[
                IconButton(
                  onPressed: widget.addAction,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  alignment: Alignment.center,
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.neutralGray,
                  ),
                ),
              ],
              if (widget.detailsAction != null) ...[
                IconButton(
                  onPressed: widget.detailsAction,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  alignment: Alignment.center,
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: AppColors.neutralGray,
                  ),
                ),
              ],
              if (widget.editAction != null) ...[
                IconButton(
                  onPressed: widget.editAction,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  alignment: Alignment.center,
                  splashRadius: 15,
                  icon: const Icon(
                    FarmBovIcons.edit,
                    size: 20,
                    color: AppColors.neutralGray,
                  ),
                ),
              ],
              if (widget.deleteAction != null) ...[
                IconButton(
                  onPressed: widget.deleteAction,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  alignment: Alignment.center,
                  splashRadius: 15,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.neutralGray,
                  ),
                ),
              ],
            ],
          );
  }
}
