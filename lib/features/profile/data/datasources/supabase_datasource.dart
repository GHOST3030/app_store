// profile/data/datasources/profile_remote_datasource.dart
import 'package:new_auth/features/profile/data/datasources/i_profile_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import 'failures.dart';

class SupabaseDatasource implements IProfileDataSource {
  final SupabaseClient supabaseClient;

  SupabaseDatasource(this.supabaseClient);
  @override
  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final response = await supabaseClient
          .from('profile')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return ProfileModel.fromJson(response);
    } catch (e) {
      throw ('Failed to fetch profile: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel model) async {
    try {
      await supabaseClient.from('users').upsert(model.toJson());
    } catch (e) {
      throw ServerFailure('Failed to update profile: $e');
    }
  }
}
