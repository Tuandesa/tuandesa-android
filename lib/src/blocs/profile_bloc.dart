import 'package:bloc/bloc.dart';

abstract class ProfileEvent {}

class GetProfile extends ProfileEvent {}

abstract class ProfileState {}

class ProfileUninitialized extends ProfileState {}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  @override
  // TODO: implement initialState
  ProfileState get initialState => ProfileUninitialized();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) {
    if (event is GetProfile) {}
  }
}
