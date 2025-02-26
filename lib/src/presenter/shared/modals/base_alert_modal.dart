import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

enum BaseModalType {
  success,
  warning,
  danger,
}

class BaseAlertModal extends StatelessWidget {
  final BaseModalType type;

  final String title;
  final String? description;
  final String? actionButtonTitle;
  final Widget? actionButtonIcon;
  final VoidCallback? actionCallback;
  final VoidCallback? cancelCallback;
  final Widget? content;
  final bool showCancel;

  final List<Widget>? descriptionWidgets;
  final List<Widget>? actionWidgets;
  final String? popScopePageRoute;

  final bool canPop;

  const BaseAlertModal({
    super.key,
    this.type = BaseModalType.success,
    this.title = 'Sucesso',
    this.description,
    this.actionButtonTitle = 'Entendi',
    this.actionButtonIcon,
    this.actionCallback,
    this.cancelCallback,
    this.content,
    this.descriptionWidgets,
    this.actionWidgets,
    this.popScopePageRoute,
    this.showCancel = true,
    this.canPop = false,
  });

  Widget _getIcon() {
    if (type == BaseModalType.success) {
      return SvgPicture.asset('assets/images/icons/featured_success_icon.svg');
    } else if (type == BaseModalType.danger) {
      return SvgPicture.asset('assets/images/icons/featured_danger_icon.svg');
    } else {
      return Icon(Icons.info, color: Colors.blue[600]);
    }
  }

  bool _onPopInvoked(BuildContext context) {
    if (popScopePageRoute != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pop();
        context.goNamed(popScopePageRoute!);
      });
      return true;
    }
    context.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: canPop ? null : (_) => _onPopInvoked(context),
      canPop: canPop,
      child: Dialog(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: BoxConstraints(
              maxWidth: 15.w,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _getIcon(),
                    canPop
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            iconSize: 24,
                            color: const Color(0xFF79716B),
                            onPressed: () => context.pop(),
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (descriptionWidgets != null) ...[
                  const SizedBox(height: 15),
                  ...descriptionWidgets!,
                  const SizedBox(height: 20),
                ] else if (description != null) ...[
                  const SizedBox(height: 15),
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                ],
                if (content != null) ...[
                  content!,
                ],
                if (actionWidgets == null) ...[
                  const SizedBox(height: 20),
                  FFButton(
                    text: actionButtonTitle,
                    onPressed: actionCallback ?? () => context.pop(),
                    icon: actionButtonIcon,
                    backgroundColor: type == BaseModalType.danger
                        ? AppColors.feedbackDanger
                        : null,
                    borderColor: type == BaseModalType.danger
                        ? AppColors.feedbackDanger
                        : null,
                    textColor: Colors.white,
                  ),
                  if (showCancel || cancelCallback != null) ...[
                    const SizedBox(height: 16),
                    FFButton(
                      text: 'Cancelar',
                      onPressed: () {
                        if (cancelCallback != null) {
                          cancelCallback!();
                        } else {
                          context.pop();
                        }
                      },
                      backgroundColor: Colors.transparent,
                      borderColor: AppColors.feedbackDanger,
                      textColor: AppColors.feedbackDanger,
                      splashColor: AppColors.feedbackDanger.withOpacity(0.1),
                    ),
                  ],
                ] else ...[
                  const SizedBox(height: 20),
                  ...actionWidgets!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
