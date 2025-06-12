import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/env/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String email;
  final String rol;

  User({required this.id, required this.email, required this.rol});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      rol: json['rol'],
    );
  }
}

class LogginProvider extends ChangeNotifier {
  // URL base del backend
  final String _baseUrl = Environment.apiUrl;
  
  // Estado de autenticación
  bool _isAuthenticated = false;
  String? _token;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;
  String? get token => _token;

  // Constructor - Intenta cargar la sesión guardada
  LogginProvider() {
    _loadSavedSession();
  }

  // Cargar sesión guardada en SharedPreferences
  Future<void> _loadSavedSession() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('token');
      final savedUserJson = prefs.getString('user');

      if (savedToken != null && savedUserJson != null) {
        _token = savedToken;
        _currentUser = User.fromJson(json.decode(savedUserJson));
        _isAuthenticated = true;
      }
    } catch (e) {
      _setError('Error al cargar la sesión guardada');
    } finally {
      _setLoading(false);
    }
  }

  // Guardar sesión en SharedPreferences
  Future<void> _saveSession(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', json.encode({
      'id': user.id,
      'email': user.email,
      'rol': user.rol,
    }));
  }

  // Iniciar sesión
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        _currentUser = User.fromJson(data['user']);
        _isAuthenticated = true;
        await _saveSession(_token!, _currentUser!);
        notifyListeners();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _setError(errorData['message'] ?? 'Error al iniciar sesión');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión. Intenta nuevamente.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Registrar usuario
  Future<bool> register(String email, String password, String confirmPassword, String rol) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'rol': rol,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _token = data['token'];
        _currentUser = User.fromJson(data['user']);
        _isAuthenticated = true;
        await _saveSession(_token!, _currentUser!);
        notifyListeners();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _setError(errorData['message'] ?? 'Error al registrar usuario');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión. Intenta nuevamente.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');
      
      _token = null;
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _setError('Error al cerrar sesión');
    } finally {
      _setLoading(false);
    }
  }

  // Solicitar restablecimiento de contraseña
  Future<bool> requestPasswordReset(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/request-reset'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        _setError(errorData['message'] ?? 'Error al solicitar restablecimiento');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión. Intenta nuevamente.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Restablecer contraseña
  Future<bool> resetPassword(String token, String password, String confirmPassword) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': token,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        _setError(errorData['message'] ?? 'Error al restablecer contraseña');
        return false;
      }
    } catch (e) {
      _setError('Error de conexión. Intenta nuevamente.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Obtener headers con autorización para peticiones protegidas
  Map<String, String> getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };
  }

  // Helpers para manejar estados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}