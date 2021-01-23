import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:my_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {

  
  NumberTriviaRemoteDataSourceImpl remoteDataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }
  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getConcreatNumberTrivia', 
  () {
    final tNumber = 42;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number
   being the endpoint and with application/json header''', () {
      
      setUpMockHttpClientSuccess200();

      remoteDataSource.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient.get(
        'http://numberapi.com/$tNumber',
        headers :{  
          'Content-Type': 'application/json',
        },
      ));
    });

    test('should return number trivia when the response code 200',  
    () async {
    
    setUpMockHttpClientSuccess200();
    final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);
    expect(result, equals(tNumberTriviaModel));

    });
    
    test('should return ServerException when the response code other then 200',  
    () async {
      setUpMockHttpClientFailure404();

          final call = await remoteDataSource.getConcreteNumberTrivia;

          expect(() => call(tNumber), throwsException); 

    });
  });


  group('getRandomNumberTrivia', 
  () {
    
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with number
   being the endpoint and with application/json header''', () {
      
      setUpMockHttpClientSuccess200();

      remoteDataSource.getRandomNumberTrivia();

      verify(mockHttpClient.get(
        'http://numberapi.com/random',
        headers :{  
          'Content-Type': 'application/json',
        },
      ));
    });

    test('should return number trivia when the response code 200',  
    () async {
    
    setUpMockHttpClientSuccess200();
    final result = await remoteDataSource.getRandomNumberTrivia();
    expect(result, equals(tNumberTriviaModel));

    });
    
    test('should return ServerException when the response code other then 200',  
    () async {
          setUpMockHttpClientFailure404();

          final call = remoteDataSource.getRandomNumberTrivia;

          expect(() => call(), throwsException); 

    });
  });


}
