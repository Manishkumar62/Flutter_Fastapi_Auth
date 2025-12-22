import '../../../../core/network/api_client.dart';
import '../models/token_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<TokenModel> login(
    String username,
    String password,
  ) async {
    print('Calling login API...');
    final response = await apiClient.post(
      '/auth/login',
      body: {
        'username': username,
        'password': password,
      },
    );
    print('Login response: $response');

    return TokenModel.fromJson(response);
  }
}
