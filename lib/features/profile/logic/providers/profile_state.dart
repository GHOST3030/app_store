
import 'package:new_auth/features/profile/logic/entities/profile_entity.dart';

class ProfileState {
  final ProfileEntity? profile;
  final bool isLoading;
  final String? error;
  final bool isSaving;

  ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
    this.isSaving = false,
  });

  ProfileState copyWith({
    ProfileEntity? profile,
    bool? isLoading,
    String? error,
    bool? isSaving,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
