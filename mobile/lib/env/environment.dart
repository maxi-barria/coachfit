class Environment {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://coachfit-backend.onrender.com', // localhost por defecto (Android emulator)
  );
}
