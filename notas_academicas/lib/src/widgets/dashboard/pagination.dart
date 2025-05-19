import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool isLoadingMore;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onLoadMore;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onPageChanged,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (totalPages > 1)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
                ),
                Text('Página ${currentPage + 1} de $totalPages', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: currentPage < totalPages - 1 ? () => onPageChanged(currentPage + 1) : null,
                ),
              ],
            ),
          ),
        if (hasMore && !isLoadingMore)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(onPressed: onLoadMore, child: const Text('Cargar Más')),
          ),
        if (isLoadingMore)
          const Padding(padding: EdgeInsets.all(10), child: Center(child: CircularProgressIndicator())),
      ],
    );
  }
}