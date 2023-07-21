part of '../pages.dart';

class OTPPage extends StatefulWidget {
  final String phoneNumber;
  final int otpKeyId;
  const OTPPage({Key? key, required this.phoneNumber, required this.otpKeyId})
      : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  late int otpKey;
  int otpCountdown = 0;

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (vlue) {
      if (otpCountdown > 0) {
        setState(() {
          otpCountdown = otpCountdown - 1;
        });
      }
    });

    setState(() {
      otpKey = widget.otpKeyId;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final defaultPinTheme = PinTheme(
      width: 12.0.w,
      height: 12.0.w,
      textStyle: FontTheme.boldBaseFont.copyWith(
          fontSize: 13.0.sp,
          color: ColorPallette.baseBlue,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPallette.baseYellow),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return SingleChildScrollView(
      child: Container(
        width: 100.0.w,
        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0.w),
            Icon(
              Icons.arrow_back_ios,
              color: ColorPallette.baseBlack,
            ),
            SizedBox(height: 10.0.h),
            Text(
              'Masukkan Kode 5 digit yang dikirimkan ke',
              style: FontTheme.regularBaseFont
                  .copyWith(fontSize: 12.0.sp, color: ColorPallette.baseBlue),
            ),
            SizedBox(height: 1.0.w),
            Text(
              widget.phoneNumber,
              style: FontTheme.mediumBaseFont
                  .copyWith(fontSize: 13.0.sp, color: ColorPallette.baseYellow),
            ),
            SizedBox(height: 10.0.h),
            Center(
              child: Pinput(
                length: 5,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyDecorationWith(
                  border: Border.all(color: ColorPallette.baseBlue),
                  borderRadius: BorderRadius.circular(8),
                ),
                submittedPinTheme: defaultPinTheme.copyDecorationWith(
                  border: Border.all(color: ColorPallette.baseBlue),
                  borderRadius: BorderRadius.circular(8),
                ),
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) {
                  // messaging.getToken().then((value) {
                  BlocProvider.of<UserCubit>(context)
                      .checkOTP(context, token: '', onSuccess: () {
                    showSnackbar(context,
                        title: 'Login Sukses', customColor: Colors.green);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => MainPage()),
                        (route) => false);
                  },
                          otp: pin,
                          otpKey: otpKey.toString(),
                          phoneNumber: widget.phoneNumber);
                  // });
                },
              ),
            ),
            SizedBox(height: 5.0.h),
            GestureDetector(
              onTap: () {
                if (otpCountdown == 0) {
                  AuthService.login(phoneNumber: widget.phoneNumber)
                      .then((value) {
                    if (value.status == RequestStatus.success_request) {
                      setState(() {
                        otpCountdown = 60;
                        otpKey = value.data!;
                      });
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
              child: Text(
                otpCountdown == 0
                    ? 'Kirim Ulang SMS'
                    : 'Mohon Tunggu ${otpCountdown ~/ 60}:${otpCountdown % 60}',
                style: FontTheme.regularBaseFont.copyWith(
                    fontSize: 11.0.sp,
                    color: otpCountdown == 0
                        ? ColorPallette.baseYellow
                        : Colors.grey),
              ),
            ),
            SizedBox(height: 3.0.w),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Edit Nomor Telepon',
                style: FontTheme.regularBaseFont.copyWith(
                    fontSize: 11.0.sp, color: ColorPallette.baseYellow),
              ),
            ),
            SizedBox(height: 10.0.h),
            CustomButton(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => MainPage()));
                },
                text: 'Kirim',
                pressAble: true),
            SizedBox(
              height: 10.0.w,
            )
          ],
        ),
      ),
    );
  }
}
