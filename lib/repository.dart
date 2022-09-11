import 'package:jedi_test_task/models.dart';

class Repository {
  Future<bool> signIn(Credentials credentials) async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (credentials.login == "test" && credentials.password == "test") return true;
    
    return false;
  }
}
