import 'package:bloc/bloc.dart';

abstract class AuthEvent {}

class Login extends AuthEvent {}

abstract class AuthState {}

class AuthUninitialized extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => AuthUninitialized();
  String nik;
  String password;
  AuthBloc({this.nik, this.password});
  @override
  Stream<AuthState> mapEventToState(AuthEvent event) {
    if (event is Login) {
      print(nik);
      print(password);
    }
  }
}
