import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/features/profile/logic/entities/profile_entity.dart';
import 'package:new_auth/features/profile/logic/providers/profile_providers.dart';
import 'package:new_auth/features/profile/logic/providers/profile_state.dart';
import 'package:new_auth/features/profile/logic/repositories/profile_repository.dart';
import 'package:new_auth/features/profile/data/datasources/failures.dart';

class ProfileNotifier extends Notifier<ProfileState> {
  late final ProfileRepository _repository;
  late final String _userId;

  @override
  ProfileState build() {
    _repository = ref.watch(profileRepositoryProvider);
    _userId = ref.watch(currentUserId);
    // Use Future.microtask to avoid modifying state during the build phase
    Future.microtask(() => fetchProfile());
    return ProfileState();
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _repository.getProfile(_userId);
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      //log("error: ${e}");
      state = state.copyWith(
        isLoading: false,
        error: e is Failure ? e.message : e.toString(),
      );
    }
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      await _repository.updateProfile(profile);
      state = state.copyWith(profile: profile, isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e is Failure ? e.message : e.toString(),
      );
    }
  }
}
