part of '../cubits.dart';

class MasterCubit extends Cubit<MasterState> {
  MasterCubit() : super(MasterInitial());

  fetchMasterAmount() async {
    emit(MasterLoading());
    UtilService.getMasterAmount().then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(MasterLoaded(value.data!));
      } else {
        emit(MasterFailed(value));
      }
    });
  }
}
