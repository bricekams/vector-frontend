import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Dio dio = Dio()
  ..options.baseUrl = dotenv.env['BASE_API_URL']!
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