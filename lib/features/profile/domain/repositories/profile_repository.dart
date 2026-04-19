import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pab/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  final _supabase = Supabase.instance.client;

  Future<ProfileModel?> getCurrentProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      return ProfileModel.fromMap(response);
    } catch (e) {
      // If profile doesn't exist yet, return null
      return null;
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    try {
      await _supabase
          .from('profiles')
          .update({
            'full_name': profile.fullName,
            'phone_number': profile.phoneNumber,
            'address': profile.address,
            'avatar_url': profile.avatarUrl,
          })
          .eq('id', profile.id);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
  
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
