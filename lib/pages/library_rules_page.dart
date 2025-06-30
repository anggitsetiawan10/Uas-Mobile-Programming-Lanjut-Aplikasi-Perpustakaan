import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LibraryRulesPage extends StatelessWidget {
  const LibraryRulesPage({super.key});

  final String _libraryAddress =
      'JL. Jenderal Gatot Subroto, Purwokerto, Kebondalem, Purwokerto Lor, '
      'Purwokerto Timur, Banyumas Regency, Central Java 53116';

  final String _mapsUrl = 'https://g.co/kgs/3m1kouG';
  final String _adminPhone = "6289674595181"; // WA harus pakai format internasional (62)

  void _openGoogleMaps(BuildContext context) async {
    try {
      final uri = Uri.parse(_mapsUrl);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault); // fallback
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka Google Maps.')),
      );
    }
  }

  void _contactAdmin(BuildContext context) async {
    final message = Uri.encodeComponent(
      "Halo Admin, saya membutuhkan bantuan terkait perpustakaan digital.",
    );
    final uri = Uri.parse('https://wa.me/$_adminPhone?text=$message');

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault); // fallback
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka WhatsApp.')),
      );
    }
  }

  Widget _buildRuleItem(String title, String desc, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, color: Colors.indigo),
          if (icon != null) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo)),
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peraturan Perpustakaan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildRuleItem(
            '1. Peminjaman Buku',
            'Peminjaman dilakukan secara online melalui aplikasi ini. Anggota memilih buku lalu booking. Buku diambil langsung di perpustakaan.',
            icon: Icons.book_online,
          ),
          _buildRuleItem(
            '2. Pengambilan Buku',
            'Setelah booking, anggota wajib datang ke perpustakaan untuk mengambil buku sesuai jadwal.',
            icon: Icons.event_available,
          ),
          _buildRuleItem(
            '3. Jangka Waktu Peminjaman',
            'Buku dapat dipinjam maksimal 7 hari. Lewat dari itu akan dikenakan denda.',
            icon: Icons.timer,
          ),
          _buildRuleItem(
            '4. Denda Keterlambatan',
            'Denda keterlambatan adalah Rp1.000 per hari jika lewat dari batas waktu peminjaman.',
            icon: Icons.warning_amber,
          ),
          _buildRuleItem(
            '5. Perubahan Status Peminjaman',
            'Status buku dari "Booking" ke "Dipinjam" hanya dapat diubah oleh admin perpustakaan.',
            icon: Icons.admin_panel_settings,
          ),
          _buildRuleItem(
            '6. Akun Pengguna',
            'Akun hanya bisa dibuat oleh admin. Untuk mendaftar, silakan datang langsung ke perpustakaan.',
            icon: Icons.person_add_alt_1,
          ),
          _buildRuleItem(
            '7. Alamat Perpustakaan',
            _libraryAddress,
            icon: Icons.location_on,
          ),
          _buildRuleItem(
            '8. Jam Operasional',
            'Senin - Jumat : 08.00 - 15.00 WIB\n'
                'Sabtu : 08.00 - 12.00 WIB\n'
                'Minggu & Hari Libur : Tutup',
            icon: Icons.access_time_filled,
          ),
          const SizedBox(height: 30),
          const Divider(thickness: 1.2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openGoogleMaps(context),
                icon: const Icon(Icons.map, color: Colors.white),
                label: const Text('Buka Maps', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              ),
              ElevatedButton.icon(
                onPressed: () => _contactAdmin(context),
                icon: const Icon(Icons.phone, color: Colors.white),
                label: const Text('Hubungi Admin', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
