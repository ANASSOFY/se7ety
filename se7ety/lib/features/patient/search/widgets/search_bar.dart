import 'package:flutter/material.dart';

import 'package:se7ety/core/theme/app_colors.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key, required this.onSubmitted});

  final ValueChanged<String> onSubmitted;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textDirection: TextDirection.rtl,
      textInputAction: TextInputAction.search,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: 'ابحث عن طبيب أو تخصص',
        hintStyle: TextStyle(color: AppColors.textSecondary),
        prefixIcon: IconButton(
          onPressed: () => widget.onSubmitted(_controller.text),
          icon: Icon(Icons.search_rounded, color: AppColors.primary),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
