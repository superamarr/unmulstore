import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SuperAdminRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // --- 1. GLOBAL SETTINGS ---

  // Default values jika tabel kosong atau key belum ada
  static const Map<String, num> _defaults = {
    'late_fee_per_day': 20000,
    'default_deposit': 50000,
    'default_rental_duration': 3,
  };

  Future<Map<String, dynamic>> getGlobalSettings() async {
    try {
      final response = await _supabase.from('global_settings').select();
      Map<String, dynamic> settings = {};
      for (var row in response) {
        settings[row['key']] = row['value'];
      }
      // Merge dengan defaults agar key yang belum ada tetap memiliki nilai
      for (var entry in _defaults.entries) {
        settings.putIfAbsent(entry.key, () => entry.value);
      }
      return settings;
    } catch (e) {
      debugPrint('Error fetching global settings: $e');
      // Return defaults saat terjadi error (misal tabel belum ada)
      return Map<String, dynamic>.from(_defaults);
    }
  }

  Future<void> updateGlobalSetting(String key, num value) async {
    try {
      await _supabase.from('global_settings').upsert(
        {
          'key': key,
          'value': value,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'key',
      );
    } catch (e) {
      debugPrint('Error updating global setting: $e');
      throw Exception('Gagal menyimpan pengaturan: $e');
    }
  }

  /// Ambil tarif denda per hari dari global_settings
  Future<int> getLateFeePerDay() async {
    try {
      final settings = await getGlobalSettings();
      return (settings['late_fee_per_day'] as num?)?.toInt() ?? 20000;
    } catch (e) {
      debugPrint('Error fetching late fee: $e');
      return 20000; // Fallback default
    }
  }

  // --- 2. ADMIN MANAGEMENT ---

  Future<List<Map<String, dynamic>>> getAdminsOnly() async {
    try {
      final response = await _supabase.from('profiles').select().eq('role', 'admin').order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching admins: $e');
      return [];
    }
  }

  Future<void> createAdmin(String name, String email, String password) async {
     try {
       // Using secondary client to not log out superadmin
       final secondaryApp = SupabaseClient(
         dotenv.get('SUPABASE_URL'), 
         dotenv.get('SUPABASE_ANON_KEY')
       );
       
       final res = await secondaryApp.auth.signUp(
         email: email, 
         password: password,
         data: {'full_name': name, 'role': 'admin'},
       );

       if (res.user != null) {
          await _supabase.from('profiles').update({'role': 'admin'}).eq('id', res.user!.id);
       }
     } catch (e) {
       debugPrint('Error creating admin: $e');
       throw Exception('Gagal membuat admin: $e');
     }
  }

  Future<void> updateUserRole(String profileId, String role) async {
    try {
      await _supabase.from('profiles').update({'role': role}).eq('id', profileId);
    } catch (e) {
      debugPrint('Error updating role: $e');
      throw Exception('Gagal mengubah role: $e');
    }
  }

  // --- 3. PRODUCT MANAGEMENT ---

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final response = await _supabase.from('products').select().order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching products: $e');
      return [];
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _supabase.from('products').delete().eq('id', id);
    } catch (e) {
      debugPrint('Error deleting product: $e');
      throw Exception('Gagal menghapus produk: $e');
    }
  }

  // To be implemented fully when storage is ready
  Future<void> saveProduct(Map<String, dynamic> productData) async {
    try {
      if (productData.containsKey('id') && productData['id'] != null) {
        await _supabase.from('products').update(productData).eq('id', productData['id']);
      } else {
         productData.remove('id');
        await _supabase.from('products').insert(productData);
      }
    } catch (e) {
       debugPrint('Error saving product: $e');
       throw Exception('Gagal menyimpan produk: $e');
    }
  }
}
