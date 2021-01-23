import 'package:dartz/dartz.dart';
import 'package:my_app/core/error/failures.dart';

class InputConverter {
    Either <Failure, int> stringToUnsignedInteger(String str){
      try {
         final number = int.parse(str);
        if (number >= 0){
            return Right(number);
        } else {
            throw FormatException();
        }
      } on FormatException {
        return Left(InvalidInputFailure());
      }
    }
}  

class InvalidInputFailure extends Failure {
  @override
  // TODO: implement props
  List<Object> get props => null;
}