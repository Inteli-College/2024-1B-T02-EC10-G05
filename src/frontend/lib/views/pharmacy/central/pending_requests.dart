import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend/services/pharmacy_request_service.dart';
import 'package:frontend/widgets/list_tile_pharmacy.dart';
import 'package:frontend/widgets/list_tile_nursery.dart';

//random
import "dart:math";

class PendingRequests extends StatefulWidget {
  @override
  _PendingRequestsState createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  List<Map<String, dynamic>> _requests = [];
  List<Map<String, dynamic>> _finishedRequests = []; // Lista para armazenar requisições finalizadas
  List<int> _requestOrder = []; // Lista para armazenar a ordem dos IDs das requisições

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      var response = await dio.get('/request/getAll');
      setState(() {
        _requests = List<Map<String, dynamic>>.from(response.data);
        _requestOrder = _requests.map((request) => request['ID'] as int).toList();
      });
    } catch (e) {
      print('Erro ao buscar requisições: $e');
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final request = _requests.removeAt(oldIndex);
      _requests.insert(newIndex, request);

      // Atualizar a ordem dos IDs
      final requestId = _requestOrder.removeAt(oldIndex);
      _requestOrder.insert(newIndex, requestId);
      print(_requestOrder[1]);
    });
  }

  void _sendRequests() {
    setState(() {
      _finishedRequests.addAll(_requests); // Adiciona todas as requisições pendentes às finalizadas
      _requests.clear(); // Limpa as requisições pendentes
      _requestOrder.clear(); // Limpa a ordem das requisições pendentes
    });
  }

  final _random = Random();
  var statusList = ['Aguardando Aprovação', 'Aprovado', 'Rejeitado'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de abas
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Requisições',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFFECF0F3),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pendentes'),
              Tab(text: 'Finalizadas'),
            ],
          ),
        ),
        backgroundColor: Color(0xFFECF0F3),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: _requests.isEmpty
                        ? Center(child: Text('Nenhuma Requisição Pendente'))
                        : ReorderableListView(
                            onReorder: _onReorder,
                            children: _requests.asMap().entries.map((entry) {
                              var index = entry.key;
                              var request = entry.value;
                              var productNames = (request['Products'] as List<dynamic>)
                                  .map((product) => product['Name'] as String)
                                  .join(', ');

                              var element = statusList[_random.nextInt(statusList.length)];

                              return ListTilePharmacy(
                                key: ValueKey(request['ID']),
                                id: _requestOrder.isNotEmpty ? _requestOrder[index] : 0,
                                title: 'Requisição #${request['ID']}',
                                subtitle: '$productNames - ${request['Description']}',
                                status: element,
                              );
                            }).toList(),
                          ),
                  ),
                  ElevatedButton(
                    onPressed: _sendRequests,
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ),
            // Tela de requisições finalizadas
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _finishedRequests.isEmpty
                  ? Center(child: Text('Nenhuma requisição finalizada'))
                  : ListView.builder(
                      itemCount: _finishedRequests.length,
                      itemBuilder: (context, index) {
                        var request = _finishedRequests[index];
                        var productNames = (request['Products'] as List<dynamic>)
                            .map((product) => product['Name'] as String)
                            .join(', ');

                        return ListTilePharmacy(
                          key: ValueKey(request['ID']),
                          id: _requestOrder.isNotEmpty ? _requestOrder[index] : 0,
                          title: 'Requisição #${request['ID']}',
                          subtitle: '$productNames - ${request['Description']}',
                          status: 'Aprovado',
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
