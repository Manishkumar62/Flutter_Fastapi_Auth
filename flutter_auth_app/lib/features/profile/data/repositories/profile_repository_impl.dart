import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;
  final ProfileLocalDataSource local;

  ProfileRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<ProfileEntity> getProfile() async {
    try {
      final profile = await remote.getProfile();
      await local.cacheProfile(profile);
      return profile;
    } catch (_) {
      final cached = await local.getCachedProfile();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }
}
