import 'package:dartz/dartz.dart';
import '../../features/number_trivia/domain/entities/number_trivia.dart';
import '../error/failures.dart';

abstract class UseCase <Type, Params> {

  Future<Either<Failure, NumberTrivia>> call(Params params);
  
}

class NoParams {
  
}
