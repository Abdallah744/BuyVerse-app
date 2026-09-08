import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      if (event.email == 'admin@buyverse.com' && event.password == 'admin123') {
        emit(const Authenticated('admin@buyverse.com'));
      } else {
        emit(const AuthError('Invalid email or password'));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(Authenticated(event.email));
    });

    on<LogoutRequested>((event, emit) {
      emit(Unauthenticated());
    });
  }
}
