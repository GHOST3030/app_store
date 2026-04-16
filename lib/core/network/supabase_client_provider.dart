import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
//current user id provider
final currentUserIdProvider = Provider<String>((ref) {
  return ref.watch(supabaseClientProvider).auth.currentUser?.id ?? '';
});