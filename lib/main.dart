import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router.dart';

// ============================================================================
// 1. Importez firebase_core et vos options générées.
// ============================================================================

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ============================================================================
// 2. Rendez la fonction main asynchrone pour pouvoir attendre l'initialisation.
// ============================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On récupère le router configuré dans router.dart
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      routerConfig: router,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}