import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';

class ApiClient {
  final http.Client _client;
  AuthInterceptor? _auth;

  ApiClient(this._client);

  void setAuthInterceptor(AuthInterceptor auth) {
    _auth = auth;
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _send(() => _client.post, path, body: body, headers: headers);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    return _send(() => _client.get, path, headers: headers);
  }

  Future<Map<String, dynamic>> _send(
    Function method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final authHeaders = await _auth?.attachAuthHeader(headers);

    http.Response response = await method()(
      Uri.parse('${AppConfig.baseUrl}$path'),
      headers: {'Content-Type': 'application/json', ...?authHeaders},
      body: body != null ? jsonEncode(body) : null,
    );

    if (response.statusCode == 401 && _auth != null) {
      await _auth!.handle401();

      final retryHeaders = await _auth!.attachAuthHeader(headers);

      response = await method()(
        Uri.parse('${AppConfig.baseUrl}$path'),
        headers: {'Content-Type': 'application/json', ...?retryHeaders},
        body: body != null ? jsonEncode(body) : null,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
