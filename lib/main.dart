import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jedi_test_task/bloc/bloc.dart';
import 'package:jedi_test_task/login_page.dart';
import 'package:jedi_test_task/repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(Repository()),
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }
}
