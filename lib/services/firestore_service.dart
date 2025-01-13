import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService();

  Future<void> createUser(String userId, String name, String username, String email, String photoUrl) async {
    await _firestore.collection('users').doc(userId).set({
      'name': name,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'searchName': _createSearchList(name),
    });
  }

  List<String> _createSearchList(String name) {
    List<String> searchList = [];
    String temp = "";
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i].toLowerCase();
      searchList.add(temp);
    }
    return searchList;
  }

  Future<void> addFriend(String userId, String friendId) async {
    // Adicione o amigo à lista de amigos do usuário
    await _firestore.collection('users').doc(userId).update({
      'friends': FieldValue.arrayUnion([friendId])
    });
    // Adicione o usuário à lista de amigos do amigo
    await _firestore.collection('users').doc(friendId).update({
      'friends': FieldValue.arrayUnion([userId])
    });
  }

  Stream<List<Map<String, dynamic>>> getFriends(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().asyncMap((snapshot) async {
      final data = snapshot.data();
      if (data != null && data['friends'] != null) {
        final friendIds = List<String>.from(data['friends']);
        final friendDocs = await Future.wait(
          friendIds.map((id) => _firestore.collection('users').doc(id).get())
        );
        return friendDocs.map((doc) {
          final data = doc.data()!;
          return {
            'id': doc.id,
            'name': data['name'] ?? '',
            'email': data['email'] ?? '',
            'photoUrl': data['photoUrl'] ?? '',
          };
        }).toList();
      }
      return <Map<String, dynamic>>[];
    });
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    query = query.toLowerCase();
    final querySnapshot = await _firestore
        .collection('users')
        .where('searchName', arrayContains: query)
        .limit(10)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? '',
        'username': data['username'] ?? '',
        'photoUrl': data['photoUrl'] ?? '',
      };
    }).toList();
  }

  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    await _firestore.collection('chats').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getMessages(String userId, String friendId) {
    return _firestore
        .collection('chats')
        .where('senderId', whereIn: [userId, friendId])
        .where('receiverId', whereIn: [userId, friendId])
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}