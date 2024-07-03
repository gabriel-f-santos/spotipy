import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/viewmodel/auth_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/view/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  await container.read(authViewModelProvider.notifier).getData();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotipy',
      theme: AppTheme.darkThemeMode,
      home: const SigninPage(),
    );
  }
}
