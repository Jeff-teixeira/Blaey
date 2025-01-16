import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FindFriendsPage extends StatefulWidget {
  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchFriends(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    setState(() {
      isLoading = true;
      searchResults.clear();
    });

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          searchResults = querySnapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();
        });
      } else {
        print('Nenhum resultado encontrado.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nenhum amigo encontrado.')),
        );
      }
    } catch (e) {
      print('Erro ao buscar amigos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar amigos. Verifique sua conexão.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addFriend(String friendId) async {
    final currentUserId = _auth.currentUser?.uid;

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado')),
      );
      return;
    }

    try {
      // Adicionar amigo à coleção
      await _firestore.collection('amigos').doc(currentUserId).set({
        'friends': FieldValue.arrayUnion([friendId]),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Amigo adicionado com sucesso!')),
      );
    } catch (e) {
      print('Erro ao adicionar amigo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar amigo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encontrar Amigos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Recentes'),
            Tab(text: 'Sugestões'),
            Tab(text: 'Jogos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aba de Recentes
          _buildRecentsTab(),
          // Aba de Sugestões
          _buildSuggestionsTab(),
          // Aba de Jogos
          _buildGamesTab(),
        ],
      ),
    );
  }

  Widget _buildRecentsTab() {
    return Padding(
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
          isLoading
              ? CircularProgressIndicator()
              : searchResults.isEmpty
              ? Center(child: Text('Nenhum resultado encontrado.'))
              : Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final friend = searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/icons/user.png'),
                  ),
                  title: Text(friend['username'] ?? 'Usuário'),
                  subtitle: Text(friend['email'] ?? ''),
                  trailing: ElevatedButton(
                    onPressed: () => _addFriend(friend['id']),
                    child: Text('Adicionar'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsTab() {
    return Center(
      child: Text('Sugestões de amigos aparecerão aqui.'),
    );
  }

  Widget _buildGamesTab() {
    return Center(
      child: Text('Lista de jogos aparecerá aqui.'),
    );
  }
}