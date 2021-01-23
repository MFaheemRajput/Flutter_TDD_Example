import 'package:get_it/get_it.dart';
import 'package:my_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:my_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final sl = GetIt.instance;
void init() async {
  //! Features - Number Trivia
  // BLoC
  sl.registerFactory(() => NumberTriviaBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
      ));


  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  //! Core

  //! External
}
