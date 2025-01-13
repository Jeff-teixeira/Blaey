import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final AuthService _auth = AuthService();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  String _verificationId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authentication')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(hintText: "Phone number"),
            ),
            ElevatedButton(
              child: Text("Verify Number"),
              onPressed: () async {
                await _auth.verifyPhoneNumber(
                  _phoneController.text,
                  (PhoneAuthCredential credential) async {
                    await _auth.signInWithPhoneNumber(_codeController.text, _verificationId);
                  },
                  (FirebaseAuthException e) {
                    print("Failed to verify phone number: ${e.message}");
                  },
                  (String verificationId, int? resendToken) {
                    setState(() {
                      _verificationId = verificationId;
                    });
                  },
                  (String verificationId) {
                    setState(() {
                      _verificationId = verificationId;
                    });
                  },
                );
              },
            ),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(hintText: "Enter SMS code"),
            ),
            ElevatedButton(
              child: Text("Sign In with Phone"),
              onPressed: () async {
                try {
                  final credential = await _auth.signInWithPhoneNumber(
                    _codeController.text,
                    _verificationId,
                  );
                  print("Signed in: ${credential.user?.uid}");
                } catch (e) {
                  print("Failed to sign in: $e");
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Sign in with Google"),
              onPressed: () async {
                try {
                  final credential = await _auth.signInWithGoogle();
                  if (credential != null) {
                    print("Signed in with Google: ${credential.user?.displayName}");
                  } else {
                    print("Google sign in failed");
                  }
                } catch (e) {
                  print("Error during Google sign in: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}