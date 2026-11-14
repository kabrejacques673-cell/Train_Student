import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "app/app_router.dart";
import "core/services/supabase_service.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
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
    final appRouter = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: "Train_Student",
      theme: ThemeData(useMaterial3: true),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
