import 'package:dio/dio.dart';

class BackendApiClient {
  final Dio dio;

  BackendApiClient(String baseUrl)
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ));

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(String path,
      {Object? data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.post<T>(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> put<T>(String path,
      {Object? data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.put<T>(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> patch<T>(String path,
      {Object? data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.patch<T>(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> delete<T>(String path,
      {Object? data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.delete<T>(path,
        data: data, queryParameters: queryParameters, options: options);
  }
}
