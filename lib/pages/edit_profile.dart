import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/profile_model.dart';
import '../services/ProfileService.dart';

class EditProfilePage extends StatefulWidget {
  final String memberId;
  final String name;
  final String currentEmail;
  final String currentPhone;
  final String birthPlace;
  final DateTime? birthDate;
  final String address;
  final String studyProgram;

  const EditProfilePage({
    required this.memberId,
    required this.name,
    required this.currentEmail,
    required this.currentPhone,
    required this.birthPlace,
    required this.birthDate,
    required this.address,
    required this.studyProgram,
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _birthPlaceController;
  late TextEditingController _addressController;
  late TextEditingController _studyProgramController;
  late TextEditingController _occupationController;
  DateTime? _selectedBirthDate;
  String _selectedGender = 'Laki-laki';

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.currentPhone);
    _birthPlaceController = TextEditingController(text: widget.birthPlace);
    _addressController = TextEditingController(text: widget.address);
    _studyProgramController = TextEditingController(text: widget.studyProgram);
    _occupationController = TextEditingController();
    _selectedBirthDate = widget.birthDate;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _birthPlaceController.dispose();
    _addressController.dispose();
    _studyProgramController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  void _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate() && _selectedBirthDate != null) {
      final updatedProfile = Profile(
        name: widget.name,
        gender: _selectedGender,
        birthPlace: _birthPlaceController.text.trim(),
        birthDate: _selectedBirthDate!,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        occupation: _occupationController.text.trim(),
        institution: _studyProgramController.text.trim(),
      );

      final success = await ProfileService().updateProfile(updatedProfile);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui profil')),
        );
      }
    }
  }

  Widget _readOnlyField(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextFormField(
          readOnly: true,
          initialValue: value,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[200],
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _editableField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
          validator: (value) =>
          value == null || value.trim().isEmpty ? '$label wajib diisi' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _genderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Jenis Kelamin", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          items: const [
            DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
            DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
            DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedGender = value;
              });
            }
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.transgender),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _readOnlyField(Icons.card_membership, "ID Anggota", widget.memberId),
              _readOnlyField(Icons.person, "Nama Lengkap", widget.name),
              _readOnlyField(Icons.email, "Email (untuk login)", widget.currentEmail),

              _editableField(
                icon: Icons.phone,
                label: "No. Telepon",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                hintText: "Masukkan nomor telepon",
              ),

              _genderDropdown(),

              _editableField(
                icon: Icons.location_city,
                label: "Tempat Lahir",
                controller: _birthPlaceController,
                keyboardType: TextInputType.text,
                hintText: "Contoh: Malang",
              ),

              Text("Tanggal Lahir", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              InkWell(
                onTap: _pickBirthDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedBirthDate == null
                        ? "Pilih tanggal"
                        : DateFormat('dd MMMM yyyy').format(_selectedBirthDate!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _editableField(
                icon: Icons.home,
                label: "Alamat",
                controller: _addressController,
                keyboardType: TextInputType.multiline,
                hintText: "Masukkan alamat lengkap",
                maxLines: 3,
              ),

              _editableField(
                icon: Icons.school,
                label: "Program Studi",
                controller: _studyProgramController,
                keyboardType: TextInputType.text,
                hintText: "Contoh: Teknik Informatika",
              ),

              _editableField(
                icon: Icons.work,
                label: "Pekerjaan",
                controller: _occupationController,
                keyboardType: TextInputType.text,
                hintText: "Contoh: Mahasiswa, Dosen, dll.",
              ),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
