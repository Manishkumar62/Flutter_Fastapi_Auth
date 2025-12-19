import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remote,
    required this.tokenStorage,
  });

  @override
  Future<TokenEntity> login({
    required String username,
    required String password,
  }) async {
    final token = await remote.login(username, password);

    await tokenStorage.saveTokens(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
    );

    return token;
  }
}
