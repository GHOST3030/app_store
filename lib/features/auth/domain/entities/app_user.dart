import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Defines an abstract representation of an authenticated user for the app.
class AppUser {
  final String id;
  final String? email;
  final String? username;
  final DateTime? createdAt;

  const AppUser({
    required this.id,
    this.email,
    this.username,
    this.createdAt,
  });

  /// Factory constructor to map a Supabase User object to our internal AppUser entity.
  factory AppUser.fromSupabase(supabase.User user) {
    // Determine the username.
    // If we passed it during sign up, it will be in user_metadata['username']
    final usernameRaw = user.userMetadata?['username'];
    final username = usernameRaw?.toString();

    return AppUser(
      id: user.id,
      email: user.email,
      username: username,
      createdAt: DateTime.tryParse(user.createdAt),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppUser &&
      other.id == id &&
      other.email == email &&
      other.username == username &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      username.hashCode ^
      createdAt.hashCode;
  }

  @override
  String toString() {
    return 'AppUser(id: $id, email: $email, username: $username, createdAt: $createdAt)';
  }
}