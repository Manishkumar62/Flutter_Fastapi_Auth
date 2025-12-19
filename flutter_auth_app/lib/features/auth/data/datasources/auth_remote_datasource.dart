import '../../../../core/network/api_client.dart';
import '../models/token_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<TokenModel> login(
    String username,
    String password,
  ) async {
    final response = await apiClient.post(
      '/auth/login',
      body: {
        'username': username,
        'password': password,
      },
    );

    return TokenModel.fromJson(response);
  }
}
