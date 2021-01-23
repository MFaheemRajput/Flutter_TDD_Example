import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:my_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

part 'number_trivia_state.dart';

class NumberTriviaCubit extends Cubit<NumberTriviaState> {
  final GetConcreteNumberTrivia _getConcreteNumberTrivia;
  NumberTriviaCubit(this._getConcreteNumberTrivia) : super(NumberTriviaInitial());

  Future<void> getNumberTrivia(String name) async {
    try {
      emit(NumberTriviaInitial());    
      emit(NumberTriviaLoading());
      final numberTrivia = await _getConcreteNumberTrivia(Params(number: 1));
      numberTrivia.fold (
        (leftValue) => emit(NumberTriviaError('Ops')), 
        (rightValue) => emit(NumberTriviaLoaded(numberTrivia: rightValue)),
      );
    } catch (Exception){
      emit(NumberTriviaError('Opss'));
    }

    }
}