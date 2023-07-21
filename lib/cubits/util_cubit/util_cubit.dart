part of '../cubits.dart';

class UtilCubit extends Cubit<UtilState> {
  UtilCubit() : super(UtilInitial());

  void fetchTopup({required String id}) {
    emit(UtilLoading());
    UtilService.listTopup(id: id).then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(TopupLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchWithdraw({required String id}) {
    emit(UtilLoading());
    UtilService.listWithdraw(id: id).then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(WithdrawLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchBank() {
    emit(UtilLoading());
    UtilService.listBankOwner().then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(BankListLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchStatistic({required String id}) {
    emit(UtilLoading());
    UtilService.fetchStatistic(id: id).then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(StatisticLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchVehicle({required String id}) {
    emit(UtilLoading());
    UtilService.fetchVehicle(id: id).then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(VehicleLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void listingCity() async {
    emit(UtilLoading());
    UtilService.listCity().then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(CityLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void listingBank({required String id}) async {
    emit(UtilLoading());
    UtilService.fetchBank(id: id).then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(BankLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void listOpenOrder() async {
    emit(UtilLoading());
    UtilService.fetchOpenOrder().then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(TransactionLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void myOrder({required String id, required String isActive}) async {
    emit(UtilLoading());
    UtilService.myOrder(isActive: isActive, userId: id).then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(TransactionLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void specialOrder({
    required String id,
  }) async {
    emit(UtilLoading());
    UtilService.specialOrder(userId: id).then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(TransactionLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void detailOrder({required String id}) async {
    emit(UtilLoading());
    UtilService.fetchTransaction(id: id).then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(TransactionDetailLoaded(value.data!));
      } else {
        emit(UtilFailed(value));
      }
    });
  }

  void fetchPaymentList(
    BuildContext context, {
    required String amount,
  }) async {
    emit(UtilLoading());
    UserState state = BlocProvider.of<UserCubit>(context).state;
    if (state is UserLogged) {
      FinanceAPI.paymentList(
        id: state.user.id.toString(),
        amount: amount,
        tempId: 'TP${DateFormat('ddMMyy').format(DateTime.now())}',
        name: state.user.name,
        phone: state.user.phone,
      ).then((value) {
        if (value.status == RequestStatus.success_request) {
          emit(PaymentListLoaded(
            value.data!,
          ));
        } else {
          emit(UtilFailed(value));
        }
      });
    }
  }

  void fetchPaymentDetail(BuildContext context,
      {required bool isVA,
      required String amount,
      required PaymentListMaster data}) async {
    emit(UtilLoading());
    UserState state = BlocProvider.of<UserCubit>(context).state;
    if (state is UserLogged) {
      FinanceAPI.detailPayment(
              id: state.user.id.toString(),
              amount: amount,
              isVA: isVA,
              name: state.user.name,
              phone: state.user.phone,
              trxId: data.trxId.toString())
          .then((value) {
        if (value.status == RequestStatus.success_request) {
          emit(PaymentListDetailLoaded(value.data!));
        } else {
          emit(UtilFailed(value));
        }
      });
    }
  }
}
