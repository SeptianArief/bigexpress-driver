part of '../pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 100.0.h),
            width: 100.0.w,
            child: Form(
              key: formState,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60.0.w,
                    height: 60.0.w,
                    child: Image.asset('assets/images/Logo.png'),
                  ),
                  Text(
                    'Selamat Datang',
                    style: FontTheme.boldBaseFont.copyWith(
                        color: ColorPallette.baseBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0.sp),
                  ),
                  SizedBox(height: 3.0.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                    child: Text(
                      'Masuk akun untuk memulai perjalanan anda',
                      textAlign: TextAlign.center,
                      style: FontTheme.regularBaseFont
                          .copyWith(color: Colors.black54, fontSize: 11.0.sp),
                    ),
                  ),
                  SizedBox(height: 10.0.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masukkan nomor handphone anda',
                      style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 11.0.sp, color: ColorPallette.baseYellow),
                    ),
                  ),
                  SizedBox(height: 3.0.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                    child: InputField(
                      hintText: "Nomor Handphone",
                      controller: phoneNumberController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Masukkan Nomor Handphone Anda';
                        } else {
                          if (isNumeric(value.replaceAll('-', '')) &&
                              value.replaceAll('-', '').length < 8) {
                            return 'Nomor Handphone Tidak Valid';
                          } else {
                            return null;
                          }
                        }
                      },
                      keyboardType: TextInputType.phone,
                      borderType: "solid",
                      inputFormatter: MaskedInputFormatter(
                        '####-####-#####',
                        allowedCharMatcher: RegExp(r'[0-9]'),
                      ),
                      onChanged: (value) {
                        // validationProvider.changePhoneNumber(
                        //   value != null ? value.replaceAll("-", "") : "",
                        // );
                      },
                    ),
                  ),
                  SizedBox(height: 10.0.w),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      child: CustomButton(
                        onTap: () {
                          if (formState.currentState!.validate()) {
                            EasyLoading.show(status: 'Mohon Tunggu');
                            AuthService.login(
                                    phoneNumber: phoneNumberController.text
                                        .replaceAll('-', ''))
                                .then((value) {
                              EasyLoading.dismiss();
                              if (value.status ==
                                  RequestStatus.success_request) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => OTPPage(
                                              otpKeyId: value.data!,
                                              phoneNumber: phoneNumberController
                                                  .text
                                                  .replaceAll('-', ''),
                                            )));
                                showSnackbar(context,
                                    title: 'Berhasil Mengirim OTP',
                                    customColor: Colors.green);
                              } else {
                                showSnackbar(context,
                                    title: 'Gagal Mengirim OTP',
                                    customColor: Colors.orange);
                              }
                            });
                          }
                        },
                        pressAble: true,
                        text: 'Masuk',
                      )),
                  SizedBox(
                    height: 5.0.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RegisterPage()));
                    },
                    child: Text(
                      'Atau Daftar Disini',
                      style: FontTheme.regularBaseFont.copyWith(
                          decoration: TextDecoration.underline,
                          fontSize: 11.0.sp,
                          color: ColorPallette.baseYellow),
                    ),
                  ),
                  SizedBox(height: 10.w)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
