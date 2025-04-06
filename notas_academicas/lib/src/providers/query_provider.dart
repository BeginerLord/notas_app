import 'package:flutter_riverpod/flutter_riverpod.dart';

final queryProvider = StateNotifierProvider<QueryNotifier, QueryState>((ref) {
  return QueryNotifier();
});

class QueryState {
  final bool isLoading;
  final dynamic data;
  final String? error;

  QueryState({
    required this.isLoading,
    this.data,
    this.error,
  });

  factory QueryState.initial() {
    return QueryState(isLoading: false, data: null, error: null);
  }
}

class QueryNotifier extends StateNotifier<QueryState> {
  QueryNotifier() : super(QueryState.initial());

  Future<void> fetchData(Future<dynamic> Function() fetchFunction) async {
    state = QueryState(isLoading: true, data: null, error: null);
    try {
      final data = await fetchFunction();
      state = QueryState(isLoading: false, data: data, error: null);
    } catch (e) {
      state = QueryState(isLoading: false, data: null, error: e.toString());
    }
  }
}