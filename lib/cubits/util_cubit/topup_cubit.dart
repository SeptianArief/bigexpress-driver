part of '../cubits.dart';

class TopupCubit extends Cubit<UtilState> {
  TopupCubit() : super(UtilInitial());

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
}
