import 'package:deneme/ekranlar/profil.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuncellemeSayfasi extends StatefulWidget {
  const GuncellemeSayfasi({super.key});

  @override
  State<GuncellemeSayfasi> createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<GuncellemeSayfasi> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  bool _sifreGizli = true;
  @override
  void initState() {
    super.initState();
    _verileriGetir(); // Firestore'dan verileri çek
  }

  @override
  void dispose() {
    _sifreController.dispose();
    super.dispose();
  }

  Future<void> _verileriGuncelle() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // **Mevcut şifre zorunlu! Eğer boşsa hata ver**
        if (_sifreController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lütfen mevcut şifrenizi girin!')),
          );
          return;
        }

        // **Kullanıcının mevcut şifresiyle tekrar kimlik doğrulaması yap**
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _sifreController.text, // Kullanıcının girdiği mevcut şifre
        );

        await user.reauthenticateWithCredential(credential);

        // **Firestore'daki bilgileri güncelle**
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'ad': _adController.text,
          'email': _emailController.text,
        });

        // **FirebaseAuth'da email güncelleme**
        await user.updateEmail(_emailController.text);

        // **FirebaseAuth'da şifre güncelleme**
        await user.updatePassword(_sifreController.text);

        // **Başarı mesajı göster**
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bilgiler başarıyla güncellendi!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilSayfasi()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Güncelleme başarısız: $error')),
        );
      }
    }
  }

  Future<void> _verileriGetir() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Kullanıcı verilerinin olduğu koleksiyon
          .doc(user.uid) // Kullanıcının UID'si ile belgeyi getir
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        setState(() {
          _adController.text = data['ad'];
          _emailController.text = data['email'];
          _sifreController.text = data['sifre'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      // Aç
      appBar: AppBar(
        title: const Text("Güncelleme Sayfası"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Kullanıcı Bilgileri
            TextField(
              controller: _adController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Ad Soyad",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "E-Posta",
              ),
            ),

            const SizedBox(height: 16), // Başlangıçta şifre gizli olacak

            TextField(
              controller: _sifreController,
              obscureText: _sifreGizli, // Şifreyi gizlemek/göstermek için
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Şifre",
                suffixIcon: IconButton(
                  icon: Icon(
                    _sifreGizli
                        ? Icons.visibility_off
                        : Icons.visibility, // İkon değişimi
                  ),
                  onPressed: () {
                    setState(() {
                      _sifreGizli =
                          !_sifreGizli; // Durumu tersine çevir (göster/gizle)
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 100.0)),
                ElevatedButton.icon(
                  onPressed: _verileriGuncelle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  icon: const Icon(
                    Icons.update_outlined,
                    size: 24, // İkon boyutu büyütüldü
                    color: Colors.white, // İkon rengi beyaz yapıldı
                  ),
                  label: const Text(
                    "Güncelle",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
