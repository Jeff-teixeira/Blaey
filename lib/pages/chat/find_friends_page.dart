import 'package:flutter/material.dart';

class FindFriendsPage extends StatefulWidget {
  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  void _searchFriends(String query) {
    // Simulação de busca de amigos
    setState(() {
      searchResults = [
        'Alice',
        'Bob',
        'Charlie',
        'David',
        'Eve',
      ].where((name) => name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encontrar Amigos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar por nome ou username...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
              ),
              onChanged: _searchFriends,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/icons/user.png'),
                    ),
                    title: Text(searchResults[index]),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Ação para adicionar amigo
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${searchResults[index]} adicionado(a)!'),
                          ),
                        );
                      },
                      child: Text('Adicionar'),
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