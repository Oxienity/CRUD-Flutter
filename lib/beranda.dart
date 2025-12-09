import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Halaman_Utama extends StatefulWidget {
  const Halaman_Utama({super.key});

  @override
  State<Halaman_Utama> createState() => _Halaman_UtamaState();
}

class _Halaman_UtamaState extends State<Halaman_Utama> with TickerProviderStateMixin {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _nohpController = TextEditingController();
  final List<String> _semesterList = ['1', '2', '3', '4', '5', '6', '7', '8'];
  final List<String> _prodiList = ['Informatika', 'Mesin', 'Sipil', 'Arsitek'];
  final List<String> _kelasList = ['A', 'B', 'C', 'D', 'E'];
  String? _selectedSemester;
  String? _selectedKelas;
  String? _selectedProdi;
  String _jenisKelamin = 'Pria';

  List<Map<String, dynamic>> _items = [];
  static const String _prefsKey = 'submissions';
  int? _editingIndex;

  late AnimationController _backgroundController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _loadSaved();
    
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _npmController.dispose();
    _nohpController.dispose();
    _backgroundController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? raw = prefs.getStringList(_prefsKey);
    if (raw != null) {
      setState(() {
        _items = raw.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
      });
    }
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> raw = _items.map((m) => jsonEncode(m)).toList();
    await prefs.setStringList(_prefsKey, raw);
  }

  void _addOrUpdateItem() {
    final nama = _namaController.text.trim();
    final alamat = _alamatController.text.trim();
    final npm = _npmController.text.trim();

    if (nama.isEmpty || npm.isEmpty) {
      _showSnackBar('Nama dan NPM wajib diisi', Colors.red);
      return;
    }

    if (_editingIndex == null) {
      final item = {
        'nama': nama,
        'alamat': alamat,
        'npm': npm,
        'No.Hp': _nohpController.text.trim(),
        'semester': _selectedSemester ?? '-',
        'kelas': _selectedKelas ?? '-',
        'prodi': _selectedProdi ?? '-',
        'jk': _jenisKelamin,
        'createdAt': DateTime.now().toIso8601String(),
      };

      setState(() {
        _items.insert(0, item);
      });

      _saveAll();
      _showSnackBar('Data berhasil ditambahkan', Colors.green);
    } else {
      final index = _editingIndex!;
      final oldCreatedAt = _items[index]['createdAt'] as String?;

      final updated = {
        'nama': nama,
        'alamat': alamat,
        'npm': npm,
        'No.Hp': _nohpController.text.trim(),
        'semester': _selectedSemester ?? '-',
        'kelas': _selectedKelas ?? '-',
        'prodi': _selectedProdi ?? '-',
        'jk': _jenisKelamin,
        'createdAt': oldCreatedAt ?? DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      setState(() {
        _items[index] = updated;
        _editingIndex = null;
      });

      _saveAll();
      _showSnackBar('Data berhasil diperbarui', Colors.blue);
    }

    _clearForm();
  }

  Future<void> _removeItem(int index) async {
    setState(() {
      _items.removeAt(index);
    });
    await _saveAll();
    _showSnackBar('Data dihapus', Colors.orange);
  }

  void _startEdit(int index) {
    final item = _items[index];
    setState(() {
      _editingIndex = index;
      _namaController.text = item['nama'] ?? '';
      _alamatController.text = item['alamat'] ?? '';
      _npmController.text = item['npm'] ?? '';
      _nohpController.text = item['No.Hp'] ?? '';
      _selectedSemester = (item['semester'] is String) ? item['semester'] as String : null;
      _selectedKelas = (item['kelas'] is String) ? item['kelas'] as String : null;
      _selectedProdi = (item['prodi'] is String) ? item['prodi'] as String : null;
      _jenisKelamin = (item['jk'] as String?) ?? 'Pria';
    });

    _showSnackBar('Mode edit: perbarui form lalu tekan Update', Colors.purple);
  }

  void _clearForm() {
    _namaController.clear();
    _alamatController.clear();
    _npmController.clear();
    _nohpController.clear();
    setState(() {
      _selectedSemester = null;
      _selectedKelas = null;
      _selectedProdi = null;
      _jenisKelamin = 'Pria';
      _editingIndex = null;
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showDetail(Map<String, dynamic> item, int index) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade50,
                Colors.yellow.shade50,
              ],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person, color: Colors.deepOrange),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Detail Mahasiswa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow(Icons.badge, 'Nama', item['nama'] ?? '-'),
              _buildDetailRow(Icons.home, 'Alamat', item['alamat'] ?? '-'),
              _buildDetailRow(Icons.numbers, 'NPM', item['npm'] ?? '-'),
              _buildDetailRow(Icons.phone, 'No.Hp', item['No.Hp'] ?? '-'),
              _buildDetailRow(Icons.calendar_today, 'Semester', item['semester'] ?? '-'),
              _buildDetailRow(Icons.class_, 'Kelas', item['kelas'] ?? '-'),
              _buildDetailRow(Icons.school, 'Prodi', item['prodi'] ?? '-'),
              _buildDetailRow(Icons.wc, 'Jenis Kelamin', item['jk'] ?? '-'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _removeItem(index);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _startEdit(index);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        Colors.red.shade400,
                        Colors.orange.shade400,
                        _backgroundController.value,
                      )!,
                      Color.lerp(
                        Colors.orange.shade300,
                        Colors.yellow.shade300,
                        _backgroundController.value,
                      )!,
                      Color.lerp(
                        Colors.yellow.shade200,
                        Colors.red.shade300,
                        _backgroundController.value,
                      )!,
                    ],
                  ),
                ),
              );
            },
          ),
          // Floating circles decoration
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.school, color: Colors.orange),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Data Mahasiswa',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Form Container
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          _buildTextField(_namaController, 'Nama', Icons.person),
                          const SizedBox(height: 16),
                          _buildTextField(_alamatController, 'Alamat', Icons.home),
                          const SizedBox(height: 16),
                          _buildTextField(_npmController, 'NPM', Icons.numbers),
                          const SizedBox(height: 16),
                          _buildTextField(_nohpController, 'No.Hp', Icons.phone),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            'Semester',
                            Icons.calendar_today,
                            _selectedSemester,
                            _semesterList,
                            (v) => setState(() => _selectedSemester = v),
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            'Kelas',
                            Icons.class_,
                            _selectedKelas,
                            _kelasList,
                            (v) => setState(() => _selectedKelas = v),
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            'Prodi',
                            Icons.school,
                            _selectedProdi,
                            _prodiList,
                            (v) => setState(() => _selectedProdi = v),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.wc, color: Colors.deepOrange),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Jenis Kelamin:',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Radio<String>(
                                            value: 'Pria',
                                            groupValue: _jenisKelamin,
                                            onChanged: (v) => setState(() => _jenisKelamin = v!),
                                            activeColor: Colors.deepOrange,
                                          ),
                                          const Text('Pria'),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Radio<String>(
                                            value: 'Perempuan',
                                            groupValue: _jenisKelamin,
                                            onChanged: (v) => setState(() => _jenisKelamin = v!),
                                            activeColor: Colors.deepOrange,
                                          ),
                                          const Text('Perempuan'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _addOrUpdateItem,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: Text(
                                    _editingIndex == null ? 'Submit' : 'Update',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (_editingIndex != null) ...[
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _clearForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text('Batal'),
                                ),
                              ]
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(thickness: 2),
                          const SizedBox(height: 16),
                          _items.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.inbox,
                                        size: 80,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Belum ada data',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _items.length,
                                  itemBuilder: (context, index) {
                                    final item = _items[index];
                                    return TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: Duration(milliseconds: 300 + (index * 100)),
                                      builder: (context, double value, child) {
                                        return Transform.scale(
                                          scale: value,
                                          child: Opacity(
                                            opacity: value,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: Dismissible(
                                        key: Key(item['createdAt'] ?? index.toString()),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 4),
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onDismissed: (_) => _removeItem(index),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 4),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.orange.shade50,
                                                Colors.yellow.shade50,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.deepOrange,
                                              child: Text(
                                                item['nama']?[0]?.toUpperCase() ?? '?',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              item['nama'] ?? '-',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            subtitle: Text(
                                              '${item['npm'] ?? '-'} • ${item['prodi'] ?? '-'}',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            trailing: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.deepOrange,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                item['kelas'] ?? '-',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            onTap: () => _showDetail(item, index),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepOrange),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    IconData icon,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepOrange),
          border: InputBorder.none,
        ),
        isExpanded: true,
        items: items.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}