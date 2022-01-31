import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:manga_clean_arch/data/http/http_client.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'aplication/json',
      'accept': 'aplication/json'
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response =
        await client.post(Uri.parse(url), headers: headers, body: jsonBody);
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else {
      return null;
    }
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    PostExpectation mockResquest() => when(client.post(
          any,
          body: anyNamed('body'),
          headers: anyNamed('headers'),
        ));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockResquest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('should call post with correct values', () async {
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(client.post(Uri.parse(url),
          headers: {
            'content-type': 'aplication/json',
            'accept': 'aplication/json',
          },
          body: '{"any_key":"any_value"}'));
    });

    test('should call post withou body', () async {
      await sut.request(
        url: url,
        method: 'post',
      );

      verify(client.post(
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('should return data if post returns 200', () async {
      await sut.request(
        url: url,
        method: 'post',
      );

      final response = await sut.request(url: url, method: 'post');
      expect(response, {'any_key': 'any_value'});
    });

    test('should return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');
      await sut.request(
        url: url,
        method: 'post',
      );

      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('should return null if post returns 204', () async {
      mockResponse(204, body: '');
      await sut.request(
        url: url,
        method: 'post',
      );

      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('should return null if post returns 204 with data', () async {
      mockResponse(204);
      await sut.request(
        url: url,
        method: 'post',
      );

      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });
  });
}
