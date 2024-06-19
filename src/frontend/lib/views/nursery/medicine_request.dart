import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../services/request_service.dart';
import 'dart:convert';

class MedicineRequest extends StatefulWidget {
  @override
  _MedicineRequest createState() => _MedicineRequest();
}

class _MedicineRequest extends State<MedicineRequest> {
  //Pyxies List
  final List<String> _pyxies = ['PX-004', 'PX-006', 'PX-008', 'PX-010', 'PX-012'];
  String? _selectedPyxies;
  int? _selectedPyxiesIndex;

  
  
  List<String> _medicines = [];
  Map<String, int> _medicineCodes = {}; // Map to hold medicine name and corresponding code
  List? _selectedMedicines = [null];
  List? _productCodes = [null]; // Product code associated with the selected medicine
  bool _isImmediate = false;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    try {
      var response = await dio.get('/client/getPreRequestData');
      setState(() {
        List<dynamic> products = response.data['products'];
        _medicines = products.map((product) => product['Name'] as String).toList();
        for (var product in products) {
          _medicineCodes[product['Name']] = product['Code'] as int;
        }
      });
    } catch (e) {
      print('Erro ao buscar medicamentos: $e');
    }
  }

  Future<void> _sendRequest() async {
    String requestId = 'PR-0081P';
    String pyxisLocation = 'MS1347 - 14º Andar';
    print(_selectedPyxies);

    if(_selectedMedicines.any((medicine) => medicine == null) || _productCodes.any((code) => code == null)){
      
    }
    try {
      var response = await dio.post('/request/create', data: {
        "isUrgent":  _isImmediate,
        "description": _descriptionController.text,
        "productCodes":  [_productCode],
        "pyxisID": 2
      });

      if (response.statusCode == 201) {
        print('Requisição enviada com sucesso.');
        Navigator.pushNamed(
          context,
          '/feedbackRequest',
          arguments: {'requestId': requestId, 'pyxisLocation': pyxisLocation},
        );
      } else {
        print('Erro ao enviar requisição: ${response.statusMessage}');
      }
    } catch (e) {
      print('Erro ao enviar requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECF0F3),
      appBar: AppBar(
        backgroundColor: Color(0xFFECF0F3),
        title: const Text(
          'Medicamentos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const Text(
                'Qual o Pyxies da Requisição:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _selectedPyxies,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPyxies = newValue;
                    _selectedPyxiesIndex = _pyxies.indexOf(newValue!);
                    print('Selected Pyxies Index: $_selectedPyxiesIndex');
                  });
                },
                items: _pyxies.map((pyxies) {
                  return DropdownMenuItem(
                    value: pyxies,
                    child: Text(pyxies),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const Text(
                'Medicamento Faltante:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedMedicine,
                onChanged: _selectedPyxies != null ? (newValue) {
                  setState(() {
                    _selectedMedicine = newValue;
                    _productCode = _medicineCodes[newValue];
                  });
                } : null ,
                items: _medicines.map((medicine) {
                  return DropdownMenuItem(
                    value: medicine,
                    child: Text(medicine),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                disabledHint: Text('É necessário selecionar em qual Pyxies você está primeiro'),
              ),
              const SizedBox(height: 20),

              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.purple,
                ),
                onPressed: () {
                  // Lógica para adicionar um novo medicamento
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar medicamento'),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Precisa Imediatamente?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: _isImmediate,
                    onChanged: (newValue) {
                      setState(() {
                        _isImmediate = newValue;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),

              const Text(
                'Descrição Adicional:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.black, width: 3.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _sendRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
                    textStyle: const TextStyle(fontSize: 15),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
