import 'dart:async';
import 'dart:convert';

import 'package:fly_networking/http_middleware/models/response_data.dart';
import 'package:graphql_parser2/graphql_parser2.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:requests_inspector/requests_inspector.dart';

class RequestInspector implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse(
      {required BaseResponse response}) async {
    final data = response as ResponseData;
    final requestBody = jsonDecode(data.body) as Map<String, dynamic>;
    String methodType = "";
    if (requestBody.containsKey('query')) {
      methodType = "Query";
      if (requestBody['query'].length > 2000)
        requestBody['query'] = {};
      else
        requestBody['query'] = formatGraphQLQuery(requestBody['query']);
    } else if (requestBody.containsKey('mutation')) {
      methodType = "Mutation";
      if (requestBody['mutation'].length > 2000)
        requestBody['mutation'] = {};
      else
        requestBody['mutation'] = formatGraphQLQuery(requestBody['mutation']);
    }

    InspectorController().addNewRequest(
      RequestDetails(
        requestName: methodType,
        requestMethod: RequestMethod.POST,
        requestBody: requestBody,
        url: data.url,
        queryParameters: "",
        statusCode: data.statusCode,
        responseBody: jsonDecode(data.body),
      ),
    );
    return data as BaseResponse;
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
