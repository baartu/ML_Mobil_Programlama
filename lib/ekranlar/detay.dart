import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetaySayfasi extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> veriler;
  final String tarih;

  const DetaySayfasi({
    super.key,
    required this.veriler,
    required this.tarih,
  });

  @override
  State<DetaySayfasi> createState() => _DetaySayfasiState();
}

class _DetaySayfasiState extends State<DetaySayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Veri Detayları"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Yaş: ${widget.veriler["yas"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Cinsiyet: ${widget.veriler["cinsiyet"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Ağrı Tipi: ${widget.veriler["agritipi"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Dinlenme Kan Basıncı: ${widget.veriler["dinlenmekanbasinci"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Serum Kolesterol Değeri: ${widget.veriler["serumkolesterol"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Açlık Kan Şekeri: ${widget.veriler["aclikkansekeri"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Dinlenme EKG Sonucu: ${widget.veriler["dinlenmeekg"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Ulaşılan Maksimum Kalp Atış Hızı: ${widget.veriler["maxkalphızı"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Egzersize Bağlı Anjina: ${widget.veriler["egzersizebaglianjina"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " ST Depresyonu : ${widget.veriler["stdepresyonu"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " ST Segment Eğimi: ${widget.veriler["stsegmentegimi"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Floroskopi Değeri : ${widget.veriler["floroskopi"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_right, size: 24, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  " Talasemi Durumu : ${widget.veriler["talasemi"]}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
