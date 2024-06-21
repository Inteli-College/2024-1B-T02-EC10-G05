import 'dart:io';

import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://pilltrackr.cathena.io/api',
    headers: {
      HttpHeaders.authorizationHeader: 'admin',
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    connectTimeout: const Duration(seconds: 5),
  ),
);  


// import 'dart:io';

// import 'package:dio/dio.dart';
// import '../models/request.dart';

// class RequestService {
//   final Dio _dio = Dio();

//   Future<List<Request>> fetchRequests() async {
//     // Substitua a URL abaixo pela URL real da sua API
//     final dio = Dio(
//       BaseOptions(
//         baseUrl:'https://pilltrackr.cathena.io/api', 
//         headers: {     
//            HttpHeaders.authorizationHeader: 'amanda',
//            HttpHeaders.contentTypeHeader: 'application/json'}));
//     final response = await dio.get('/request/user');

//     if (response.statusCode == 200) {
//       return (response.data as List)
//           .map((json) => Request.fromJson(json))
//           .toList();
//     } else {
//       throw Exception('Failed to load requests');
//     }
//   }

//   Future<void> sendRequests(List<Request> requests) async {
//     final url = '';
//     final response = await _dio.post(
//       url,
//       data: requests.map((r) => r.toJson()).toList(),
//       options: Options(headers: {'Content-Type': 'application/json'}),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to send requests');
//     }
//   }
// }
