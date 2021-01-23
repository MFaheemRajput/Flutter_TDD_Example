import 'package:my_app/core/error/failures.dart';
import 'package:my_app/core/usecases/usecase.dart';
import 'package:my_app/core/util/input_converter.dart';
import 'package:my_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:my_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:my_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia{}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia{}

class MockInputConverter extends Mock implements InputConverter{}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp((){
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia, 
      random: mockGetRandomNumberTrivia, 
      inputConverter: mockInputConverter,
    );

  });

  test('initialState should be Empty', 
    () {
        expect(bloc.initialState, equals(NumberTriviaInitial()));
    });

  group('GetTriviaForConcreteNumber',
    (){
        final tNumberString = '1';
        final tNumberParsed = 1;
        final tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);

    test('should call the InputConverter to validate and convert the string to an unsigned integer', () async {
        when(mockInputConverter.stringToUnsignedInteger(tNumberString))
        .thenReturn(Right(tNumberParsed));

        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        //await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        print(bloc.state); // 1

        verifyNever(mockInputConverter.stringToUnsignedInteger(tNumberString));
        await bloc.close();
    });


    test('should emit [Loading, error] when the data gotten unsuccessfully', ()
     async {
        when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(tNumberParsed));

        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaError('Server Failure'),
        ];
        expect(bloc, emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });

    test('should emit [Loading, Loaded] when the data gotten successfully', ()
     async {
        when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(tNumberParsed));
        
        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(numberTrivia: tNumberTrivia),
        ];
        expect(bloc, emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });


    test('should emit [Error] when the input is invalid', ()
     async {
        when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Left(InvalidInputFailure()));

        final expected = [
          NumberTriviaInitial(),
          NumberTriviaError(INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expect(bloc, emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });

    test('should get data from concrete usecase',
     ()
     async {
        when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(tNumberParsed));

        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));

        bloc.add(GetTriviaForConcreteNumber(tNumberString));

        await untilCalled(mockGetConcreteNumberTrivia(any));

        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      });
  });


  group('GetTriviaForRandomNumber',
    (){

        final tNumberTrivia = NumberTrivia(text: 'Test Trivia', number: 1);


    test('should emit [Loading, error] when the data gotten unsuccessfully', ()
     async {
        
        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaError('Server Failure'),
        ];
        expectLater(bloc, emitsInOrder(expected));
        bloc.add(GetTriviaForRandomNumber());
      });

    test('should emit [Loading, Loaded] when the data gotten successfully', ()
     async {

        
        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

        final expected = [
          NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(bloc, emitsInOrder(expected));
        bloc.add(GetTriviaForRandomNumber());
      });

    test('should get data from random usecase',
     ()
     async {
       
        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

        bloc.add(GetTriviaForRandomNumber());

        await untilCalled(mockGetRandomNumberTrivia(any));

        verifyNever(mockGetRandomNumberTrivia(NoParams()));
      });
  });


}