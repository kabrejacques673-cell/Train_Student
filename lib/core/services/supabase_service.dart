import "dart:typed_data";
import "package:supabase_flutter/supabase_flutter.dart";

class SupabaseService {
  static const String supabaseUrl = "https://thrpdhrnfhgufhzjrosj.supabase.co";
  static const String supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRocnBkaHJuZmhndWZoempyb3NqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTEzNjA1MjIsImV4cCI6MjEwNjkzNjUyMn0.L4qL7LBe1AYEja4EZO6lw3WPIy4-fNrbNDa8QyuOQXc";

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  // ============ AUTH ============
  static Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  static Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;

  // ============ USERS ============
  static Future<void> creerProfilUtilisateur({
    required String userId,
    required String email,
    required String nom,
    String? role,
  }) async {
    await client.from("users").insert({
      "id": userId,
      "email": email,
      "nom": nom,
      "role": role,
    });
  }

  static Future<Map<String, dynamic>?> getProfilUtilisateur(String userId) async {
    final response = await client.from("users").select().eq("id", userId).maybeSingle();
    return response;
  }

  // ============ CV ETUDIANT ============
  static Future<void> sauvegarderCvEtudiant(String userId, Map<String, dynamic> data) async {
    await client.from("cv_etudiant").upsert({
      "user_id": userId,
      ...data,
    });
  }

  static Future<Map<String, dynamic>?> getCvEtudiant(String userId) async {
    return await client.from("cv_etudiant").select().eq("user_id", userId).maybeSingle();
  }

  // ============ CV PROFESSIONNEL ============
  static Future<void> sauvegarderCvProfessionnel(String userId, Map<String, dynamic> data) async {
    await client.from("cv_professionnel").upsert({
      "user_id": userId,
      ...data,
    });
  }

  static Future<Map<String, dynamic>?> getCvProfessionnel(String userId) async {
    return await client.from("cv_professionnel").select().eq("user_id", userId).maybeSingle();
  }

  // ============ ABONNEMENTS ============
  static Future<void> creerAbonnement({
    required String userId,
    required String espace,
    required String formule,
    required int montant,
  }) async {
    await client.from("abonnements").insert({
      "user_id": userId,
      "espace": espace,
      "formule": formule,
      "montant": montant,
      "statut": "en_attente",
    });
  }

  static Future<bool> aAbonnementActif(String userId, String espace) async {
    final response = await client
        .from("abonnements")
        .select()
        .eq("user_id", userId)
        .eq("espace", espace)
        .eq("statut", "actif")
        .maybeSingle();
    return response != null;
  }

  // ============ PROGRESSION QCM ============
  static Future<void> enregistrerProgression({
    required String userId,
    required String concours,
    required String matiere,
    required int score,
    required int total,
  }) async {
    await client.from("progression_qcm").insert({
      "user_id": userId,
      "concours": concours,
      "matiere": matiere,
      "score": score,
      "total": total,
    });
  }

  // ============ STORAGE (PDFs) ============
  static Future<String> uploaderSujet({
    required String niveau, // "bepc" ou "bac"
    required String nomFichier,
    required List<int> bytes,
  }) async {
    final bucket = "sujets-$niveau";
    await client.storage.from(bucket).uploadBinary(nomFichier,Uint8List.fromList(bytes));
    return client.storage.from(bucket).getPublicUrl(nomFichier);
  }

  static Future<List<FileObject>> listerSujets(String niveau) async {
    final bucket = "sujets-$niveau";
    return await client.storage.from(bucket).list();
  }
}

