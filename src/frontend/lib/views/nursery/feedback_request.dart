import 'package:flutter/material.dart';
import 'package:frontend/views/nursery/my_requests.dart';

class FeedbackRequest extends StatelessWidget {
  final String requestId;
  final List<String> medicinesList;

  FeedbackRequest({required this.requestId, required this.medicinesList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECF0F3),
      appBar: AppBar(
        backgroundColor: Color(0xFFECF0F3),
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0, // Ajusta a altura da AppBar para acomodar o padding
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            RichText(
              text: TextSpan(
                text: 'A ',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Requisição $requestId ',
                      style: const TextStyle(color: Colors.green)),
                  TextSpan(
                      text: 'foi feita com sucesso!',
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Mat/Med adicionados:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            ...medicinesList.map((medicine) => Text(
                  '- $medicine',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                )).toList(),
            const SizedBox(height: 70),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyRequests(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                  textStyle: TextStyle(fontSize: 15),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Ir para requisições feitas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}