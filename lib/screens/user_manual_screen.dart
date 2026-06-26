import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../data/user_manual_content.dart';
import '../theme/app_colors.dart';

class UserManualScreen extends StatefulWidget {
  const UserManualScreen({super.key});

  @override
  State<UserManualScreen> createState() => _UserManualScreenState();
}

class _UserManualScreenState extends State<UserManualScreen> {
  late final List<String> _sections;
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Split the markdown content into sections using the horizontal rule '---' separator
    _sections = userManualMarkdown
        .split(RegExp(r'\n---\n'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page >= 0 && page < _sections.length) {
      setState(() {
        _currentPage = page;
      });
      // Scroll back to top on page change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kpColor = AppColors.of(context, 'kp');
    final surfaceColor = AppColors.of(context, 'surface');

    // Extract title from section or default if none found
    String pageContent = _sections[_currentPage];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Player Manual"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "Page ${_currentPage + 1} of ${_sections.length}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kpColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Content Area
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                child: MarkdownBody(
                  data: pageContent,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                    p: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    h1: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kpColor,
                    ),
                    h2: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kpColor,
                    ),
                    h3: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kpColor,
                    ),
                    tableBorder: TableBorder.all(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      width: 1.5,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    tableColumnWidth: const IntrinsicColumnWidth(),
                    tableCellsPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    tableBody: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                    ),
                    tableHead: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kpColor,
                    ),
                    tableHeadAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          // Navigation Panel
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _currentPage > 0
                        ? () => _goToPage(_currentPage - 1)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Previous"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      _sections.length,
                      (index) => GestureDetector(
                        onTap: () => _goToPage(index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? kpColor
                                : theme.colorScheme.outline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final isLastPage = _currentPage == _sections.length - 1;
                      return ElevatedButton.icon(
                        onPressed: isLastPage
                            ? () => Navigator.of(context).pop()
                            : () => _goToPage(_currentPage + 1),
                        icon: Icon(isLastPage ? Icons.check : Icons.arrow_forward),
                        label: Text(isLastPage ? "Finish" : "Next"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLastPage ? kpColor : null,
                          foregroundColor: isLastPage
                              ? theme.colorScheme.onPrimary
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
