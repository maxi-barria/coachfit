class Environment {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://10.0.0.2', // localhost por defecto (Android emulator)
  );
}
