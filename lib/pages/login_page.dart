import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/fun_page.dart';
import '../services/auth_service.dart'; // Certifique-se de que o caminho está correto

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _loginWithEmail(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text;
      String password = _passwordController.text;

      final authService = Provider.of<AuthService>(context, listen: false);

      try {
        UserCredential userCredential = await authService.signInWithEmailAndPassword(email, password);

        // Navegação para FunPage após login bem-sucedido
        double userBalance = 100.0; // Exemplo de valor de saldo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FunPage(userBalance: userBalance)),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Login falhou! Verifique suas credenciais.';
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          errorMessage = 'E-mail ou senha incorretos.';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Muitas tentativas. Tente novamente mais tarde.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro inesperado.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      UserCredential userCredential = await authService.signInWithGoogle();

      // Navegação para FunPage após login bem-sucedido
      double userBalance = 100.0; // Exemplo de valor de saldo
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FunPage(userBalance: userBalance)),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro ao fazer login com Google.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro inesperado.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela de Login"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um e-mail válido.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () => _loginWithEmail(context),
                child: Text('Entrar'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _loginWithGoogle(context),
                child: Text('Entrar com Google'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navega para a página de registro
                },
                child: Text('Não tem uma conta? Registre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
