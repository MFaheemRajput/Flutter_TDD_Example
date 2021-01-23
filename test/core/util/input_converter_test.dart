import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/core/util/input_converter.dart';

void main(){
  InputConverter inputConverter;
  setUp(() { 
    inputConverter = InputConverter();
});
  
  group('stringToUnsignedtInt', (){
    test('should return an integer when the string represents an unsigned Integer', () async{
      
        final str = '123';
        final result = inputConverter.stringToUnsignedInteger(str);
        expect(result, Right(123));

        },
      );

    
    test('should return a failure when the string is not an integer', () async{
      
        final str = '1.0';
        final result = inputConverter.stringToUnsignedInteger(str);
        expect(result, Left(InvalidInputFailure()));
       
        },
      );



    test('should return a failure when the integer is negative', () async{
      
        final str = '-123';
        final result = inputConverter.stringToUnsignedInteger(str);
        expect(result, Left(InvalidInputFailure()));
       
        },
      );


  });
}