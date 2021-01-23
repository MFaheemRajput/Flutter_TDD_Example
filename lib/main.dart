import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:my_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:my_app/features/number_trivia/presentation/cubit/number_trivia_cubit.dart';
import 'package:my_app/features/number_trivia/presentation/pages/number_trivia_ui.dart';
import 'injection_container.dart' as di;

class myApp extends StatefulWidget {

  myApp({Key key}) : super(key: key);

  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: null,
    );
  }
}