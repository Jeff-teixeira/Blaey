import 'package:flutter/material.dart';
import '../profile_page.dart';
import 'chat_page.dart';
import 'chat_secundario_page.dart';
import 'notas_page.dart';

class MessagesPage extends StatelessWidget {
  final String userPhotoUrl = "assets/icons/perfil.png"; // Use a imagem do perfil correta

  final List<Map<String, String>> messages = [
    {'sender': 'Alice', 'message': 'Oi, como você está?', 'time': '10:00 AM'},
    {'sender': 'Bob', 'message': 'Vamos nos encontrar amanhã?', 'time': '09:00 AM'},
    {'sender': 'Charlie', 'message': 'Não se esqueça da reunião às 10h.', 'time': '08:30 AM'},
    {'sender': 'David', 'message': 'Você viu o último episódio?', 'time': '08:00 AM'},
    {'sender': 'Eve', 'message': 'Parabéns pelo seu trabalho!', 'time': '07:30 AM'},
  ];

  final List<Map<String, dynamic>> stories = [
    {'user': 'Atualize', 'image': 'assets/icons/plus.png'},
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
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
                );
              },
              child: CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage(userPhotoUrl),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
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
          // Carrossel de Stories
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: stories[index]['user'] == 'Atualize'
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
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: AssetImage(stories[index]['image']),
                            child: stories[index]['user'] == 'Atualize'
                                ? Icon(Icons.add, color: Colors.black, size: 30)
                                : null,
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  color: Colors.white, // Fundo branco para a mensagem
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24, // Aumenta o tamanho do ícone do usuário
                      backgroundImage: AssetImage('assets/icons/user.png'),
                    ),
                    title: Text(
                      messages[index]['sender'] ?? 'Desconhecido', // Verificação de null
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      messages[index]['message'] ?? '', // Verificação de null
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          messages[index]['time'] ?? '', // Verificação de null
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
                            friendPhotoUrl: 'https://via.placeholder.com/150', // Placeholder para foto do amigo
                            isOnline: true, // Supondo que o amigo está online
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para abrir a lista de amigos
        },
        backgroundColor: Colors.grey[200], // Nearly white background
        child: const Icon(Icons.add, size: 30, color: Colors.black), // Black "+" icon
        elevation: 6.0, // Adiciona uma sombra ao botão
      ), // <-- Ensure this parenthesis is correctly placed
    );
  }
}

// Página de mensagem secundária (exemplo)
class ChatSecundarioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Secundário'),
      ),
      body: Center(
        child: Text('Conteúdo do Chat Secundário'),
      ),
    );
  }
}

// Página de notas (exemplo)
class NotasPage extends StatefulWidget {
  @override
  _NotasPageState createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, String>> _items = [];

  void _addItem() {
    final String todo = _todoController.text;
    final String note = _noteController.text;

    if (todo.isNotEmpty || note.isNotEmpty) {
      setState(() {
        _items.add({'todo': todo, 'note': note});
      });
      _todoController.clear();
      _noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoController,
              decoration: InputDecoration(
                labelText: 'To-Do',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Nota',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Adicionar'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(_items[index]['todo'] ?? ''),
                      subtitle: Text(_items[index]['note'] ?? ''),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}