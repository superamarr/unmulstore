import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/confirm_action_sheet.dart';
import '../../data/models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final ProfileRepository _repo = ProfileRepository();
  ProfileModel? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _repo.getCurrentProfile();
    if (profile != null) {
      setState(() {
        _profile = profile;
        _nameController.text = profile.fullName ?? '';
        _phoneController.text = profile.phoneNumber ?? '';
        _addressController.text = profile.address ?? '';
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  String? _validateFields() {
    if (_nameController.text.trim().isEmpty) {
      return 'Nama lengkap wajib diisi.';
    }
    if (_phoneController.text.trim().isEmpty) {
      return 'Nomor telepon wajib diisi.';
    }
    if (_addressController.text.trim().isEmpty) {
      return 'Alamat wajib diisi.';
    }
    return null;
  }

  Future<void> _onSavePressed() async {
    if (_profile == null) return;
    final err = _validateFields();
    if (err != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
      return;
    }
    final confirm = await showConfirmActionSheet(
      context,
      variant: ConfirmActionVariant.save,
    );
    if (confirm != true || !mounted) return;

    final updatedProfile = ProfileModel(
      id: _profile!.id,
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      avatarUrl: _profile!.avatarUrl,
    );
    await _repo.updateProfile(updatedProfile);
    if (mounted) context.pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile', style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
                child: const Icon(Icons.person, size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 48),
            _buildFieldLabel('Nama Lengkap'),
            _buildTextField(controller: _nameController),
            const SizedBox(height: 24),
            _buildFieldLabel('Nomor HP'),
            _buildTextField(controller: _phoneController),
            const SizedBox(height: 24),
            _buildFieldLabel('Alamat'),
            _buildTextField(controller: _addressController, maxLines: 4, hintText: 'Masukkan alamat...'),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          onPressed: _onSavePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFCC00),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('Simpan Perubahan', style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1B1B1B),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    int maxLines = 1,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: const Color(0xFF1B1B1B),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(color: const Color(0xFF64748B).withValues(alpha: 0.5)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFCC00), width: 1.5),
        ),
      ),
    );
  }
}
