import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:manga_clean_arch/data/http/http_error.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:manga_clean_arch/infra/http/http.dart';

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

  group('shared', () {
    test('should throw ServerError if invalid method is provided', () async {
      final future = sut.request(url: url, method: 'invalid_method');

      expect(future, throwsA(HttpError.serverError));
    });
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

    void mockError() {
      mockResquest().thenThrow(Exception());
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

    test('should return BadRequest if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return BadRequest if post returns 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return UnauthorizedError if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should return ForbiddenError if post returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbidden));
    });

    test('should return ForbiddenError if post returns 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.notFound));
    });

    test('should return Servererror if post returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });

    test('should return ServerError if post throws', () async {
      mockError();

      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
