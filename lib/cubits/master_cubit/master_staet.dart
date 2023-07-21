part of '../cubits.dart';

abstract class MasterState extends Equatable {
  const MasterState();

  @override
  List<Object> get props => [];
}

class MasterInitial extends MasterState {}

class MasterLoading extends MasterState {}

class MasterFailed extends MasterState {
  final ApiReturnValue data;

  const MasterFailed(this.data);

  @override
  List<Object> get props => [data];
}

class MasterLoaded extends MasterState {
  final double data;

  const MasterLoaded(this.data);

  @override
  List<Object> get props => [data];
}
