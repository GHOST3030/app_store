// profile/data/datasources/profile_remote_datasource.dart
import '../models/profile_model.dart';

abstract class IProfileDataSource {
  Future<ProfileModel?> getProfile(String userId);

  Future<void> updateProfile(ProfileModel model);
}
