import 'package:flutter/material.dart';
import 'package:perpustakaanid/pages/user_profile_detail.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'contact_admin.dart';
import 'edit_profile.dart';
import 'forgot.dart';
import 'library_rules_page.dart';
import 'login.dart'; // Pastikan halaman login ini ada

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage>, WidgetsBindingObserver {
  final AuthService _authService = AuthService();
  User? _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getUser();
    setState(() {
      _user = user;
    });
  }

  void _logout() async {
    await _authService.logoutFromServer();
    await _authService.logout();

    // Ganti halaman ke Login tanpa kembali ke halaman sebelumnya
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
    );
  }

  void _showConfirmationDialog(String title, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text("Apakah Anda yakin ingin melanjutkan?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: Colors.indigo),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildInitialAvatar(String name) {
    String initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join()
        : '?';

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        child: Text(
          initials.toUpperCase(),
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Column(
      children: [
        _buildInitialAvatar(user.name),
        const SizedBox(height: 14),
        Text(
          user.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 16, color: Colors.grey),
            const SizedBox(width: 6),
            Text(user.email, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 6),
        Chip(
          label: Text(user.role.toUpperCase()),
          backgroundColor: Colors.indigo[50],
          labelStyle: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _loadUser,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            _buildProfileHeader(_user!),
            const SizedBox(height: 30),
            const Divider(thickness: 1.2),
            const SizedBox(height: 12),
            _buildMenuItem(Icons.account_circle, "Lihat Profil Lengkap", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserProfileDetailPage()),
              );
            }),
            _buildMenuItem(Icons.edit, "Edit Profil", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(
                    memberId: _user!.id.toString(),
                    name: _user!.name,
                    currentPhone: _user!.phone ?? '',
                    currentEmail: _user!.email ?? '',
                    birthPlace: _user!.profile?.birthPlace ?? '',
                    birthDate: _user!.profile?.birthDate,
                    address: _user!.profile?.address ?? '',
                    studyProgram: _user!.profile?.institution ?? '',
                  ),
                ),
              );
            }),
            _buildMenuItem(Icons.rule, "Aturan Peminjaman", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LibraryRulesPage()),
              );
            }),

            _buildMenuItem(Icons.support_agent, "Hubungi Admin", () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ContactAdminPage()));
            }),

            _buildMenuItem(Icons.lock_outline, "Ganti Password", () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
            }),

            _buildMenuItem(Icons.info_outline, "Mengenai Aplikasi", () {
              showAboutDialog(
                context: context,
                applicationName: "Perpustakaan Digital",
                applicationVersion: "v1.0.0",
                applicationLegalese: "© 2025 G-One Tech",
              );
            }),

            _buildMenuItem(Icons.logout, "Logout", () {
              _showConfirmationDialog("Logout", _logout);
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
