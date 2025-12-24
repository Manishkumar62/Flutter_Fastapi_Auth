import '../../../../core/storage/token_storage.dart';

class CheckAuthStatusUseCase {
  final TokenStorage tokenStorage;

  CheckAuthStatusUseCase(this.tokenStorage);

  Future<bool> call() async {
    final accessToken = await tokenStorage.readAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}
