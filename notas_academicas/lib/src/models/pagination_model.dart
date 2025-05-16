import 'package:notas_academicas/src/models/student_model.dart';

class Sort {
  final bool empty;
  final bool sorted;
  final bool unsorted;

  Sort({
    required this.empty,
    required this.sorted,
    required this.unsorted,
  });

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      empty: json['empty'] ?? false,
      sorted: json['sorted'] ?? false,
      unsorted: json['unsorted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empty': empty,
      'sorted': sorted,
      'unsorted': unsorted,
    };
  }
}

class Pageable {
  final int offset;
  final Sort sort;
  final bool paged;
  final int pageSize;
  final int pageNumber;
  final bool unpaged;

  Pageable({
    required this.offset,
    required this.sort,
    required this.paged,
    required this.pageSize,
    required this.pageNumber,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      offset: json['offset'] ?? 0,
      sort: Sort.fromJson(json['sort'] ?? {}),
      paged: json['paged'] ?? false,
      pageSize: json['pageSize'] ?? 0,
      pageNumber: json['pageNumber'] ?? 0,
      unpaged: json['unpaged'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'sort': sort.toJson(),
      'paged': paged,
      'pageSize': pageSize,
      'pageNumber': pageNumber,
      'unpaged': unpaged,
    };
  }
}

class PaginatedResponse<T> {
  final int totalElements;
  final int totalPages;
  final int size;
  final List<T> content;
  final int number;
  final Sort sort;
  final bool first;
  final bool last;
  final int numberOfElements;
  final Pageable pageable;
  final bool empty;

  PaginatedResponse({
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.content,
    required this.number,
    required this.sort,
    required this.first,
    required this.last,
    required this.numberOfElements,
    required this.pageable,
    required this.empty,
  });

  // Factory constructor genérico
  static PaginatedResponse<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      size: json['size'] ?? 0,
      content: (json['content'] as List? ?? [])
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      number: json['number'] ?? 0,
      sort: Sort.fromJson(json['sort'] ?? {}),
      first: json['first'] ?? false,
      last: json['last'] ?? false,
      numberOfElements: json['numberOfElements'] ?? 0,
      pageable: Pageable.fromJson(json['pageable'] ?? {}),
      empty: json['empty'] ?? true,
    );
  }

  // Constructor específico para estudiantes
  static PaginatedResponse<Student> fromJsonStudent(Map<String, dynamic> json) {
    return fromJson(json, (studentJson) => Student.fromGetResponse(studentJson));
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'totalElements': totalElements,
      'totalPages': totalPages,
      'size': size,
      'content': content.map((item) => toJsonT(item)).toList(),
      'number': number,
      'sort': sort.toJson(),
      'first': first,
      'last': last,
      'numberOfElements': numberOfElements,
      'pageable': pageable.toJson(),
      'empty': empty,
    };
  }
}