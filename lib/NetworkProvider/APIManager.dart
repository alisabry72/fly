import 'dart:core';
import 'dart:io';

import 'package:fly_networking/Utils/logging_interceptor.dart';
import 'package:http_interceptor/http_interceptor.dart';

import '../Utils/request_inspector.dart';

class APIManager {
  late InterceptedClient _client;

  // Duration _timeout;
  // Function _timeoutFunc;
  Map<String, String> map = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json"
  };

  // APIManager({Map headerMap}){
  //   map.addAll(headerMap);
  // }

  void _setMiddleWares() {
    _client = InterceptedClient.build(
      interceptors: [
        LoggingInterceptor(),
        RequestInspector(),
      ],
    );
  }

  void setHeaders(Map<String, String> headers) {
    map.addAll(headers);
  }

  /// Remove multiple header keys from the current header map.
  /// Passing an empty or null list does nothing.
  void removeHeaders(List<String>? keys) {
    if (keys == null || keys.isEmpty) return;
    for (final key in keys) {
      map.remove(key);
    }
  }

  /// Remove a single header key.
  void removeHeader(String key) {
    map.remove(key);
  }

  Future<Response?> post(String apiPath, {required String body}) async {
    try {
      _setMiddleWares();

      Uri uri = Uri.parse(apiPath);
      if (uri.scheme == "https")
        uri = Uri.https(uri.authority, uri.path);
      else
        uri = Uri.http(uri.authority, uri.path);

      final response = await _client.post(uri, body: body, headers: map);
      return response;
    } catch (e) {
      print("i failed");
      print("post req Failed $e");
    }
    return null;
  }
}
