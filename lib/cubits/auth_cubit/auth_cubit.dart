part of '../cubits.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  logout() async {
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    emit(UserInitial());
  }

  refreshProfile({required String id}) {
    AuthService.getProfile(id: id).then((value) {
      if (value.status == RequestStatus.success_request) {
        emit(UserLoading());
        createSession(value.data!);
        emit(UserLogged(value.data));
      }
    });
  }

  createSession(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('login', json.encode(user.toJson()));
  }

  createUserSession(User data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(data.toJson()));
  }

  loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserModel data = UserModel.fromJson(json.decode(prefs.getString('login')!));
    emit(UserLogged(data));
    refreshProfile(id: data.id.toString());
  }

  checkOTP(
    BuildContext context, {
    required String phoneNumber,
    required String otp,
    required String token,
    required String otpKey,
    required Function() onSuccess,
  }) {
    EasyLoading.show(status: 'Mohon Tunggu..');
    AuthService.checkOTP(
            phone: phoneNumber, token: token, otp: otp, otpKey: otpKey)
        .then((value) async {
      EasyLoading.dismiss();
      if (value.status == RequestStatus.success_request) {
        String? token = await FirebaseMessaging.instance.getToken();
        UserModel data = value.data;
        await AuthService.saveToken(
            id: data.id.toString(), token: token.toString());
        await createSession(data);
        final storage = FlutterSecureStorage();
        await storage.write(key: 'id_driver', value: data.id.toString());

        emit(UserLogged(data));
        onSuccess();
      } else {
        showSnackbar(context, title: value.data.toString());
      }
    });
  }
}

// loadSession() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   if (prefs.getString('user') != null) {
//     emit(UserLogged(User.fromJson(
//         json.decode(prefs.getString('user')!),
//         json.decode(prefs.getString('user')!)['otp_code'],
//         json.decode(prefs.getString('user')!)['otp_key'])));
//     AuthService.checkOTP(
//             otp: json.decode(prefs.getString('user')!)['otp_code'],
//             otpKey: json.decode(prefs.getString('user')!)['otp_key'],
//             phone: json.decode(prefs.getString('user')!)['hp'])
//         .then((value) {
//       if (value.status == RequestStatus.success_request) {
//         createTokenSession(value.data);
//         refreshProfile(
//             otpCode: json.decode(prefs.getString('user')!)['otp_code'],
//             otpKey: json.decode(prefs.getString('user')!)['otp_key']);
//       }
//     });
//   }
// }


