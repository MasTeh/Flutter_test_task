import 'package:jedi_test_task/models.dart';

abstract class LoginEvent {}

class LoginPushAction extends LoginEvent {
  final Credentials credentials;

  LoginPushAction(this.credentials);
}
