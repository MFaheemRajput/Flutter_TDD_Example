import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/core/error/exceptions.dart';
import 'package:my_app/core/error/failures.dart';
import 'package:my_app/core/network/network_info.dart';
import 'package:my_app/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:my_app/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:my_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:my_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:my_app/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {


}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {


}

class MockNetworkInfo extends Mock implements NetworkInfo{

}

void main() {

  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo
    );
  });

  void runTestOnline(Function body) {
    group('Device is online', () {
      setUp((){
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
    body();
    });
  }

  void runTestOffline(Function body) {
    group('Device is online', () {
      setUp((){
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
    body();
    });
  }

  group('getConcreteNumberTrivia', (){
    final tNumber = 1 ;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'Shuld check if the device is online',
       () async {
          //arange 
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          //act
          repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(mockNetworkInfo.isConnected);

    },
    );
  });

  runTestOnline( () {
    final tNumber = 1 ;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

        test(
      'Should return remote data when the call to remote data source is successful',
       () async {

          //arange 
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
    },
    );

    test(
      'Should cache the data locally when the call to remote data source is successful',
       () async {

          //arange 
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async => tNumberTriviaModel);

          //act
          await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    },
    );

    test(
      'Should return server failure when the call to remote data source is unsuccessful',
       () async {

          //arange 
          when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(ServerException());

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
    },
    );

  });

  runTestOffline(() {
    final tNumber = 1 ;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;


    test(
      'Should return last localy cached data when the cached data is availabale',
      () async {
          //arange 
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
    },
    );

    test(
      'Should return CacheFailure when the cached data is not availabale',
      () async {
          //arange 
          when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

          //act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
    },
    );

  });

   group('getRandomNumberTrivia', (){
    
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'Shuld check if the device is online',
       () async {
          //arange 
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          //act
          repository.getRandomNumberTrivia();

          //assert
          verify(mockNetworkInfo.isConnected);

    },
    );
  });

  runTestOnline( () {
    
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

        test(
      'Should return remote data when the call to remote data source is successful',
       () async {

          //arange 
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository.getRandomNumberTrivia();

          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
    },
    );

    test(
      'Should cache the data locally when the call to remote data source is successful',
       () async {

          //arange 
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

          //act
          await repository.getRandomNumberTrivia();

          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    },
    );

    test(
      'Should return server failure when the call to remote data source is unsuccessful',
       () async {

          //arange 
          when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());

          //act
          final result = await repository.getRandomNumberTrivia();

          //assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
    },
    );

  });

  runTestOffline(() {
    
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'Should return last localy cached data when the cached data is availabale',
      () async {
          //arange 
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

          //act
          final result = await repository.getRandomNumberTrivia();

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
    },
    );

    test(
      'Should return CacheFailure when the cached data is not availabale',
      () async {
          //arange 
          when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

          //act
          final result = await repository.getRandomNumberTrivia();

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
    },
    );

  });

} 