import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:my_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

// It can be your local DB or Shared Preferences or file storage 
// inshort any kind of local datasource.
class MockSharedPreferences extends Mock implements SharedPreferences {


}

void main(){

    MockSharedPreferences mockSharedPreferences;
    NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;
    const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
    setUp((){
      mockSharedPreferences = MockSharedPreferences();
      numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl( sharedPreferences: mockSharedPreferences);
    });

    group('getLastNumberTrivia',(){
        final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
        test('should return NumberTriviaModel from sharedPrefrence when there is one in the cache', 
        () async {
          when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));
          final result = await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();
          verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
          expect(result, equals(tNumberTriviaModel));
        });

        test('should return a CacheException when there is not a cached value.', 
        () async {
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia;
          
          expect(() =>call(), throwsException);
        });
    });

    group('cacheNumberTrivia',(){

        final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Text Trivia");
        test('should call sharedPreference to cache tha data', 
        () async {
            numberTriviaLocalDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
            final jsonString  = json.encode(tNumberTriviaModel.toJson());
            verify( mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString));
        });
    });
}