import 'dart:convert';

import 'package:fly_networking/http_middleware/http_methods.dart';

class RequestData {
  Method method;
  String url;
  Map<String, String>? headers;
  dynamic body;
  Encoding? encoding;

  RequestData({
    required this.method,
    required this.url,
    this.headers,
    this.body,
    this.encoding,
  });
}
