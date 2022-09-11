import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jedi_test_task/background.dart';
import 'package:jedi_test_task/bloc/bloc.dart';
import 'package:jedi_test_task/bloc/event.dart';
import 'package:jedi_test_task/bloc/state.dart';
import 'package:jedi_test_task/models.dart';
import 'package:jedi_test_task/repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _validator = GlobalKey<FormState>();
  final _focus1 = FocusNode();
  final _focus2 = FocusNode();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();


  LoginBloc? blocProvider;

  bool _isObscure = true;

  @override
  void didChangeDependencies() {
    
    blocProvider = BlocProvider.of<LoginBloc>(context);
    blocProvider!.stream.listen((state) {
      if (state is LoginSuccessfully) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(title: const Text("Успех")),
                  body: state.responseWidget,
                )));
      }

      if (state is LoginFail) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(title: const Text("Неуспех")),
                  body: state.responseWidget,
                )));
      }
    });

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginBlocState>(builder: (context, state) => Scaffold(
          body: BackgroundAnimated(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Form(
                            key: _validator,
                            child: Column(children: [
                              TextFormField(
                                focusNode: _focus1,
                                controller: _loginController,
                                decoration: const InputDecoration(
                                    hintText: "Логин",
                                    prefixIcon: Icon(Icons.person)),
                                validator: (value) {
                                  if (value!.isEmpty) return "Укажите логин";
                                  return null;
                                },
                              ),
                              TextFormField(
                                  focusNode: _focus2,
                                  controller: _passwordController,
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isObscure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        },
                                      ),
                                      hintText: "Пароль",
                                      prefixIcon: Icon(Icons.password)),
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return "Укажите пароль";
                                    return null;
                                  }),
                            ])),
                      )),
                  Container(height: 30),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (!_validator.currentState!.validate()) return;
                        if (state is LoginIsLoading) return;

                        _focus1.unfocus();
                        _focus2.unfocus();

                        blocProvider!.add(LoginPushAction(Credentials(
                            login: _loginController.text,
                            password: _passwordController.text)));
                      },
                      icon: state is LoginIsLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            )
                          : const Icon(Icons.login),
                      label:
                          const Text("Войти", style: TextStyle(fontSize: 20)))
                ]),
          ),
        )
      );
  }
}
