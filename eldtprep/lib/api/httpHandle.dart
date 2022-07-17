// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

class HandleHTTP {
  Future getData(Uri url) async {
    http.Response _response;
    dynamic _finalResponse;

    try {
      _response = await http.get(
        url,
        headers: {"Accept": "application/json; charset=UTF-8"},
      );

      if (_response.statusCode == 200) {
        _finalResponse = jsonDecode(_response.body);
      } else {
        _finalResponse = {'responseMessage': 'ERROR'};
        throw Exception("Error ${_response.statusCode}");
      }
    } catch (e) {
      _finalResponse = {'error': e.toString()};
      print(e.toString());
    }

    return _finalResponse;
  }

  Future<String> multipartRequest(http.MultipartRequest _request) async {
    http.Response _response;
    String _finalResponse;

    try {
      _response = await http.Response.fromStream(await _request.send());

      if (_response.statusCode == 201 || _response.statusCode == 200) {
        _finalResponse = "SUCCESS";
      } else {
        _finalResponse = _response.statusCode.toString();
        throw Exception("Error ${_response.statusCode}");
      }
    } catch (e) {
      _finalResponse = e.toString();
      print(e.toString());
    }

    return _finalResponse;
  }

  Future postData(Uri url, Object body) async {
    http.Response _response;
    dynamic _finalResponse;

    try {
      _response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (_response.statusCode == 201) {
        _finalResponse = jsonDecode(_response.body);
      } else {
        throw Exception("Error ${_response.statusCode}");
      }
    } catch (e) {
      _finalResponse = {"e": e.toString()};
      print(e.toString());
    }

    return _finalResponse;
  }
}
