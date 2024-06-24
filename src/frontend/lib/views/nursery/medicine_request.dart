import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../services/request_service.dart';
import 'dart:convert';
import 'dart:math';
import '../nursery/feedback_request.dart';

class MedicineRequest extends StatefulWidget {
  @override
  _MedicineRequest createState() => _MedicineRequest();
}

class _MedicineRequest extends State<MedicineRequest> {
  // Pyxies List
  final List<String> _pyxies = ['PX-004', 'PX-006', 'PX-008', 'PX-010', 'PX-012'];
  String? _selectedPyxies;
  int? _selectedPyxiesIndex;

  List<String> _medicines = [];
  Map<String, int> _medicineCodes = {}; // Map to hold medicine name and corresponding code
  String? _selectedMedicine;
  int? _productCode; // Product code associated with the selected medicine
  bool _isImmediate = false;
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> _addedMedicines = []; // List to hold added medicines and their codes

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

  void _addMedicine() {
    if (_selectedMedicine != null && _productCode != null) {
      bool isDuplicate = _addedMedicines.any((medicine) => medicine['code'] == _productCode);
      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Este medicamento já foi adicionado.')),
        );
        return;
      }

      setState(() {
        _addedMedicines.add({'name': _selectedMedicine, 'code': _productCode});
        _selectedMedicine = null;
        _productCode = null;
      });
    }
  }

  void _removeMedicine(int index) {
    setState(() {
      _addedMedicines.removeAt(index);
    });
  }

  String _generateRandomId() {
    const int length = 8;
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  Future<void> _sendRequest() async {
    String requestId = _generateRandomId();
    List<String> medicinesList = _addedMedicines.map((medicine) => medicine['name'] as String).toList();

    if (_addedMedicines.isEmpty) {
      print('Nenhum medicamento adicionado.');
      return;
    }

    try {
      var response = await dio.post('/request/create', data: {
        "isUrgent": _isImmediate,
        "description": _descriptionController.text,
        "productCodes": _addedMedicines.map((medicine) => medicine['code']).toList(),
        "pyxisID": 2
      });

      if (response.statusCode == 201) {
        print('Requisição enviada com sucesso.');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedbackRequest(
              requestId: requestId,
              medicinesList: medicinesList,
            ),
          ),
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
              const SizedBox(height: 20),
              const Text(
                'Medicamento Faltante:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedMedicine,
                      onChanged: _selectedPyxies != null ? (newValue) {
                        setState(() {
                          _selectedMedicine = newValue;
                          _productCode = _medicineCodes[newValue];
                        });
                      } : null,
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
                      disabledHint: Text('É necessário selecionar um Pyxis primeiro!'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addMedicine,
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Visibility(
               visible: _addedMedicines.isNotEmpty,
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medicamentos Adicionados:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _addedMedicines
                        .asMap()
                        .entries
                        .map((entry) => Chip(
                              label: Text(entry.value['name']),
                              onDeleted: () => _removeMedicine(entry.key),
                            ))
                        .toList(),
                    ),
                    const SizedBox(height: 20),
                ],
               ),
              ),            
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
      ),
    );
  }
}
