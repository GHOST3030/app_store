import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/entities/app_user.dart';
import '../../features/auth/logic/providers_auth.dart';

/// Notifier that triggers a GoRouter redirect whenever the authentication state changes.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<AppUser?>>(
      authControllerProvider,
      (previous, next) => notifyListeners(), // Using __ is fine, but some lints prefer it removed if possible.
    );
  }
}

/// Provider for the RouterNotifier
final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});
