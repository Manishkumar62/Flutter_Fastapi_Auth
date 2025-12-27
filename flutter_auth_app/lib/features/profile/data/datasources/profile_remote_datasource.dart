import '../../../../core/network/api_client.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSource(this.apiClient);

  Future<ProfileModel> getProfile() async {
    print('ProfileRemoteDataSource: getProfile called');
    final response = await apiClient.get('/auth/me');
    print('ProfileRemoteDataSource: response received: $response');
    return ProfileModel.fromJson(response);
  }
}
