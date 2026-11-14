import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:supabase_flutter/supabase_flutter.dart" show AuthException;
import "../../../../core/services/supabase_service.dart";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  void _message(String texte, {bool erreur = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texte), backgroundColor: erreur ? Colors.red : Colors.green),
    );
  }

  Future<void> _sInscrire() async {
    final nom = nomController.text.trim();
    final prenom = prenomController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (nom.isEmpty || prenom.isEmpty || email.isEmpty || password.isEmpty) {
      _message("Remplis tous les champs obligatoires");
      return;
    }
    if (password.length < 6) {
      _message("Le mot de passe doit contenir au moins 8 caracteres");
      return;
    }
    if (password != confirmPasswordController.text) {
      _message("Les mots de passe ne correspondent pas");
      return;
    }

    setState(() => isLoading = true);
    try {
      final res = await SupabaseService.signUp(email, password);
      final user = res.user;
      if (user != null) {
        await SupabaseService.creerProfilUtilisateur(
          userId: user.id,
          email: email,
          nom: "$prenom $nom",
        );
      }
      if (!mounted) return;
      if (res.session == null) {
        _message("Compte cree. Verifie ton email puis connecte-toi.", erreur: false);
        context.go("/login");
      } else {
        context.go("/role-selection");
      }
    } on AuthException catch (e) {
      _message(e.message);
    } catch (e) {
      _message("Erreur d inscription : $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _champ(TextEditingController controller, String hint, IconData icon, {bool motDePasse = false, TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: motDePasse,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.black87,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIconColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go("/login"),
        ),
        title: const Text("Creer votre compte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Rejoins Train_Student", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("3 jours d essai gratuit vous attendent", style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 32),
              _champ(nomController, "Votre nom", Icons.person_outlined),
              _champ(prenomController, "Votre prenom", Icons.person_outlined),
              _champ(emailController, "exemple@email.com", Icons.email_outlined, type: TextInputType.emailAddress),
              _champ(phoneController, "+226 07X XXX XXX (facultatif)", Icons.phone_outlined, type: TextInputType.phone),
              _champ(passwordController, "Mot de passe (8 caracteres min.)", Icons.lock_outlined, motDePasse: true),
              _champ(confirmPasswordController, "Confirmer le mot de passe", Icons.lock_outlined, motDePasse: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _sInscrire,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("S inscrire", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
