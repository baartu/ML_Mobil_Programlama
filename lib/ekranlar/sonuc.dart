import 'package:flutter/material.dart';
import 'package:deneme/services/api_services.dart';

class SonucSayfasi extends StatefulWidget {
  final Map<String, dynamic> inputData;

  const SonucSayfasi({Key? key, required this.inputData}) : super(key: key);

  @override
  _SonucSayfasiState createState() => _SonucSayfasiState();
}

class _SonucSayfasiState extends State<SonucSayfasi> {
  int? prediction;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPrediction();
  }

  Future<void> _fetchPrediction() async {
    ApiService apiService = ApiService();
    int? result = await apiService.predictHeartDisease(widget.inputData);

    print("API Cevabı: $result");

    setState(() {
      prediction = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahmin Sonucu')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : prediction != null
                ? _buildResultCard()
                : _buildErrorCard(),
      ),
    );
  }

  Widget _buildResultCard() {
    bool isHighRisk = prediction == 1;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isHighRisk ? Colors.red.shade100 : Colors.green.shade100,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHighRisk ? Icons.warning_rounded : Icons.check_circle_rounded,
            color: isHighRisk ? Colors.red : Colors.green,
            size: 60,
          ),
          const SizedBox(height: 10),
          Text(
            isHighRisk
                ? "Kalp Hastalığı Riski Yüksek!"
                : "Kalp Hastalığı Riski Düşük!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isHighRisk ? Colors.red.shade900 : Colors.green.shade900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isHighRisk
                ? "Doktorunuza danışmanız önerilir."
                : "Her şey yolunda görünüyor! Sağlıklı yaşamaya devam edin.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text("Tekrar Test Yap"),
            style: ElevatedButton.styleFrom(
              backgroundColor: isHighRisk ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.grey, size: 60),
          const SizedBox(height: 10),
          const Text(
            "Tahmin alınamadı!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.refresh),
            label: const Text("Tekrar Dene"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }
}
