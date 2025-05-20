import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado genérico de una consulta
class QueryState<T> {
  final bool isLoading;
  final T? data;
  final String? error;

  QueryState({
    required this.isLoading,
    this.data,
    this.error,
  });

  factory QueryState.initial() => QueryState(isLoading: false, data: null, error: null);
}

/// Notificador genérico que ejecuta una función async y actualiza el estado
class QueryNotifier<T> extends StateNotifier<QueryState<T>> {
  QueryNotifier() : super(QueryState<T>.initial());

  /// Ejecuta [fetchFunction] y actualiza [state] con loading/data/error
  Future<void> fetchData(Future<T> Function() fetchFunction) async {
    // Verificar si el notificador sigue montado
    if (!mounted) return;
    
    // Mantener el data actual mientras carga para no perder información previa
    state = QueryState<T>(isLoading: true, data: state.data, error: null);
    
    try {
      final result = await fetchFunction();
      
      // Verificar nuevamente si el notificador sigue montado después de la operación asíncrona
      if (!mounted) return;
      
      state = QueryState<T>(isLoading: false, data: result, error: null);
    } catch (e) {
      // Verificar si el notificador sigue montado
      if (!mounted) return;
      
      state = QueryState<T>(isLoading: false, data: state.data, error: e.toString());
    }
  }
}

/// Provider genérico para consultas parametrizadas
StateNotifierProviderFamily<QueryNotifier<T>, QueryState<T>, String> queryProviderFamily<T>() =>
    StateNotifierProvider.family<QueryNotifier<T>, QueryState<T>, String>(
      (ref, key) => QueryNotifier<T>(),
    );