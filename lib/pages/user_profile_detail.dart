import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/profileservice.dart';

class UserProfileDetailPage extends StatefulWidget {
  const UserProfileDetailPage({Key? key}) : super(key: key);

  @override
  State<UserProfileDetailPage> createState() => _UserProfileDetailPageState();
}

class _UserProfileDetailPageState extends State<UserProfileDetailPage> {
  Profile? _profile;
  bool _isLoading = true;
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _profileService.fetchProfile();
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;

    return '$day $month $year';
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.info_outline, size: 48, color: Colors.indigo),
                SizedBox(height: 16),
                Text(
                  "Profil belum lengkap",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  "Edit terlebih dahulu detail profile Anda di Edit Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Profil", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_profile == null)
          ? _buildEmptyState()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.indigo[100],
                  child: Text(
                    _profile!.name
                        .trim()
                        .split(' ')
                        .map((e) => e[0])
                        .take(2)
                        .join()
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(_profile!.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                _buildInfoRow(Icons.person_outline, "Jenis Kelamin", _profile!.gender),
                _buildInfoRow(Icons.cake, "Tanggal Lahir",
                    formatDate(_profile!.birthDate.toIso8601String())),
                _buildInfoRow(Icons.location_city, "Tempat Lahir", _profile!.birthPlace),
                _buildInfoRow(Icons.phone_android, "No. HP", _profile!.phone),
                _buildInfoRow(Icons.home, "Alamat", _profile!.address),

                if (_profile!.institution != null && _profile!.institution!.isNotEmpty)
                  _buildInfoRow(Icons.school, "Asal Instansi", _profile!.institution!),
                if (_profile!.occupation != null && _profile!.occupation!.isNotEmpty)
                  _buildInfoRow(Icons.work_outline, "Pekerjaan", _profile!.occupation!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
