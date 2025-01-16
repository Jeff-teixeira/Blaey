import 'package:flutter/material.dart';
import 'chat_page.dart'; // Add this import

class FriendsListPage extends StatelessWidget {
  final List<String> friends = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Eve',
    'Frank',
    'Grace',
    'Heidi',
    'Ivan',
    'Judy',
    'Mallory',
    'Niaj',
    'Oscar',
    'Peggy',
    'Sybil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Amigos'),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/icons/user.png'),
            ),
            title: Text(friends[index]),
            subtitle: Text('Última vez online: 2 horas atrás'), // Exemplo de subtítulo
            trailing: IconButton(
              icon: Icon(Icons.message, color: Colors.green),
              onPressed: () {
                // Navegar para a página de chat com o amigo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      friendName: friends[index],
                      friendPhotoUrl: 'https://via.placeholder.com/150',
                      isOnline: true,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}