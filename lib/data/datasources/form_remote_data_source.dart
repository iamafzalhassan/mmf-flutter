import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mmf/domain/entities/main_form.dart';

abstract interface class FormRemoteDataSource {
  Future<void> submitForm(MainForm mainForm);
}

class FormRemoteDataSourceImpl implements FormRemoteDataSource {
  static const String _scriptUrl = 'https://script.google.com/macros/s/AKfycbxkIhMQDig84ZegqcJDqfIS3-lxxiKNA9W1rW2t5fj4k87kA0PdOFkhB3ifjFT6hXX8zw/exec';

  final http.Client _client;

  FormRemoteDataSourceImpl(this._client);

  @override
  Future<void> submitForm(MainForm mainForm) async {
    final uri = Uri.parse(_scriptUrl).replace(queryParameters: {'data': base64Url.encode(utf8.encode(jsonEncode(mainForm.toJson()))), 'method': 'submit'});
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 30), onTimeout: () => throw Exception('Request timeout - please try again'));
    } on http.ClientException {
      throw Exception('Network error. Please check your connection.');
    }
    if (response.statusCode != 200 && response.statusCode != 302) throw Exception('Submission failed: ${response.statusCode}');
    final Object? body;
    try {
      body = jsonDecode(response.body);
    } on FormatException {
      return;
    }
    if (body is Map && body['status'] == 'success') return;
    if (body is Map && body['status'] == 'error') throw Exception(body['message'] ?? 'Submission failed');
    throw Exception('Submission failed: ${response.statusCode}');
  }
}
