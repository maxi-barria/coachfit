import 'package:flutter/material.dart';
import 'package:mobile/models/routine.dart';
import 'package:mobile/services/routine/routine_service.dart';

class RoutineProvider extends ChangeNotifier {
  /* --------------------- servicio --------------------- */
  final RoutineService _service = RoutineService();

  /* --------------------- estado ---------------------- */
  List<Routine> _routines = [];
  Routine? _selectedRoutine;
  bool _isLoading = false;
  String? _error;

  List<Routine> get routines => _routines;
  Routine? get selectedRoutine => _selectedRoutine;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /* --------------------- helpers --------------------- */
  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  /* =================== RUTINAS ======================= */
  Future<void> fetchRoutines() async {
    _setLoading(true);
    _error = null;
    try {
      _routines = await _service.getRoutines();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchRoutineById(String id) async {
    _setLoading(true);
    _error = null;
    try {
      _selectedRoutine = await _service.getRoutineById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// ✅ Ahora retorna la rutina creada
  Future<Routine?> createRoutine(Map<String, dynamic> data) async {
    _setLoading(true);
    _error = null;
    try {
      final newRoutine = await _service.createRoutine(data);
      _routines.add(newRoutine);
      return newRoutine;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateRoutine(String id, Map<String, dynamic> data) async {
    _setLoading(true);
    _error = null;
    try {
      final updated = await _service.updateRoutine(id, data);
      final i = _routines.indexWhere((r) => r.id == id);
      if (i != -1) _routines[i] = updated;
      if (_selectedRoutine?.id == id) _selectedRoutine = updated;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteRoutine(String id) async {
    _setLoading(true);
    _error = null;
    try {
      await _service.deleteRoutine(id);
      _routines.removeWhere((r) => r.id == id);
      if (_selectedRoutine?.id == id) _selectedRoutine = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /* ============ NUEVO: agregar ejercicio a workout ============ */
  Future<bool> addExerciseToWorkout(
    String workoutId,
    Map<String, dynamic> payload,
  ) async {
    _setLoading(true);
    _error = null;
    try {
      await _service.addExerciseToWorkout(workoutId, payload);

      // refresca la rutina activa
      if (_selectedRoutine != null) {
        await fetchRoutineById(_selectedRoutine!.id);
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
