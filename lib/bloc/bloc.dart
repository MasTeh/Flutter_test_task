import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jedi_test_task/bloc/event.dart';
import 'package:jedi_test_task/bloc/state.dart';
import 'package:jedi_test_task/repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginBlocState> {
  final Repository repository;
  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginPushAction>((event, emit) async {
      emit(LoginIsLoading());
      bool userLogged = await repository.signIn(event.credentials);
      if (userLogged) {
        emit(LoginSuccessfully());
      } else {
        emit(LoginFail());
      }
    });
  }
}
