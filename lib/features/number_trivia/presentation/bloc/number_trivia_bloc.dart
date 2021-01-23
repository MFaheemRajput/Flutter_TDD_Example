import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_app/core/usecases/usecase.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';


const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc <NumberTriviaEvent, NumberTriviaState> {

  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required  GetRandomNumberTrivia random,
    @required this.inputConverter
    }) : 
      assert(concrete != null),
      assert(random != null),
      assert(inputConverter != null),
          getConcreteNumberTrivia = concrete,
          getRandomNumberTrivia = random, super(null);

  @override
  NumberTriviaState get initialState => NumberTriviaInitial();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    yield NumberTriviaInitial();
    if (event is GetTriviaForConcreteNumber) {
      
      final result = inputConverter.stringToUnsignedInteger(event.numberString);
        yield* result.fold(
          (l) async* {
            yield NumberTriviaError(INVALID_INPUT_FAILURE_MESSAGE);
          }, (r) async* {
               try {
                 yield NumberTriviaLoading();
                 final n = await getConcreteNumberTrivia(Params(number: r));
                 yield* n.fold(
                  (l) async* {yield NumberTriviaError(SERVER_FAILURE_MESSAGE);},
                  (r) async* {yield NumberTriviaLoaded(numberTrivia: r);},
                 );
               } catch(Exception) {
                 yield NumberTriviaError(SERVER_FAILURE_MESSAGE);
               }
          },
        );
    } else if(event is GetTriviaForRandomNumber){

       try{
                 yield NumberTriviaLoading();
                 final n = await getRandomNumberTrivia(NoParams());
                 yield* n.fold(
                  (l) async* {yield NumberTriviaError(SERVER_FAILURE_MESSAGE);},
                  (r) async* {yield NumberTriviaLoaded(numberTrivia: r);},
                 );
               } catch(Exception) {
                 yield NumberTriviaError(SERVER_FAILURE_MESSAGE);
               }
    } 
  }

}
