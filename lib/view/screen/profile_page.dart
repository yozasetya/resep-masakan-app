import 'package:flutter/material.dart';
import 'package:recipe/service/user_service.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfilePage({required this.user, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final APIService _apiService = APIService();
  bool _isSaving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user['name']);
    _emailController = TextEditingController(text: widget.user['email']);
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isSaving = true;
    });

    final updatedUser = {
      "id": widget.user['id'],
      "name": _nameController.text,
      "email": _emailController.text,
      "password": widget.user['password'],
    };

    try {
      await _apiService.put('users/${widget.user['id']}', updatedUser);

      setState(() {
        widget.user['name'] = updatedUser['name'];
        widget.user['email'] = updatedUser['email'];
        _nameController.text = widget.user['name'];
        _emailController.text = widget.user['email'];
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }

    setState(() {
      _isSaving = false;
    });
  }

  Future<void> _confirmDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Penghapusan"),
          content: const Text("Apakah Anda yakin ingin menghapus akun ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Batal
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Konfirmasi
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deleteProfile();
    }
  }

  Future<void> _deleteProfile() async {
    try {
      await _apiService.delete('users/${widget.user['id']}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile deleted successfully')),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Image.asset(
              'images/logosearch.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 10),
            const Text(
              "MY PROFILE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF71B8B8),
              ),
            ),
            const Text(
              "Update Profil Kamu yuk!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    if (_isEditing)
                      Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          ListTile(
                            title: const Text("Full Name"),
                            subtitle: Text(widget.user['name']),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: const Text("Email"),
                            subtitle: Text(widget.user['email']),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      backgroundColor: const Color(0xFF71B8B8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _logout,
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      backgroundColor: const Color(0xFF71B8B8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isEditing
                        ? _updateProfile
                        : () {
                            setState(() {
                              _isEditing = true;
                            });
                          },
                    child: _isSaving
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            _isEditing ? 'Save' : 'Edit',
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _confirmDelete,
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
