import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numberapi.com/{} endpoint.
  ///
  /// Throw a [ServerException] for all error
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numberapi.com/random endpoint.
  ///
  /// Throw a [ServerException] for all error
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future <NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromUrl('http://numberapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromUrl( 'http://numberapi.com/random');

  Future <NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
        url,
        headers :{  
          'Content-Type': 'application/json',
        },
    );

  if (response.statusCode == 200){
    return NumberTriviaModel.fromJson(json.decode(response.body));
  } else{
    throw ServerException();
  }
  }

}
