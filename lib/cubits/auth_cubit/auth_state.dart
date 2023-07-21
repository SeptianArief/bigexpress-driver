part of '../cubits.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserFailed extends UserState {
  final ApiReturnValue data;

  const UserFailed(this.data);

  @override
  List<Object> get props => [data];
}

class OTPSent extends UserState {
  final String phoneNumber;
  final String otpKey;

  const OTPSent(this.phoneNumber, this.otpKey);

  @override
  List<Object> get props => [phoneNumber, otpKey];
}

class UserVersionAppLoaded extends UserState {
  final String version;

  const UserVersionAppLoaded(this.version);

  @override
  List<Object> get props => [version];
}

class UserLogged extends UserState {
  final UserModel user;

  const UserLogged(this.user);

  @override
  List<Object> get props => [user];
}
