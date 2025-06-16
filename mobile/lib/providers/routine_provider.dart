import 'package:flutter/material.dart';
import 'package:mobile/models/routine.dart';
import 'package:mobile/services/routine/routine_service.dart';

class RoutineProvider extends ChangeNotifier {
  final RoutineService _routineService = RoutineService();
  List<Routine> _routines = [];
  Routine? _selectedRoutine;
  bool _isLoading = false;
  String? _error;

  List<Routine> get routines => _routines;
  Routine? get selectedRoutine => _selectedRoutine;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRoutines() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _routines = await _routineService.getRoutines();
      print(_routines);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRoutineById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedRoutine = await _routineService.getRoutineById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createRoutine(Routine routine) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newRoutine = await _routineService.createRoutine(routine);
      _routines.add(newRoutine);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRoutine(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedRoutine = await _routineService.updateRoutine(id, data);
      final index = _routines.indexWhere((routine) => routine.id == id);
      if (index != -1) {
        _routines[index] = updatedRoutine;
      }
      if (_selectedRoutine?.id == id) {
        _selectedRoutine = updatedRoutine;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRoutine(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _routineService.deleteRoutine(id);
      _routines.removeWhere((routine) => routine.id == id);
      if (_selectedRoutine?.id == id) {
        _selectedRoutine = null;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}