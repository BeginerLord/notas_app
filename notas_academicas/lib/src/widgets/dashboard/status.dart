import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final bool isEmpty;
  final VoidCallback onRetry;

  const Status({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.isEmpty,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
    }
    if (errorMessage != null) {
      return Center(
        child: Column(
          children: [
            Text('Error: $errorMessage', style: const TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    if (isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No hay profesores disponibles')));
    }
    return const SizedBox.shrink();
  }
}
