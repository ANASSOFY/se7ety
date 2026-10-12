import 'package:flutter/material.dart';

import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/doctor_card.dart';
import 'package:se7ety/core/widgets/empty_state_widget.dart';
import 'package:se7ety/core/widgets/section_title.dart';
import 'package:se7ety/features/patient/doctors/view/doctor_details_screen.dart';
import 'package:se7ety/features/patient/search/viewmodel/search_view_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  late final SearchViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    searchController.text = widget.initialQuery;
    _viewModel = SearchViewModel(initialQuery: widget.initialQuery);
  }

  final List<String> recentSearches = ['دكتور قلب', 'أسنان', 'أطفال'];

  final List<String> popularSearches = [
    'قلب',
    'أسنان',
    'أطفال',
    'جلدية',
    'باطنة',
    'مخ وأعصاب',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _selectSearch(String value) {
    searchController.text = value;
    _viewModel.updateQuery(value);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.trim().toLowerCase();
    _viewModel.updateQuery(query);
    final results = _viewModel.results;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'البحث عن طبيب',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // Search Bar
            // =========================
            Container(
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                textDirection: TextDirection.rtl,
                textInputAction: TextInputAction.search,
                onChanged: (_) {
                  _viewModel.updateQuery(searchController.text);
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'ابحث عن دكتور أو تخصص',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            _viewModel.updateQuery('');
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 10,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // Recent Searches
            // =========================
            Row(
              children: [
                Icon(Icons.history_rounded, color: AppColors.primary, size: 21),
                const SizedBox(width: 8),
                Text(
                  'عمليات البحث الأخيرة',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: recentSearches.map((search) {
                return _SearchChip(
                  title: search,
                  icon: Icons.history_rounded,
                  onTap: () => _selectSearch(search),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // =========================
            // Popular Searches
            // =========================
            Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.primary,
                  size: 21,
                ),
                const SizedBox(width: 8),
                Text(
                  'عمليات البحث الشائعة',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: popularSearches.map((search) {
                return _SearchChip(
                  title: search,
                  icon: Icons.search_rounded,
                  onTap: () => _selectSearch(search),
                );
              }).toList(),
            ),

            const SizedBox(height: 70),

            // =========================
            // Empty State
            // =========================
            if (query.isEmpty) _buildSearchHint(),
            if (query.isNotEmpty && results.isEmpty)
              const EmptyStateWidget(
                title: 'مفيش نتائج',
                message: 'جرب تبحث باسم طبيب أو تخصص مختلف',
                icon: Icons.search_off_rounded,
              ),
            if (query.isNotEmpty && results.isNotEmpty) ...[
              SectionTitle('نتائج البحث (${results.length})'),
              const SizedBox(height: 14),
              ...results.map(
                (doctor) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DoctorCard(
                    name: doctor.name,
                    specialty: doctor.specialty,
                    rating: doctor.rating,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorDetailsScreen(
                          name: doctor.name,
                          specialty: doctor.specialty,
                          rating: doctor.rating,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =========================
  // Initial Search Hint
  // =========================
  Widget _buildSearchHint() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.medical_services_outlined,
            color: AppColors.primary.withValues(alpha: 0.6),
            size: 42,
          ),

          const SizedBox(height: 12),

          Text(
            'ابحث عن الطبيب المناسب ليك',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Search Chip
// ============================================================

class _SearchChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SearchChip({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17, color: AppColors.primary),

              const SizedBox(width: 7),

              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
