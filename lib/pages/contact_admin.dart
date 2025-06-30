import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactAdminPage extends StatelessWidget {
  const ContactAdminPage({super.key});

  void _contactAdmin(BuildContext context) async {
    final String adminPhone = "6289674595181";
    final String message = Uri.encodeComponent(
      "Halo Admin, saya membutuhkan bantuan terkait aplikasi Perpustakaan Digital.",
    );

    final Uri whatsappUrl = Uri.parse("https://wa.me/$adminPhone?text=$message");

    try {
      final bool launched = await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(whatsappUrl, mode: LaunchMode.platformDefault); // fallback ke browser
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal membuka WhatsApp atau browser.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hubungi Admin", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Klik tombol di bawah ini untuk menghubungi admin melalui WhatsApp. Anda dapat menanyakan hal-hal seputar akun, peminjaman, atau lainnya.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _contactAdmin(context),
              icon: const Icon(Icons.chat, color: Colors.white),
              label: const Text("Hubungi via WhatsApp", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
