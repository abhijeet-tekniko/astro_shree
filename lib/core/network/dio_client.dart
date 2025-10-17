import 'package:dio/dio.dart';
import '../utils/sharePrefs/prefsKeys.dart';
import '../utils/sharePrefs/prefsUtils.dart';

class DioClient {
  final Dio _dio;

  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://admin.astroshri.in',
          connectTimeout: const Duration(seconds: 25),
          receiveTimeout: const Duration(seconds: 25),
          sendTimeout: const Duration(seconds: 25),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefsUtils.getString(PrefsKeys.userToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print(
            '➡️ Request: ${options.method} ${options.baseUrl}${options.path}',
          );   print(
            '➡️ Token: $token',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.sendTimeout) {
            print('⏱️ Timeout error: ${e.message}');
          } else {
            if (e.type == DioExceptionType.connectionError ||
                e.type == DioExceptionType.unknown) {}
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get client => _dio;
}
