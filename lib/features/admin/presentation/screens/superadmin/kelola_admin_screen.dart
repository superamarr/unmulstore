import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pab/features/admin/domain/repositories/superadmin_repository.dart';
import 'package:pab/core/theme/app_theme.dart';
import 'package:pab/shared/widgets/custom_text_field.dart';
import 'package:pab/shared/widgets/primary_button.dart';
import 'package:pab/shared/widgets/confirm_action_sheet.dart';

class KelolaAdminScreen extends StatefulWidget {
  const KelolaAdminScreen({super.key});

  @override
  State<KelolaAdminScreen> createState() => _KelolaAdminScreenState();
}

class _KelolaAdminScreenState extends State<KelolaAdminScreen> {
  final SuperAdminRepository _repo = SuperAdminRepository();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    setState(() => _isLoading = true);
    final profiles = await _repo.getAdminsOnly();
    if (mounted) {
      setState(() {
        _profiles = profiles;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateRole(String id, String newRole) async {
    try {
      await _repo.updateUserRole(id, newRole);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil mengubah role menjadi $newRole')),
        );
        _loadProfiles();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _showAddAdminDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final pwdCtrl = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateOverlay) {
          return AlertDialog(
            title: Text('Tambah Admin Baru', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  CustomTextField(
                    hintText: 'John Doe',
                    controller: nameCtrl,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 16),
                  const Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  CustomTextField(
                    hintText: 'admin@unmul.ac.id',
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 16),
                  const Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  CustomTextField(
                    hintText: 'Minimal 6 karakter',
                    controller: pwdCtrl,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              TextButton(
                onPressed: isSaving ? null : () => context.pop(),
                child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
              ),
              PrimaryButton(
                text: 'Simpan',
                isLoading: isSaving,
                onPressed: () async {
                  if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty || pwdCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field wajib diisi')));
                    return;
                  }
                  setStateOverlay(() => isSaving = true);
                  try {
                    await _repo.createAdmin(nameCtrl.text, emailCtrl.text, pwdCtrl.text);
                    if (context.mounted) {
                       context.pop();
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin berhasil ditambahkan!')));
                       _loadProfiles();
                    }
                  } catch(e) {
                     setStateOverlay(() => isSaving = false);
                     if (context.mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                     }
                  }
                },
              )
            ],
          );
        });
      },
    );
  }

  void _showRoleDialog(Map<String, dynamic> profile) {
    if (profile['role'] == 'superadmin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat mengubah hak akses superadmin lain.')),
      );
      return;
    }

    showConfirmActionSheet(
      context,
      variant: ConfirmActionVariant.revokeAccess,
      message:
          'Apakah Anda yakin ingin mencabut hak akses admin dari ${profile['full_name'] ?? 'pengguna ini'}?',
    ).then((confirmed) {
      if (confirmed == true) {
        _updateRole(profile['id'], 'user');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        onPressed: _showAddAdminDialog,
        icon: const Icon(Icons.add, color: Colors.black),
        label: Text(
          'Tambah Admin',
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _profiles.isEmpty
        ? Center(
            child: Text(
              'Belum ada admin lain.',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          )
        : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _profiles.length,
              itemBuilder: (context, index) {
                final profile = _profiles[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.admin_panel_settings, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile['full_name'] ?? 'No Name',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: const Color(0xFF1B1B1B),
                              ),
                            ),
                            Text(
                              profile['phone'] ?? 'No Phone Contact',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showRoleDialog(profile),
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
