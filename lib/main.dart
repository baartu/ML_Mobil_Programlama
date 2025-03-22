import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ekranlar/giris.dart';
import 'ekranlar/kayit.dart';
import 'ekranlar/bilgi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ekranlar/profil.dart';
import 'ekranlar/gecmisveriler.dart';
import 'ekranlar/sonuc.dart';
import 'ekranlar/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'i başlat
  runApp(const RunMyApp());
}

class RunMyApp extends StatelessWidget {
  const RunMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retrieve Text Input',
      theme: ThemeData(primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController textyas = TextEditingController();
  TextEditingController textController4 = TextEditingController();
  TextEditingController textController5 = TextEditingController();
  TextEditingController textController8 = TextEditingController();

  String? selectedGender;
  CPValues? selectedcp;
  FBSValues? selectedfbs;
  String? selectedekg;
  String? selectedexang;
  String? selectedeslope;
  String? selectedca;
  String? selectedthal;
  String? selecteddep;

  Future<void> saveData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid; // Kullanıcının UID'sini al
      final dataRef = FirebaseFirestore.instance
          .collection("data")
          .doc(uid)
          .collection("time")
          .doc();

      await dataRef.set({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        "yas": textyas.text,
        "dinlenmekanbasinci": textController4.text,
        "serumkolesterol": textController5.text,
        "maxkalphızı": textController8.text,
        "cinsiyet": selectedGender,
        "agritipi": selectedcp?.valueTR,
        "aclikkansekeri": selectedfbs,
        "dinlenmeekg": selectedekg,
        "egzersizebaglianjina": selectedexang,
        "stsegmentegimi": selectedeslope,
        "floroskopi": selectedca,
        "talasemi": selectedthal,
        "stdepresyonu": selecteddep,
        "time": FieldValue.serverTimestamp()
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veri başarıyla kaydedildi!'),
          duration: Duration(seconds: 3), // 3 saniye sonra otomatik kapanır
          action: SnackBarAction(
            label: 'Tamam',
            onPressed: () {
              // Kullanıcı "Tamam" butonuna basarsa bir şey yapabilirsin.
            },
          ),
        ),
      );
    }
  } //kullanıcın girdiği bilgileri kaydetme method

  void showBartuDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[200],
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Kapat"),
            ),
          ],
        );
      },
    );
  } //info için parametreli method

  @override
  void dispose() {
    textyas.dispose();
    textController4.dispose();
    textController5.dispose();
    textController8.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('KVH Risk Formu'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_outlined),
            onPressed: () {
              // Drawer'ı açar
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.blueGrey, // Arka plan rengi
              padding: const EdgeInsets.only(
                  top: 50, bottom: 20, left: 10), // Üst ve alt boşluk
              child: Row(
                children: [
                  Image.asset(
                    "assets/heartify1.png", // Logoyu ekle
                    height: 80,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Heartify",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ), // Görsel ve yazı arasındaki mesafe
                  )
                ],
              ),
            ),
            if (user != null && user.uid.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_2_outlined),
                      title: const Text('Kişisel Bilgiler'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilSayfasi()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.history_outlined),
                      title: const Text('Geçmiş Verilerim'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GecmisVeriler()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outlined),
                      title: const Text('Genel Bilgilendirme'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BilgilendirmeSayfasi()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.exit_to_app_outlined),
                      title: const Text('Çıkış Yap'),
                      onTap: () async {
                        await FirebaseAuth.instance
                            .signOut(); // Kullanıcıyı çıkış yap
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RunMyApp()),
                          (Route<dynamic> route) =>
                              false, // Tüm sayfaları kapat
                        );
                      },
                    ),
                  ],
                ),
              ),
            if (user == null || user.uid.isEmpty)
              Expanded(
                  child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outlined),
                    title: const Text('Genel Bilgilendirme'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BilgilendirmeSayfasi()),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login_outlined),
                    label: const Text("Giriş Yap"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GirisSayfasi()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.black, // Hem yazı hem ikon rengi siyah
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person_add_outlined),
                    label: const Text("Kayıt Ol"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const KayitSayfasi()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Colors.black, // Hem yazı hem ikon rengi siyah
                    ),
                  ),
                ],
              ))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Sola hizalama
              children: [
                SizedBox(
                  child: TextFormField(
                    validator: (String? value) {
                      if (value == null) {
                        return 'Bu alan zorunludur';
                      }
                      return null;
                    },
                    controller: textyas,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Yaşınızı Girin",
                    ),
                  ),
                ), //yaş
                const SizedBox(height: 16),
                // Seçilen cinsiyeti tutan değişken

                DropdownButtonFormField<String>(
                  value: selectedGender,
                  validator: (String? value) {
                    if (value == null) {
                      return 'Bu alan zorunludur';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Cinsiyet Seçin",
                  ),
                  items: ["Erkek", "Kadın"]
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ), //cinsiyet
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<CPValues>(
                        value: selectedcp,
                        validator: (CPValues? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Ağrı Tipini Seçin",
                        ),
                        items: CPValues.values
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value.valueTR),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedcp = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "Ağrı Tipi Türleri",
                        "Tipik Anjina: Göğüs ağrısı, genellikle eforla ortaya çıkar ve dinlenmekle geçer.\n\n"
                            "Atipik Anjina: Tipik anjinadan farklı olarak bazen istirahat halindeyken görülebilir.\n\n"
                            "Anjine Dışı Ağrı: Göğüs ağrısının kalp kaynaklı olmadığı düşünülmektedir.\n\n"
                            "Asemptomatik: Kişide belirgin bir göğüs ağrısı şikayeti yoktur ancak hastalık olabilir.",
                      ),
                    ),
                  ],
                ), //ağrı tipi
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (String? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        controller: textController4,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Dinlenme Kan Basıncını Girin",
                        ),
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "Dinlenme Kan Basıncı",
                        "Bu alan, kişinin dinlenme halindeki kan basıncını mmHg cinsinden girmesi içindir. Normal değerler genellikle 120/80 mmHg civarındadır.",
                      ), // Butona basınca açıklama açılacak
                    ),
                  ],
                ), //dinlenme kan basıncı
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (String? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        controller: textController5,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Serum Kolesterol Değerini Girin (mg/dl)",
                        ),
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "Serum Kolesterol Değeri",
                        "Serum kolesterol değeri, kanınızdaki toplam kolesterol miktarını mg/dl cinsinden gösterir.\n"
                            "✔ Normal: < 200 mg/dl\n"
                            "⚠ Sınırda Yüksek: 200-239 mg/dl\n"
                            "❌ Yüksek: 240+ mg/dl\n\n"
                            "Bu değer, kardiyovasküler hastalık riskinizi değerlendirmede önemlidir.",
                      ), // Butona basınca açıklama açılacak
                    ),
                  ],
                ), //serum kolesterol değeri
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<FBSValues>(
                        validator: (FBSValues? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        value: selectedfbs,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:
                              "Açlık kan şekeri > 120 mg/dl (1 = Doğru, 0 = Yanlış)",
                        ),
                        items: FBSValues.values
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value.valueTR),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedfbs = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "Açlık Kan Şekeri (FBS)",
                        "Açlık kan şekeri (FBS), kişinin açken ölçülen kan şekeri seviyesidir.\n\n"
                            "✔ Normal: < 100 mg/dl\n"
                            "⚠ Hafif Yüksek (Prediyabet): 100-125 mg/dl\n"
                            "❌ Diyabet: 126 mg/dl ve üzeri\n\n"
                            "Bu seçenekte:\n"
                            "➡ 1 = Açlık kan şekeri 120 mg/dl'nin ÜZERİNDE\n"
                            "➡ 0 = Açlık kan şekeri 120 mg/dl'nin ALTINDA",
                      ), // Butona basınca açıklama açılacak // Butona basınca açıklama açılacak
                    ),
                  ],
                ), //açlık kan şekeri
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        validator: (String? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        value: selectedekg,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Dinlenme EKG Sonucu",
                        ),
                        items: [
                          "0 = Normal",
                          "1 = ST-T anormalliği",
                          "2 = Sol ventrikül hipertrofisi"
                        ]
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedekg = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "Dinlenme EKG Sonucu",
                        "Elektrokardiyografi (EKG) kalbin elektriksel aktivitesini ölçer.\n\n"
                            "✅ **0 = Normal**: Kalpte anormal bir elektriksel aktivite yok.\n"
                            "⚠ **1 = ST-T Anormalliği**: ST segmenti veya T dalgasında anormallikler görülür. Kalp hastalığı belirtisi olabilir.\n"
                            "❌ **2 = Sol Ventrikül Hipertrofisi**: Kalbin sol ventrikülünde kalınlaşma olabilir. Hipertansiyonla ilişkili olabilir.",
                      ),
                    ),
                  ],
                ), //dinlenme ekg
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (String? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        controller: textController8,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Ulaşılan Maksimum Kalp Atış Hızı",
                        ),
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "Maksimum Kalp Atış Hızı Nedir?",
                        "Maksimum kalp atış hızı (MHR), egzersiz sırasında ulaşılan en yüksek kalp atış hızıdır.\n\n"
                            "🫀 Genellikle **220 - yaş** formülüyle hesaplanır.\n"
                            "📌 Örneğin, 40 yaşındaki biri için **MHR = 220 - 40 = 180 atım/dakika** olur.\n"
                            "⚠ Yüksek değerler kalp stresini gösterebilir, düşük değerler kondisyon eksikliğine işaret edebilir.",
                      ),
                    ),
                  ],
                ), //ulaşılan max kalp hızı
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedexang,
                        validator: (String? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Egzersize Bağlı Anjina",
                        ),
                        items: ["1 = Evet", "0 = Hayır"]
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedexang = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "Egzersize Bağlı Anjina Nedir?",
                        "Egzersize bağlı anjina, fiziksel aktivite sırasında göğüs ağrısı veya rahatsızlık hissidir.\n\n"
                            "⚠ **1 = Evet** → Kişi egzersiz sırasında göğüs ağrısı hisseder.\n"
                            "✅ **0 = Hayır** → Kişide egzersize bağlı göğüs ağrısı yoktur.\n\n"
                            "📌 Bu belirti, koroner arter hastalığı için önemli bir göstergedir.",
                      ),
                    ),
                  ],
                ), //egzersize bağlı anjina
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selecteddep,
                        validator: (String? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ST Depresyonu",
                        ),
                        items: ["Var", "Yok"]
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selecteddep = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "ST Depresyonu Nedir?",
                        "ST depresyonu, elektrokardiyogramda (EKG) ST segmentinin normalden düşük olmasıdır.\n\n"
                            "⚠ **Var** → ST segmenti düşüktür, kalp hastalığı riski olabilir.\n"
                            "✅ **Yok** → ST segmentinde anormallik yoktur.\n\n"
                            "📌 ST depresyonu genellikle miyokard iskemisi (kalbe yeterli oksijen gitmemesi) ile ilişkilidir.",
                      ), // Butona basınca açıklama açılacak
                    ),
                  ],
                ), //st depresyonu
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedeslope,
                        validator: (String? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "ST segment eğimi",
                        ),
                        items:
                            ["0 = Yukarı eğimli", "1 = Düz", "2 = Aşağı eğimli"]
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedeslope = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "ST Segment Eğim Türleri",
                        "ST segment eğimi, egzersiz sonrası ST segmentinin eğimini gösterir.\n\n"
                            "📈 **0 = Yukarı eğimli** → Normal ve sağlıklı bir durumdur.\n"
                            "➖ **1 = Düz** → Orta riskli bir durumdur, dikkat edilmelidir.\n"
                            "📉 **2 = Aşağı eğimli** → Miyokard iskemisi veya koroner arter hastalığını işaret edebilir.\n\n"
                            "⚠ Düz veya aşağı eğimli ST segmenti, kalp hastalığı riskini artırabilir.",
                      ), // Butona basınca açıklama açılacak
                    ),
                  ],
                ), //st segment eğimi
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedca,
                        validator: (String? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:
                              "Floroskopi ile renklendirilen büyük damar sayısı (0-3)",
                        ),
                        items: ["0", "1", "2", "3"]
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedca = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "Büyük Damar Sayısı",
                        "Floroskopi ile renklendirilen büyük damar sayısı, kalpteki tıkalı veya daralmış damarları gösterir.\n\n"
                            "🔵 **0 = Tıkalı veya daralmış damar yoktur.**\n"
                            "🟡 **1 = Bir büyük damarda tıkanıklık vardır.**\n"
                            "🟠 **2 = İki büyük damarda tıkanıklık vardır.**\n"
                            "🔴 **3 = Üç veya daha fazla büyük damarda tıkanıklık vardır.**\n\n"
                            "⚠ Yüksek değerler, kalp hastalığı riskinin arttığını gösterebilir.",
                      ), // Butona basınca açıklama açılacak
                    ),
                  ],
                ), //floroskopi
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedthal,
                        validator: (String? value) {
                          if (value == null) {
                            return 'Bu alan zorunludur';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Talasemi Durumu",
                        ),
                        items: [
                          "0 = Hata",
                          "1 = Sabit defekt",
                          "2 = Normal",
                          "3 = Geri dönüşlü defekt"
                        ]
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedthal = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 1), // Boşluk bırak
                    // Bilgi (info) butonu
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
                      onPressed: () => showBartuDialog(
                        "Talasemi Durumu",
                        "Talasemi durumu, kan hücrelerinin oksijen taşıma yeteneğini etkileyen genetik bir bozukluktur.\n\n"
                            "⚠ **Kodların Anlamları:**\n"
                            "❌ **0 = Hata** → Veri eksikliği veya hatalı giriş.\n"
                            "🟠 **1 = Sabit Defekt** → Kalıcı kan hücresi anomalileri mevcut.\n"
                            "✅ **2 = Normal** → Talasemi yok, kan hücreleri normal çalışıyor.\n"
                            "🔄 **3 = Geri Dönüşlü Defekt** → Zamanla düzelebilen anormallikler olabilir.\n\n"
                            "⚠ Bu değerler, hastanın klinik durumu hakkında bilgi verir.",
                      ), // Butona basınca açıklama açılacak
                    ),
                  ],
                ), //talasemi
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 50.0)),
                    OutlinedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SonucSayfasi(
                                        inputData: {
                                          "age": double.parse(
                                              textyas.text), // String -> double
                                          "sex": selectedGender,
                                          "cp": selectedcp?.index,
                                          "trestbps": double.parse(
                                              textController4.text),
                                          "chol": double.parse(
                                              textController5.text),
                                          "fbs": selectedfbs?.index,
                                          "restecg": selectedekg,
                                          "thalach": double.parse(
                                              textController8.text),
                                          "exang": selectedexang,
                                          "oldpeak": double.parse(
                                              textController8.text),
                                          "slope": selectedeslope,
                                          "ca": selectedca,
                                          "thal": selectedthal,
                                        },
                                      )),
                            );
                            saveData();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: Colors.white,
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            iconColor: Colors.white,
                            backgroundColor: Colors.blueGrey),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //Icon(Icons.file_upload_outlined, size: 20),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Gönder"),
                          ],
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum CPValues {
  tipikAnjina("Tipik Anjina"),
  atipikAnjina("Atipik Anjina"),
  anjineDisiAgri("Anjine Dışı Ağrı"),
  asemptomatik("Asemptomatik");

  final String valueTR;
  const CPValues(this.valueTR);
}

enum FBSValues {
  yanlis("0 (Yanlış)"),
  dogru("1 (Doğru)");

  final String valueTR;
  const FBSValues(this.valueTR);
}
