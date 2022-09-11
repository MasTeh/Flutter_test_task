import 'package:flutter/material.dart';

abstract class LoginBlocState {}

class LoginIsLoading extends LoginBlocState {}

class LoginInitial extends LoginBlocState {}

class LoginSuccessfully extends LoginBlocState {
  final Widget responseWidget = Image.asset("assets/success.png");
}

class LoginFail extends LoginBlocState {
  final Widget responseWidget = Image.asset("assets/fail.png");
}
