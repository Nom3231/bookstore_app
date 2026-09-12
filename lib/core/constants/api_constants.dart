class ApiConstants {
  ApiConstants._();

  // Local Spring Boot backend endpoints
  // Default to localhost for web/desktop; 10.0.2.2 for Android emulator
  static const String baseUrl = 'http://localhost:8080/api/v1';
  static const String emulatorBaseUrl = 'http://10.0.2.2:8080/api/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String currentUser = '/auth/me';

  // Catalog & Books endpoints (ready for backend)
  static const String books = '/books';
  static const String genres = '/genres';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String reviews = '/reviews';
  static const String wishlist = '/wishlist';

  static const Duration timeout = Duration(seconds: 10);
}
