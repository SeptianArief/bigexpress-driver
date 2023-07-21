part of '../cubits.dart';

abstract class UtilState extends Equatable {
  const UtilState();

  @override
  List<Object> get props => [];
}

class UtilInitial extends UtilState {}

class UtilLoading extends UtilState {}

class CityLoaded extends UtilState {
  final List<City> data;

  const CityLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class BankLoaded extends UtilState {
  final BankModel data;

  const BankLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class TransactionLoaded extends UtilState {
  final List<TransactionPreview> data;

  const TransactionLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class TransactionDetailLoaded extends UtilState {
  final TransactionDetail data;

  const TransactionDetailLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class TopupLoaded extends UtilState {
  final List<TopupModel> data;

  const TopupLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class WithdrawLoaded extends UtilState {
  final List<WithdrawModel> data;

  const WithdrawLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class StatisticLoaded extends UtilState {
  final StatisticModel data;

  const StatisticLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class VehicleLoaded extends UtilState {
  final VehicleModel data;

  const VehicleLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class BankListLoaded extends UtilState {
  final List<BankOwnerModel> data;

  const BankListLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class UtilFailed extends UtilState {
  final ApiReturnValue data;

  const UtilFailed(this.data);

  @override
  List<Object> get props => [data];
}

class PaymentListLoaded extends UtilState {
  final PaymentListMaster data;

  const PaymentListLoaded(
    this.data,
  );

  @override
  List<Object> get props => [
        data,
      ];
}

class PaymentListDetailLoaded extends UtilState {
  final DetailPayment data;

  const PaymentListDetailLoaded(
    this.data,
  );

  @override
  List<Object> get props => [
        data,
      ];
}
