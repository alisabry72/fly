import 'dart:async';

import 'package:graphql_parser2/graphql_parser2.dart';
import 'package:http_interceptor/http_interceptor.dart';

class RequestInspector implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    return response;
  }

  String? formatGraphQLQuery(String requestBody) {
    var tokens = scan(requestBody);
    var parser = Parser(tokens);
    if (parser.errors.isNotEmpty) {
      return requestBody;
    }
    var doc = parser.parseDocument();
    doc.span?.text.replaceAll("}", "\n}\n");
    doc.span?.text.replaceAll("{", "\n{\n");
    return doc.span?.text;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
  }
}
