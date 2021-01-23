import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:my_app/features/number_trivia/domain/entities/number_trivia.dart';

void main(){
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

test(
  'should bea subclass of NumberTrivia entity',
  () async {
    //arrange 

    // act

    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());

    }
  );
}