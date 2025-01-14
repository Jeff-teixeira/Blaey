import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream de mudanças no estado de autenticação
  Stream<User?> get user => _auth.authStateChanges();

  // Função para fazer login com o Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Inicia o fluxo de autenticação do Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Login com Google abortado pelo usuário.',
        );
      }

      // Obtém o token de autenticação do Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Cria as credenciais do Firebase com o token do Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Faz o login no Firebase com as credenciais do Google
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Função para fazer login com email e senha
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Função para criar um novo usuário com email e senha
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Função para fazer logout
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut(); // Certifique-se de que o Google SignIn também é desconectado
  }

  // Função para obter o usuário atual
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
