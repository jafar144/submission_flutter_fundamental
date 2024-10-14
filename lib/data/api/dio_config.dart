import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum DioMethod { post, get }

class DioConfig {
  static DioConfig? _instance;

  DioConfig._();

  factory DioConfig() => _instance ??= DioConfig._();

  // Mencoba membedakan url dev sama production
  String get baseUrl {
    if (kDebugMode) {
      return 'https://restaurant-api.dicoding.dev/';
    }
    return 'https://restaurant-api.dicoding.dev/';
  }

  Future<Response> request(
    String endpoint,
    DioMethod method, {
    Map<String, dynamic>? param,
    String? contentType,
    formData,
  }) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        contentType: contentType ?? Headers.formUrlEncodedContentType,
      ));
      switch (method) {
        case DioMethod.post:
          return dio.post(
            endpoint,
            data: param ?? formData,
          );
        case DioMethod.get:
          return dio.get(
            endpoint,
            queryParameters: param,
          );
      }
    } catch (e) {
      throw Exception('Network Error');
    }
  }
}
