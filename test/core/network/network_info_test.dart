import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:my_app/core/network/network_info.dart';

class MockDataconnectionChecker extends Mock implements DataConnectionChecker {
  
}
  void main() {

    NetworkInfoImpl networkInfoImpl;
    MockDataconnectionChecker mockDataconnectionChecker;

    setUp((){
      mockDataconnectionChecker = MockDataconnectionChecker();
      networkInfoImpl = NetworkInfoImpl(mockDataconnectionChecker);
    });

    group('isConneted',(){

        test('should forword the call to dataConnectionChecker.hasConnection', (){
            final tHasConnectionFuture = Future.value(true);
            when(mockDataconnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);
            final result = networkInfoImpl.isConnected;
            verify(mockDataconnectionChecker.hasConnection);
            expect(result, tHasConnectionFuture);

        });
    });
  }
  
