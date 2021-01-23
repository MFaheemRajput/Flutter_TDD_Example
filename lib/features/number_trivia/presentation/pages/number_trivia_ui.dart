import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
class NumberTriviaPage extends StatefulWidget {
  NumberTriviaPage({Key key}) : super(key: key);

  @override
  _NumberTriviaPageState createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage> {

initialLayout(){
 return  Text(
  'this is initial state',
  textAlign: TextAlign.center,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(fontWeight: FontWeight.bold),
    );
}
loadingLayout(){
 return  Text(
  'this is loading state',
  textAlign: TextAlign.center,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(fontWeight: FontWeight.bold),
    );
}
loadedLayout(){
 return  Text(
  'this is loaded state',
  textAlign: TextAlign.center,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(fontWeight: FontWeight.bold),
    );
}
errorLayout(){
 return  Text(
  'this is loaded state',
  textAlign: TextAlign.center,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(fontWeight: FontWeight.bold),
    );
}

  @override
  Widget build(BuildContext context) {
    return Container(
       child: BlocConsumer<NumberTriviaBloc, NumberTriviaState>(
         builder: (context, state){

            if (state is NumberTriviaInitial){
              return initialLayout();
            } else if(state is NumberTriviaLoading){
              return loadingLayout();
            } else if (state is NumberTriviaLoaded){
              return loadedLayout();
            } else {
              return errorLayout();
            }
          },
          listener: (context, state){
              return errorLayout();
          }
         ),
    );
  }
}