import 'dart:async';

import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    print(request.toString());
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    print(response.toString());
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    // TODO: implement shouldInterceptRequest
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    // TODO: implement shouldInterceptResponse
    throw UnimplementedError();
  }
}
