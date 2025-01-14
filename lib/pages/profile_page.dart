import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'filter_dialog.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String bio = "";
  XFile? _image;
  String userName = "Jeff";
  int numPublications = 42;
  int numFriends = 120;
  int numBestFriends = 5;

  final ImagePicker _picker = ImagePicker();
  List<XFile> photoGallery = [
    XFile('assets/images/photo1.jpg'),
    XFile('assets/images/photo2.jpg'),
    XFile('assets/images/photo3.jpg'),
  ];

  bool showFriends = false;
  bool showTrophies = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<void> _addPhotoToGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        photoGallery.add(pickedFile);
      });
    }
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    ).then((_) {
      setState(() {});
    });
  }

  void _viewImage() {
    if (_image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewPage(imageFile: File(_image!.path)),
        ),
      );
    }
  }

  void _viewFriendProfile(String friendName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendProfilePage(friendName: friendName)),
    );
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
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = pickedFile;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tirar uma Foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _image = pickedFile;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('@$userName'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and User Info
            Row(
              children: [
                GestureDetector(
                  onTap: _showImagePickerOptions, // Abre as opções de escolha de imagem
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.grey[300],
                        child: CircleAvatar(
                          radius: 63,
                          backgroundImage: _image != null
                              ? FileImage(File(_image!.path))
                              : AssetImage('assets/icons/perfil.png') as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          '$numPublications ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Publicações',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '$numFriends ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Amigos',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 10),
                        SizedBox(width: 5),
                        Text('online', style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Bio and Filter Button
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      bio.isNotEmpty ? bio : 'adicione uma bios...',
                      style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6), fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                IconButton(
                  icon: ImageIcon(AssetImage('assets/icons/filter.png'), size: 30, color: Colors.black54),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return FilterDialog();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Buttons for Adding Updates and Editing Profile
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: _pickImage,
                  child: Text(
                    '+ Adicionar atualização',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onPressed: _editProfile,
                  icon: Icon(Icons.edit, color: Colors.white, size: 16),
                  label: Text(
                    'Editar perfil',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Navigation Bar for Photos, Friends, and Trophies
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo_library, color: !showFriends && !showTrophies ? Colors.black : Colors.black54),
                        onPressed: () {
                          setState(() {
                            showFriends = false;
                            showTrophies = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.group, color: showFriends ? Colors.black : Colors.black54),
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
                    height: 6,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            height: 6,
                            color: !showFriends && !showTrophies ? Colors.black : Colors.transparent,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 6,
                            color: showFriends ? Colors.black : Colors.transparent,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 6,
                            color: showTrophies ? Colors.black : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            // Content Area for Photos, Friends, and Trophies
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Visibility(
                      visible: !showFriends && !showTrophies,
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),
                              itemCount: 3,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Visibility(
                      visible: showFriends,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Melhores Amigos',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '($numBestFriends)',
                                      style: TextStyle(fontSize: 18, color: Colors.green),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage('assets/icons/user.png'),
                                  ),
                                  title: Text('Amigo 1'),
                                  onTap: () => _viewFriendProfile('Amigo 1'),
                                ),
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage('assets/icons/user.png'),
                                  ),
                                  title: Text('Amigo 2'),
                                  onTap: () => _viewFriendProfile('Amigo 2'),
                                ),
                                SizedBox(height: 8),
                                Divider(),
                                SizedBox(height: 8),
                                Text(
                                  'Amigos',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage('assets/icons/user.png'),
                                  ),
                                  title: Text('Amigo 3'),
                                  onTap: () => _viewFriendProfile('Amigo 3'),
                                ),
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage('assets/icons/user.png'),
                                  ),
                                  title: Text('Amigo 4'),
                                  onTap: () => _viewFriendProfile('Amigo 4'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Visibility(
                      visible: showTrophies,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.emoji_events),
                                  title: Text('Troféu 1'),
                                  subtitle: Text('Descrição do troféu'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.emoji_events),
                                  title: Text('Troféu 2'),
                                  subtitle: Text('Descrição do troféu'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: showFriends || showTrophies
          ? null
          : FloatingActionButton(
        onPressed: _addPhotoToGallery,
        backgroundColor: Colors.black54,
        child: Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }
}

// Image Preview Page
class ImagePreviewPage extends StatelessWidget {
  final File imageFile;

  ImagePreviewPage({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Foto'),
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}

// Edit Profile Page
class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String userName = "Jeff";
  String bio = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nome'),
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
              controller: TextEditingController(text: userName),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Biografia'),
              onChanged: (value) {
                setState(() {
                  bio = value;
                });
              },
              controller: TextEditingController(text: bio),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

// Friend Profile Page
class FriendProfilePage extends StatelessWidget {
  final String friendName;

  FriendProfilePage({required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friendName),
      ),
      body: Center(
        child: Text('Perfil do $friendName'),
      ),
    );
  }
}