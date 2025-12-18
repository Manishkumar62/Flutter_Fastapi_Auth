import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'core/network/auth_interceptor.dart';
import 'core/storage/token_storage.dart';

void main() {
  final tokenStorage = TokenStorage();
  final apiClient = ApiClient(http.Client());
  final authInterceptor = AuthInterceptor(
    tokenStorage: tokenStorage,
    apiClient: apiClient,
  );

  apiClient.setAuthInterceptor(authInterceptor);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Auth Foundation Ready'))),
    );
  }
}