import 'package:flutter/material.dart';
import 'package:frontend/views/nursery/medicine_request.dart';
import 'package:frontend/views/nursery/other_request.dart';

class HomeNursery extends StatefulWidget {
  @override
  _HomeNurseryState createState() => _HomeNurseryState();
}

class _HomeNurseryState extends State<HomeNursery> {
  String selectedOption = 'Mat/Med';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECF0F3), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                text: 'Olá ',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Enfermeiro', style: TextStyle(color: Colors.purple,)),
                  TextSpan(text: '!\n', style: TextStyle(color: Colors.black,)),
                  TextSpan(text: '\nQual o motivo da sua requisição?', style: TextStyle(fontSize: 38,)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 22.5), // Adiciona margem à esquerda
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5), // Adiciona a moldura
                  borderRadius: BorderRadius.circular(25.0), // Bordas mais circulares
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0), // Bordas mais circulares
                  child: ToggleButtons(
                    isSelected: [selectedOption == 'Mat/Med', selectedOption == 'Outros'],
                    onPressed: (int index) {
                      setState(() {
                        selectedOption = index == 0 ? 'Mat/Med' : 'Outros';
                      });
                    },
                    borderColor: Colors.transparent,
                    selectedBorderColor: Colors.transparent,
                    fillColor: Colors.black,
                    color: Colors.black,
                    selectedColor: Colors.white,
                    constraints: BoxConstraints(minHeight: 70.0, minWidth: 150.0),
                    children: const [
                      Text('Mat/Med'),
                      Text('Outros'),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(), // Adicione um espaço flexível
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedOption == 'Outros') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtherRequest()),
                    );
                  } 
                  else if (selectedOption == 'Mat/Med') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicineRequest()), // Navega para NewRequest
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
                  textStyle: const TextStyle(fontSize: 15),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Entrar'),
              ),
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}
