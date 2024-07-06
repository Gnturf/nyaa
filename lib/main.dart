import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nyaa/pages/login_page.dart';
import 'package:nyaa/services/auth_service.dart';
import 'package:nyaa/services/navigation_service.dart';
import 'package:nyaa/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();

  runApp(App());
}

class App extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthService _authService;

  App({
    super.key,
  }) {
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorKey,
      title: 'Nyaa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: _navigationService.routes,
      initialRoute: _authService.user != null ? "/home" : "/login",
    );
  }
}
