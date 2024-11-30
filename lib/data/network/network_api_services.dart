import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:depd_2024_mvvm/data/app_exception.dart';
import 'package:depd_2024_mvvm/data/network/base_api_services.dart';
import 'package:depd_2024_mvvm/shared/shared.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices implements BaseApiServices {
  @override
  Future getApiResponse(String endpoint) async {
    dynamic responseJson;
    try {
      final uri = Uri.https(
          Const.baseUrl,
          Const.apiPath + endpoint.split('?')[0], 
          endpoint.contains('?') 
              ? Uri.splitQueryString(
                  endpoint.split('?')[1]) 
              : null);

      final response = await http.get(uri, headers: {
        'key': Const.apiKey,
      });
      print("URL: $uri");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    }
    return responseJson;
  }

  @override
Future postApiResponse(String endpoint, dynamic data) async {
  dynamic responseJson;
  try {
    final response = await http.post(
      Uri.https(Const.baseUrl, Const.apiPath + endpoint),
      headers: {
        'key': Const.apiKey,
        'content-type': 'application/x-www-form-urlencoded',
      },
      body: data
    );
    print("URL: ${Uri.https(Const.baseUrl, Const.apiPath + endpoint)}");
    print("Data: $data");
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    responseJson = returnResponse(response);
  } on SocketException {
    throw NoInternetException('');
  }
  return responseJson;
}

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while communicating with server');
    }
  }
}
