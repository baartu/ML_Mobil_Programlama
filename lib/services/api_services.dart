import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.83.99:8080";
  double _safeParse(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      print("Uyarı: Boş veya null değer bulundu, 0.0 olarak ayarlandı.");
      return 0.0;
    }

    try {
      return double.parse(value.toString().trim());
    } catch (e) {
      print(
          "Hata: '$value' değeri double'a çevrilemedi, 0.0 olarak ayarlandı.");
      return 0.0;
    }
  }

  double _extractNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      print("Uyarı: Boş veya null değer bulundu, 0.0 olarak ayarlandı.");
      return 0.0;
    }

    // Sayıyı yakalamak için RegExp kullanıyoruz
    final match = RegExp(r'^\d+').firstMatch(value.trim());
    if (match != null) {
      return double.parse(match.group(0)!);
    } else {
      print(
          "Hata: '$value' değeri double'a çevrilemedi, 0.0 olarak ayarlandı.");
      return 0.0;
    }
  }

  Future<int?> predictHeartDisease(Map<String, dynamic> inputData) async {
    try {
      final uri = Uri.parse('$baseUrl/predict');

      // ✅ Debug için verileri kontrol edelim
      print("Gelen inputData: $inputData");

      Map<String, dynamic> cleanedData = {
        "age": _safeParse(inputData["age"]),
        "sex": inputData["sex"] == "Erkek" ? 1.0 : 0.0,
        "cp": inputData["cp"],
        "trestbps": _safeParse(inputData["trestbps"]),
        "chol": _safeParse(inputData["chol"]),
        "fbs": inputData["fbs"] != null &&
                inputData["fbs"].toString().contains("1")
            ? 1.0
            : 0.0,
        "restecg": _extractNumber(inputData["restecg"]),
        "thalach": _safeParse(inputData["thalach"]),
        "exang": inputData["exang"] != null &&
                inputData["exang"].toString().contains("1")
            ? 1.0
            : 0.0,
        "oldpeak": _safeParse(inputData["oldpeak"]),
        "slope": _extractNumber(inputData["slope"]),
        "ca": _safeParse(inputData["ca"]),
        "thal": _extractNumber(inputData["thal"]),
      };

      // ✅ JSON formatını kontrol edelim
      print("Gönderilen JSON: ${jsonEncode(cleanedData)}");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(cleanedData),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["prediction"];
      } else {
        print("Hata: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Hata oluştu: $e");
      return null;
    }
  }
}
