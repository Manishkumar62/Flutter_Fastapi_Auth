import '../entities/token_entity.dart';

abstract class AuthRepository {
  Future<TokenEntity> login({
    required String username,
    required String password,
  });
}
