import '../models/profile_model.dart';

class ProfileLocalDataSource {
  ProfileModel? _cache;

  Future<void> cacheProfile(ProfileModel profile) async {
    _cache = profile;
  }

  Future<ProfileModel?> getCachedProfile() async {
    return _cache;
  }
}
