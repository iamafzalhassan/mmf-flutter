import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mmf/core/error/submission_exception.dart';
import 'package:mmf/data/datasources/form_remote_data_source.dart';
import 'package:mmf/domain/entities/family_member.dart';
import 'package:mmf/domain/entities/main_form.dart';

class FakeHttpClient extends http.BaseClient {
  final bool throwsClientException;

  final int statusCode;

  final String body;

  final List<http.BaseRequest> requests = <http.BaseRequest>[];

  FakeHttpClient({this.throwsClientException = false, this.statusCode = 200, this.body = '{"status":"success"}'});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requests.add(request);
    if (throwsClientException) throw http.ClientException('Failed to fetch');
    return http.StreamedResponse(Stream<List<int>>.value(utf8.encode(body)), statusCode);
  }
}

void main() {
  final MainForm form = MainForm(address: 'No 12, Main Street', admissionNo: 'A1', familiesCount: '1', ownership: 'Own', refNo: 'KJM-123456', route: 'Walewala', familyMembers: const <FamilyMember>[FamilyMember(fullName: 'Mohamed Rizwan')]);

  Future<SubmissionException> failure(FakeHttpClient client) async {
    try {
      await FormRemoteDataSourceImpl(client).submitForm(form);
    } on SubmissionException catch (e) {
      return e;
    }
    fail('Expected a SubmissionException');
  }

  group('FormRemoteDataSourceImpl.submitForm', () {
    test('sends the household as base64url JSON in a GET request', () async {
      final FakeHttpClient client = FakeHttpClient();

      await FormRemoteDataSourceImpl(client).submitForm(form);

      final http.BaseRequest request = client.requests.single;
      expect(request.method, 'GET');
      expect(request.url.queryParameters['method'], 'submit');
      expect(jsonDecode(utf8.decode(base64Url.decode(request.url.queryParameters['data']!))), form.toJson());
    });

    test('throws the script message for an error status', () async {
      final SubmissionException exception = await failure(FakeHttpClient(body: '{"status":"error","message":"Duplicate reference number"}'));

      expect(exception.message, 'Duplicate reference number');
      expect(exception.toString(), 'Duplicate reference number');
    });

    test('throws a status-code message for a failed response', () async {
      final SubmissionException exception = await failure(FakeHttpClient(statusCode: 500));

      expect(exception.message, 'Submission failed: 500');
    });

    test('throws a network message when the request cannot be made', () async {
      final SubmissionException exception = await failure(FakeHttpClient(throwsClientException: true));

      expect(exception.message, 'Network error. Please check your connection.');
    });
  });
}
