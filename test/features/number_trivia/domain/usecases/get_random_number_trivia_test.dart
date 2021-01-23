

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:my_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:my_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {


}

void main(){
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');  

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  }); 

  test(
    'Should get trivia from the repository',
    () async {
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
      .thenAnswer((_) async => Right(tNumberTrivia));

      final result = await usecase(NoParams());

      expect (result, Right(tNumberTrivia));

      verify(mockNumberTriviaRepository.getRandomNumberTrivia());

      verifyNoMoreInteractions(mockNumberTriviaRepository); 
 
    },
  );
}