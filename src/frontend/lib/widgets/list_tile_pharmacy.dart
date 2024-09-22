import 'package:flutter/material.dart';

class ListTilePharmacy extends StatefulWidget {
  // final Request request;
  final int id;
  final String title;
  final String subtitle;
  final String status;

  const ListTilePharmacy({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status
    // required this.request,
  });

  @override
  _ListTilePharmacyState createState() => _ListTilePharmacyState();
}

class _ListTilePharmacyState extends State<ListTilePharmacy> {
  // late Request _request;
  late int _id;
  late String _title;
  late String _subtitle;
  late String _status = 'Aguardando Aprovação';


  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _title = widget.title;
    _subtitle = widget.subtitle;
    _status = widget.status;
  }

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_title),
          
          content:
            RichText(
              text: TextSpan(
                text: 'A Requisição foi encaminhada para a Farmácia Central \n\n',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Items: ', style: const TextStyle(fontWeight: FontWeight.normal,)),
                  TextSpan(text: 'Itens 1 e 2 \n', style: TextStyle(color: Colors.black,)),
                  TextSpan(text: 'Status: ', style: TextStyle(color: Colors.black)),
                  TextSpan(
                    text: _status, 
                    style: TextStyle(
                      color:  _status == 'Aguardando Aprovação' ? Colors.orange.shade800 :
                              _status == 'Aprovado' ? Colors.green :
                              _status == 'Rejeitado' ? Colors.red : Colors.black,)),
                  
                ],
              ),
            ), 
          
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Chat'),
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o modal
                // Adicionar tela de chat para levar o usuário após clicar
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SecondScreen()),
                // );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_title),
      subtitle: Text(_subtitle),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
              text: TextSpan(
                text: '$_id °',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
      // leading: const Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Icon(Icons.check_box_outlined)
      //   ],
      // ),
      // title: Text(_title),
      // subtitle: Text(_subtitle),
      trailing: const SizedBox(
        height: double.infinity,
        child: Icon(Icons.drag_handle),
      ),
      onTap: () => _showModal(context),
      isThreeLine: true,
    );
  }
}