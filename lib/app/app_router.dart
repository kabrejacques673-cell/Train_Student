import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../features/auth/presentation/screens/login_screen.dart";
import "../features/auth/presentation/screens/signup_screen.dart";
import "../features/auth/presentation/screens/role_selection_screen.dart";
import "../features/eleve/presentation/screens/eleve_home_screen.dart";
import "../features/etudiant/presentation/screens/etudiant_home_screen.dart";
import "../features/professionnel/presentation/screens/professionnel_home_screen.dart";

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: "/login",
    routes: [
      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
      GoRoute(path: "/signup", builder: (context, state) => const SignUpScreen()),
      GoRoute(path: "/role-selection", builder: (context, state) => const RoleSelectionScreen()),
      GoRoute(path: "/eleve/home", builder: (context, state) => const EleveHomeScreen()),
      GoRoute(path: "/etudiant/home", builder: (context, state) => const EtudiantHomePage()),
      GoRoute(path: "/pro/home", builder: (context, state) => const ProfessionnelHomeScreen()),
    ],
  );
});

