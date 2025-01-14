import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Adicione o Firebase Auth
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _imagePath;
  String userName = "Jeff";
  String userHandle = "@jeff123rtr";
  String bio = "Apaixonado por tecnologia e jogos! 🎮";
  int numPublications = 42;
  int numFriends = 120;

  final ImagePicker _picker = ImagePicker();
  bool showFriends = false;
  bool showTrophies = false;

  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do Firebase Auth

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadProfileImage();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? "Jeff";
      userHandle = prefs.getString('userHandle') ?? "@jeff123rtr";
      bio = prefs.getString('bio') ?? "Apaixonado por tecnologia e jogos! 🎮";
    });
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('profile_image_path');
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('userHandle', userHandle);
    await prefs.setString('bio', bio);
  }

  Future<void> _saveProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path);
    setState(() {
      _imagePath = path;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
      await _saveProfileImage(pickedFile.path);
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
      await _saveProfileImage(pickedFile.path);
    }
  }

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Escolher da Galeria'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tirar uma Foto'),
                onTap: () async {
                  Navigator.pop(context);
                  await _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          userName: userName,
          userHandle: userHandle,
          bio: bio,
          onSave: (newName, newHandle, newBio) {
            setState(() {
              userName = newName;
              userHandle = newHandle;
              bio = newBio;
            });
            _saveProfileData();
          },
        ),
      ),
    );
  }

  // Funções para as opções do menu
  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Redireciona para a página de login
  }

  Future<void> _changeEmail() async {
    final user = _auth.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _newEmailController = TextEditingController();
          return AlertDialog(
            title: Text('Alterar Email'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Email atual: ${user.email}'),
                TextField(
                  controller: _newEmailController,
                  decoration: InputDecoration(labelText: 'Novo Email'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await user.updateEmail(_newEmailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email atualizado com sucesso!')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao atualizar email: $e')),
                    );
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _changePassword() async {
    final user = _auth.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _newPasswordController = TextEditingController();
          return AlertDialog(
            title: Text('Alterar Senha'),
            content: TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'Nova Senha'),
              obscureText: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await user.updatePassword(_newPasswordController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Senha atualizada com sucesso!')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao atualizar senha: $e')),
                    );
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Excluir Conta'),
            content: Text('Tem certeza de que deseja excluir sua conta permanentemente?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await user.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Conta excluída com sucesso!')),
                    );
                    Navigator.pushReplacementNamed(context, '/login');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao excluir conta: $e')),
                    );
                  }
                },
                child: Text('Excluir'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showTermsAndPrivacy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Termos de Uso e Privacidade')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(
                'Termos de Uso e Política de Privacidade\n\n'
                    '1. Respeito à privacidade do usuário.\n'
                    '2. Dados serão utilizados apenas para melhorar a experiência do usuário.\n'
                    '3. Não compartilhamos seus dados com terceiros.\n'
                    '4. O usuário pode excluir sua conta a qualquer momento.\n',
                style: TextStyle(fontSize: 16),
              ),
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
        title: Text(userHandle),
        actions: [
          // Botão de três pontinhos para acessar as opções
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'change_email':
                  _changeEmail();
                  break;
                case 'change_password':
                  _changePassword();
                  break;
                case 'delete_account':
                  _deleteAccount();
                  break;
                case 'terms':
                  _showTermsAndPrivacy();
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'change_email',
                  child: Text('Alterar Email'),
                ),
                PopupMenuItem(
                  value: 'change_password',
                  child: Text('Alterar Senha'),
                ),
                PopupMenuItem(
                  value: 'delete_account',
                  child: Text('Excluir Conta'),
                ),
                PopupMenuItem(
                  value: 'terms',
                  child: Text('Termos de Uso e Privacidade'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Sair da Conta'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Foto de Perfil e Informações do Usuário
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto de Perfil
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _imagePath != null
                              ? FileImage(File(_imagePath!))
                              : AssetImage('assets/icons/perfil.png') as ImageProvider,
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Informações do Usuário
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  '$numPublications',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Publicações',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                Text(
                                  '$numFriends',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Amigos',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Biografia
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                bio,
                style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7)),
              ),
            ),
            SizedBox(height: 20),
            // Botões de Ação (+ Atualizar e Editar Perfil)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _showImagePickerOptions,
                      child: Text(
                        '+ Atualizar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _editProfile,
                      child: Text(
                        'Editar Perfil',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Barra de Navegação (Fotos, Amigos, Troféus)
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.border_all_outlined,
                            color: !showFriends && !showTrophies ? Colors.black : Colors.black54),
                        onPressed: () {
                          setState(() {
                            showFriends = false;
                            showTrophies = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.account_box_outlined, color: showFriends ? Colors.black : Colors.black54),
                        onPressed: () {
                          setState(() {
                            showFriends = true;
                            showTrophies = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.emoji_events, color: showTrophies ? Colors.black : Colors.black54),
                        onPressed: () {
                          setState(() {
                            showFriends = false;
                            showTrophies = true;
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    height: 2,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Conteúdo Dinâmico (Fotos, Amigos, Troféus)
            if (!showFriends && !showTrophies)
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: 9, // Número de fotos
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.photo,
                        color: Colors.grey.withOpacity(0.6),
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            if (showFriends)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildFriendCard('Amigo 1', 'Melhor Amigo'),
                    _buildFriendCard('Amigo 2', 'Amigo'),
                    // Adicione mais amigos aqui...
                  ],
                ),
              ),
            if (showTrophies)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildTrophyCard('Troféu 1', 'Descrição do troféu'),
                    _buildTrophyCard('Troféu 2', 'Descrição do troféu'),
                    // Adicione mais troféus aqui...
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendCard(String name, String status) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(status, style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildTrophyCard(String title, String description) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Icon(Icons.emoji_events, color: Colors.amber, size: 40),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

// Página de Edição de Perfil
class EditProfilePage extends StatefulWidget {
  final String userName;
  final String userHandle;
  final String bio;
  final Function(String, String, String) onSave;

  EditProfilePage({
    required this.userName,
    required this.userHandle,
    required this.bio,
    required this.onSave,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _handleController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _handleController = TextEditingController(text: widget.userHandle);
    _bioController = TextEditingController(text: widget.bio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              widget.onSave(
                _nameController.text,
                _handleController.text,
                _bioController.text,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _handleController,
              decoration: InputDecoration(labelText: '@Nome de Usuário'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(labelText: 'Biografia'),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}