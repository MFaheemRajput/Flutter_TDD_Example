part of 'number_trivia_cubit.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {
  const NumberTriviaInitial();
}
class NumberTriviaLoading extends NumberTriviaState {
  const NumberTriviaLoading();
}
class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;
  const NumberTriviaLoaded({this.numberTrivia});

  @override 
  bool operator == (Object o){
    if(identical(this, o)) return true;
    return o is NumberTriviaLoaded && o.numberTrivia == numberTrivia;
  }

  @override int get hashCode => numberTrivia.hashCode;

}
class NumberTriviaError extends NumberTriviaState {
  final String message ;
  const NumberTriviaError(this.message);
  
}

