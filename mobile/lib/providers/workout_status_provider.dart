// lib/providers/workout_status_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/models/workout.dart';

class WorkoutStatusProvider extends ChangeNotifier with WidgetsBindingObserver {
  Workout? _activeWorkout;
  DateTime? _start;
  int  _elapsed = 0;
  bool _minimized = false;
  Timer? _ticker;

  /* getters */
  Workout? get activeWorkout => _activeWorkout;
  bool     get isMinimized   => _minimized;
  int      get elapsedSecs   => _elapsed;

  WorkoutStatusProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    super.dispose();
  }

  /* ───────── app lifecycle ───────── */
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_activeWorkout == null) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _ticker?.cancel();                     // ahorra batería
    } else if (state == AppLifecycleState.resumed) {
      _elapsed = DateTime.now().difference(_start!).inSeconds;
      _startTicker();
    }
  }

  /* ───────── acciones del usuario ───────── */
  void startWorkout(Workout w) {
    _activeWorkout = w;
    _minimized     = false;
    _start         = DateTime.now();
    _elapsed       = 0;
    _startTicker();
    notifyListeners();
  }

  void minimizeWorkout()   { _minimized = true;  notifyListeners(); }
  void resumeWorkout()     { _minimized = false; notifyListeners(); }
  void endWorkout() {
    _ticker?.cancel();
    _ticker       = null;
    _activeWorkout = null;
    _minimized     = false;
    _elapsed       = 0;
    _start         = null;
    notifyListeners();
  }

  /* ───────── util ───────── */
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed = DateTime.now().difference(_start!).inSeconds;
      notifyListeners();
    });
  }
}
