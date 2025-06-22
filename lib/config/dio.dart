import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Dio dio = Dio()
  ..options.baseUrl = dotenv.env['BASE_API_URL']!
  ..options.headers['ngrok-skip-browser-warning'] = 'true'
  ..options.connectTimeout = const Duration(seconds: 15)
  ..options.receiveTimeout = const Duration(seconds: 15)
  ..interceptors.add(interceptorsWrapper);

InterceptorsWrapper interceptorsWrapper = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    print(options.baseUrl+options.path);
    return handler.next(options);
  },
  onError: (e, handler) {
    print(e.message);
    return handler.next(e);
  }
);