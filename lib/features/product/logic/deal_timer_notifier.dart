import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class DealTimerNotifier extends Notifier<Duration> {
  Timer? _timer;
  late DateTime _end;

  @override
  Duration build() {
    _end = DateTime.now().add(
      const Duration(hours: 22, minutes: 55, seconds: 20),
    );

    _startTicker();

    ref.onDispose(() => _timer?.cancel());

    return _remaining();
  }

  void resetTimer(Duration duration) {
    _timer?.cancel();
    _end = DateTime.now().add(duration);
    state = _remaining();
    _startTicker();
  }

  // ─── Private ──────────────────────────────────────────────────────────────

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = _remaining();
      state = left;
      if (left == Duration.zero) _timer?.cancel();
    });
  }

  Duration _remaining() {
    final d = _end.difference(DateTime.now());
    return d.isNegative ? Duration.zero : d;
  }
}

final dealTimerProvider =
    NotifierProvider<DealTimerNotifier, Duration>(DealTimerNotifier.new);
