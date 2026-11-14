import "package:supabase_flutter/supabase_flutter.dart";

class ProfilService {
  static SupabaseClient get _db => Supabase.instance.client;

  static Future<void> definirRole(String role) async {
    final user = _db.auth.currentUser;
    if (user == null) return;
    await _db.from("users").upsert({
      "id": user.id,
      "email": user.email,
      "role": role,
    });
  }

  static Future<Map<String, dynamic>?> chargerCv(String table) async {
    final user = _db.auth.currentUser;
    if (user == null) return null;
    return await _db.from(table).select().eq("user_id", user.id).maybeSingle();
  }

  static Future<void> sauvegarderCv(String table, Map<String, dynamic> data) async {
    final user = _db.auth.currentUser;
    if (user == null) throw Exception("Utilisateur non connecte");
    await _db.from(table).upsert({
      ...data,
      "user_id": user.id,
      "updated_at": DateTime.now().toIso8601String(),
    }, onConflict: "user_id");
  }

  static List<Map<String, String>> listeMaps(dynamic v) {
    if (v is! List) return [];
    return v
        .map((e) => Map<String, String>.from(
            (e as Map).map((k, val) => MapEntry(k.toString(), val?.toString() ?? ""))))
        .toList();
  }

  static List<String> listeTextes(dynamic v) {
    if (v is! List) return [];
    return v.map((e) => e.toString()).toList();
  }
}

