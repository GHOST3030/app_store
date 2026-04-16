// profile/logic/providers/profile_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/network/supabase_client_provider.dart';
import 'package:new_auth/features/profile/data/datasources/i_profile_datasource.dart';
import 'package:new_auth/features/profile/logic/providers/profile_notifier.dart';
import 'package:new_auth/features/profile/logic/providers/profile_state.dart';
import '../../data/datasources/supabase_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../logic/repositories/profile_repository.dart';

// final supabaseClientProvider = Provider<SupabaseClient>((ref) {
//   return Supabase.instance.client;
// });

final profileRemoteDataSourceProvider = Provider<IProfileDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return SupabaseDatasource(supabaseClient);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(remoteDataSource);
});

final currentUserId = Provider<String>((ref) {
  return ref.watch(currentUserIdProvider);
});

final profileNotifierProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  () => ProfileNotifier(),
);