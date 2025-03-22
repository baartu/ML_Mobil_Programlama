import 'package:flutter/material.dart';
import '/ekranlar/guncelle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilSayfasi extends StatefulWidget {
  const ProfilSayfasi({super.key});

  @override
  State<ProfilSayfasi> createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  // Seçilen resmin dosya yolu
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
      appBar: AppBar(
        title: const Text("Profilim"),
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
              readOnly: true,
              controller: _adController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Ad Soyad",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              readOnly: true,
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "E-Posta",
              ),
            ),

            const SizedBox(height: 16),

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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GuncellemeSayfasi()),
                    );
                  },
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
