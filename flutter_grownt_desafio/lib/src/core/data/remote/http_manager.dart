import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

abstract class HttpMethods {
  static const String post = 'POST';
  static const String get = 'GET';
  static const String put = 'PUT';
  static const String delete = 'DELETE';
  static const String patch = 'PATCH';
}

class HttpManager {
  Future<Response> restRequest({
    required String url,
    required String method,
    Map? headers,
    Map body = const {},
    Map<String, dynamic>? parameters,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });

    Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client = HttpClient(
          context: SecurityContext(withTrustedRoots: false),
        );
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return client;
      },
    );

    try {
      Response response = await dio.request(
        url,
        options: Options(headers: defaultHeaders, method: method),
        data: body,
        queryParameters: parameters,
      );

      return response;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return Response(
          requestOptions: RequestOptions(),
          statusCode: 408,
          statusMessage: error.message,
        );
      } else if (error.response != null) {
        return error.response!;
      } else {
        rethrow;
      }
    }
  }
}
