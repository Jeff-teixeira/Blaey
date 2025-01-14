import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../profile_page.dart';
import 'chat_page.dart';
import 'chat_secundario_page.dart';
import 'notas_page.dart';
import 'friends_list_page.dart'; // Importação da página de lista de amigos
import 'find_friends_page.dart'; // Importação da página de encontrar amigos

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String? _profileImagePath;
  final String userPhotoUrl = "assets/icons/perfil.png";

  final List<Map<String, String>> messages = [
    {'sender': 'Alice', 'message': 'Oi, como você está?', 'time': '10:00 AM'},
    {'sender': 'Bob', 'message': 'Vamos nos encontrar amanhã?', 'time': '09:00 AM'},
    {'sender': 'Charlie', 'message': 'Não se esqueça da reunião às 10h.', 'time': '08:30 AM'},
    {'sender': 'David', 'message': 'Você viu o último episódio?', 'time': '08:00 AM'},
    {'sender': 'Eve', 'message': 'Parabéns pelo seu trabalho!', 'time': '07:30 AM'},
  ];

  final List<Map<String, dynamic>> stories = [
    {'user': 'Atualizar', 'image': 'assets/icons/perfil.png'}, // Imagem inicial
    {'user': 'Alice', 'image': 'assets/icons/user.png'},
    {'user': 'Bob', 'image': 'assets/icons/user.png'},
    {'user': 'Charlie', 'image': 'assets/icons/user.png'},
    {'user': 'David', 'image': 'assets/icons/user.png'},
    {'user': 'Eve', 'image': 'assets/icons/user.png'},
    {'user': 'Frank', 'image': 'assets/icons/user.png'},
    {'user': 'Grace', 'image': 'assets/icons/user.png'},
    {'user': 'Heidi', 'image': 'assets/icons/user.png'},
    {'user': 'Ivan', 'image': 'assets/icons/user.png'},
    {'user': 'Judy', 'image': 'assets/icons/user.png'},
    {'user': 'Mallory', 'image': 'assets/icons/user.png'},
    {'user': 'Niaj', 'image': 'assets/icons/user.png'},
    {'user': 'Oscar', 'image': 'assets/icons/user.png'},
    {'user': 'Peggy', 'image': 'assets/icons/user.png'},
    {'user': 'Sybil', 'image': 'assets/icons/user.png'},
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profile_image_path');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo padrão
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white, // Mesma cor do fundo
          title: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.green,
                child: CircleAvatar(
                  radius: 21,
                  backgroundImage: AssetImage('assets/icons/app_icon.png'),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'blaey',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          titleSpacing: 16.0,
          actions: [
            IconButton(
              icon: const Icon(Icons.note, size: 30, color: Colors.black54),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotasPage()),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                ).then((_) => _loadProfileImage()); // Recarrega a imagem ao voltar
              },
              child: CircleAvatar(
                radius: 22,
                backgroundImage: _profileImagePath != null
                    ? FileImage(File(_profileImagePath!))
                    : AssetImage(userPhotoUrl) as ImageProvider,
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carrossel de Stories
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final isUpdateStory = stories[index]['user'] == 'Atualizar';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isUpdateStory
                              ? null
                              : LinearGradient(
                            colors: [Colors.green, Colors.lightGreenAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(2.0),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: isUpdateStory
                                    ? _profileImagePath != null
                                    ? FileImage(File(_profileImagePath!))
                                    : AssetImage(userPhotoUrl) as ImageProvider
                                    : AssetImage(stories[index]['image']),
                              ),
                              if (isUpdateStory)
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(Icons.add_circle, color: Colors.green, size: 24),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        stories[index]['user'] ?? 'Desconhecido',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FindFriendsPage()),
                );
              },
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: Image.asset('assets/images/pesquisa.png'),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  fillColor: Colors.grey[200],
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          // Texto "Conversas" com ícone de chat
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Conversas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatSecundarioPage()),
                    );
                  },
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          // Lista de Conversas
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: messages.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/icons/user.png'),
                  ),
                  title: Text(
                    messages[index]['sender'] ?? 'Desconhecido',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    messages[index]['message'] ?? '',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        messages[index]['time'] ?? '',
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          friendName: messages[index]['sender']!,
                          friendPhotoUrl: 'https://via.placeholder.com/150',
                          isOnline: true,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendsListPage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green,
      ),
    );
  }
}