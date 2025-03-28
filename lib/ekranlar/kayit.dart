import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Kullanıcı verisini Firestore’a kaydetmek için
import 'package:flutter/material.dart';
import 'giris.dart';

class KayitSayfasi extends StatefulWidget {
  const KayitSayfasi({super.key});

  @override
  _KayitSayfasiState createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _sifreTekrarController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _adController.dispose();
    _emailController.dispose();
    _sifreController.dispose();
    _sifreTekrarController.dispose();
    super.dispose();
  }

  //  Kullanıcıyı Firebase Authentication ve Firestore'a kaydet
  Future<void> _kayitOl() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _sifreController.text,
        );

        String uid = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'ad': _adController.text,
          'email': _emailController.text,
          'createdAt': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kayıt başarılı!')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GirisSayfasi()),
        );
      } on FirebaseAuthException catch (e) {
        String hataMesaji = 'Bilinmeyen bir hata oluştu';
        if (e.code == 'email-already-in-use') {
          hataMesaji = 'Bu e-posta zaten kullanılıyor!';
        } else if (e.code == 'weak-password') {
          hataMesaji = 'Şifre çok zayıf!';
        } else if (e.code == 'invalid-email') {
          hataMesaji = 'Geçersiz e-posta adresi!';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(hataMesaji)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            width: 350,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/heartify1.png",
                        height: 60,
                      ), // Logo
                      // Görsel ve yazı arasındaki mesafe
                      const Text(
                        "Heartify'ye Kayıt Ol",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _adController,
                    decoration: const InputDecoration(
                      labelText: "Adınızı Girin",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Adınızı girmeniz gerekli' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "E-posta Girin",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty
                        ? 'E-posta adresinizi girmeniz gerekli'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _sifreController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Şifre Girin",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) => value!.length < 6
                        ? 'Şifre en az 6 karakter olmalıdır'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _sifreTekrarController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Şifrenizi Tekrar Girin",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) => value != _sifreController.text
                        ? 'Şifreler uyuşmuyor'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _kayitOl,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
