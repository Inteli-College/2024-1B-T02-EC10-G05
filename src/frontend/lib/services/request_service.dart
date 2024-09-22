import 'dart:io';

import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://pilltrackr.cathena.io/api',
    headers: {
      HttpHeaders.authorizationHeader: 'amanda',
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    connectTimeout: const Duration(seconds: 5),
  ),
);  

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class RequestService {
//   Future<http.Response> sendRequest({
//     required Uri url,
//     required String token,
//     required Map<String, String> headers,
//     required Map<String, dynamic> body,
//   }) async {
//     final combinedHeaders = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//       ...headers,
//     };

//     final response = await http.post(
//       url,
//       headers: combinedHeaders, 
//       body: json.encode(body)
//     );
//     return response;
//   }

//   Future<http.Response> fetchRequests({
//     required Uri url,
//     required String token,
//     required Map<String, String> headers,
//   }) async {
//     final combinedHeaders = {
//       // 'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//       ...headers,
//     };

//     final response = await http.get(
//       url,
//       headers: combinedHeaders,
//     );

//     return response;
//   }
// }
