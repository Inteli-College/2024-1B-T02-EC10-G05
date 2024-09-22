import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../services/request_service.dart';
import '../../widgets/list_tile_nursery.dart';

class MyRequests extends StatefulWidget {
  // final String userToken;

  const MyRequests({
    Key? key,
    // required this.userToken,
  }) : super(key: key);

  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  List<Map<String, dynamic>> _requests = [];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      var response = await dio.get('/request/user');
      setState(() {
        _requests = List<Map<String, dynamic>>.from(response.data);
      });
    } catch (e) {
      print('Erro ao buscar requisições: $e');
    }
  }

  final _random = new Random();
  var statusList = ['Aguardando Aprovação','Aprovado','Rejeitado'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Requisições Feitas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFECF0F3),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFECF0F3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _requests.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _requests.length,
                itemBuilder: (context, index) {
                  var request = _requests[index];
                  var productNames = (request['Products'] as List<dynamic>)
                      .map((product) => product['Name'] as String)
                      .join(', ');
                  var element = statusList[_random.nextInt(statusList.length)];

                  return ListTileNursery(
                    title: 'Requisição #${request['ID']}',
                    subtitle: '$productNames - ${request['IsUrgent']}',
                    item: productNames,
                    requestId: request['ID'],
                    // isImmediate: request['IsUrgent'],
                  );
                },
              ),
      ),
    );
  }
}
