import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'detay.dart';
import 'package:intl/intl.dart';

// 📌 Timestamp formatlama fonksiyonu
String formatTarih(dynamic timestamp) {
  if (timestamp is int) {
    DateTime tarih = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('dd MMMM yyyy, HH:mm').format(tarih);
  } else if (timestamp is Timestamp) {
    DateTime tarih = timestamp.toDate();
    return DateFormat('dd MMMM yyyy, HH:mm').format(tarih);
  }
  return "Bilinmeyen Tarih";
}

class GecmisVeriler extends StatelessWidget {
  const GecmisVeriler({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.blue[50], // Açık mavi arka plan
        body: const Center(
          child: Text(
            "Kullanıcı girişi yapılmamış.",
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
        ),
      );
    }

    String uid = currentUser.uid;

    return Scaffold(
      backgroundColor: Colors.blue[50], // Açık mavi ton
      appBar: AppBar(
        title: const Text(
          "Geçmiş Veriler",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey, // Koyu mavi ton
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('data')
            .doc(uid)
            .collection("time")
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Henüz geçmiş veriniz yok.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          var veriler = snapshot.data!.docs;

          return ListView.builder(
            itemCount: veriler.length,
            itemBuilder: (context, index) {
              var veri = veriler[index];
              var timestamp = veri['time'];
              var tarih = formatTarih(timestamp);

              return Card(
                color: Colors.white, // Kart rengi
                shadowColor: Colors.grey[300],
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    "Tarih: $tarih",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey, // Koyu mavi yazı
                    ),
                  ),
                  leading: const Icon(
                    Icons.calendar_today,
                    color: Colors.blueGrey, // Koyu mavi ikon
                  ),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetaySayfasi(
                          veriler: veri,
                          tarih: tarih,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
