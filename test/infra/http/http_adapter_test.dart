import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'aplication/json',
      'accept': 'aplication/json'
    };
    await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
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
  });
}