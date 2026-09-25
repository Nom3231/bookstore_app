import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/services/auth_service.dart';
import 'data/services/review_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/book_store_home_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().init();
  ReviewService();
  runApp(const BookStoreApp());
}

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return MaterialApp(
      title: 'Aptech Book Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: auth.isAuthenticated
          ? (auth.currentUser!.isAdmin
                ? AdminDashboardScreen(currentUser: auth.currentUser!)
                : BookStoreHomeScreen(currentUser: auth.currentUser!))
          : const LoginScreen(),
    );
  }
}
