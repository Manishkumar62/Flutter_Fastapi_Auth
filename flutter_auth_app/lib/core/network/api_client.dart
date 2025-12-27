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

  // -----------------------
  // GET REQUEST (NO BODY)
  // -----------------------
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    final authHeaders = await _auth?.attachAuthHeader(headers);
    final uri = Uri.parse('${AppConfig.baseUrl}$path');
    print('Making GET request to $uri with headers: $authHeaders');

    http.Response response = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json', ...?authHeaders},
    );

    print('Received response with status code: ${response.statusCode}');
    if (response.statusCode == 401 && _auth != null) {
      await _auth!.handle401();

      final retryHeaders = await _auth!.attachAuthHeader(headers);
      print('Retrying GET request to $uri with headers: $retryHeaders');

      response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json', ...?retryHeaders},
      );
      print('Received retried response with status code: ${response.statusCode}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // -----------------------
  // POST REQUEST (HAS BODY)
  // -----------------------
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final authHeaders = await _auth?.attachAuthHeader(headers);
    final uri = Uri.parse('${AppConfig.baseUrl}$path');
    print('Making POST request to $uri with headers: $authHeaders');

    http.Response response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json', ...?authHeaders},
      body: body != null ? jsonEncode(body) : null,
    );
    print('Received response with status code: ${response.statusCode}');

    if (response.statusCode == 401 && _auth != null) {
      await _auth!.handle401();

      final retryHeaders = await _auth!.attachAuthHeader(headers);
      print('Retrying POST request to $uri with headers: $retryHeaders');
      response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json', ...?retryHeaders},
        body: body != null ? jsonEncode(body) : null,
      );
      print('Received retried response with status code: ${response.statusCode}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }
}
