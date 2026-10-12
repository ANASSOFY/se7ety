import 'package:flutter/material.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/empty_state_widget.dart';

/// Shared loading, error, empty and content states for API-backed collections.
class AsyncListState extends StatelessWidget {
  const AsyncListState({
    super.key,
    required this.child,
    required this.isEmpty,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.emptyState,
  });

  final Widget child;
  final bool isEmpty;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final Widget? emptyState;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (errorMessage != null) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.cloud_off_outlined, size: 46, color: AppColors.error),
          const SizedBox(height: 12),
          Text(errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('إعادة المحاولة')),
          ],
        ]),
      ));
    }
    if (isEmpty) return emptyState ?? const EmptyStateWidget(title: 'لا توجد بيانات');
    return child;
  }
}
