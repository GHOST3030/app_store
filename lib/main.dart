import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling async methods
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cnadpulygnkclpynbwky.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNuYWRwdWx5Z25rY2xweW5id2t5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk1MzgxMjcsImV4cCI6MjA4NTExNDEyN30.5cRucS1Q-xZOofOBEk6fIf5pR_Hb4vvkXMBs0OA9bY8',
    authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce),
  );

  // Wrap the entire app in a ProviderScope to enable Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the GoRouter configuration provided by Riverpod
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: ' Store App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Delegate routing to GoRouter
      routerConfig: router,
    );
  }
}
