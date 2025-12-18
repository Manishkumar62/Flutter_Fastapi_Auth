import '../storage/token_storage.dart';
import 'api_client.dart';
import 'api_exception.dart';

class AuthInterceptor {
  final TokenStorage tokenStorage;
  final ApiClient apiClient;

  Future<String?>? _refreshing;

  AuthInterceptor({
    required this.tokenStorage,
    required this.apiClient,
  });

  /// Adds Authorization header
  Future<Map<String, String>> attachAuthHeader(
    Map<String, String>? headers,
  ) async {
    final accessToken = await tokenStorage.readAccessToken();

    if (accessToken == null) return headers ?? {};

    return {
      'Authorization': 'Bearer $accessToken',
      ...?headers,
    };
  }

  /// Handles 401 by refreshing token (single-flight)
  Future<void> handle401() async {
    _refreshing ??= _refreshToken();
    await _refreshing;
    _refreshing = null;
  }

  Future<String> _refreshToken() async {
    final refreshToken = await tokenStorage.readRefreshToken();

    if (refreshToken == null) {
      throw Exception('No refresh token');
    }

    final response = await apiClient.post(
      '/auth/refresh',
      body: {
        'refresh_token': refreshToken,
      },
    );

    await tokenStorage.saveTokens(
      accessToken: response['access_token'],
      refreshToken: response['refresh_token'],
    );

    return response['access_token'];
  }
}
