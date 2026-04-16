// profile/data/repositories/profile_repository_impl.dart
import 'package:new_auth/features/profile/data/datasources/i_profile_datasource.dart';

import '../../logic/entities/profile_entity.dart';
import '../../logic/repositories/profile_repository.dart';
import '../models/profile_model.dart';
import '../datasources/failures.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final IProfileDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileEntity?> getProfile(String userId) async {
    try {
      final model = await remoteDataSource.getProfile(userId);
      return model?.toEntity();
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw UnknownFailure('Unexpected error: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      final model = ProfileModel(
        id: profile.id,
        email: profile.email,
        password: profile.password,
        address: profile.address,
        city: profile.city,
        country: profile.country,
        pincode: profile.pincode,
        bankAccountNumber: profile.bankAccountNumber,
        accountHolderName: profile.accountHolderName,
        ifscCode: profile.ifscCode,
        createdAt: profile.createdAt,
      );
      await remoteDataSource.updateProfile(model);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw UnknownFailure('Unexpected error: $e');
    }
  }
}