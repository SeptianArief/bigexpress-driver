part of 'pages.dart';

class AppLockedPage extends StatefulWidget {
  const AppLockedPage({Key? key}) : super(key: key);

  @override
  State<AppLockedPage> createState() => _AppLockedPageState();
}

class _AppLockedPageState extends State<AppLockedPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      width: 100.0.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 60.0.w,
              height: 60.0.w,
              child: Image.asset('assets/images/Logo.png')),
          SizedBox(height: 10.0.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            child: Text(
                'Mohon Maaf Untuk Saat Ini Big Express Belum Tersedia di Lokasi Anda',
                textAlign: TextAlign.center,
                style: FontTheme.regularBaseFont.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0.sp,
                    color: ColorPallette.baseBlue)),
          ),
          SizedBox(height: 2.0.w),
          Text(
            'Nantikan Kehadiran Big Express di Lokasi Anda',
            style: FontTheme.regularBaseFont
                .copyWith(fontSize: 10.0.sp, color: Colors.black54),
          ),
          SizedBox(height: 10.0.w),
          SizedBox(
              width: 90.0.w,
              child: CustomButton(
                onTap: () {
                  SystemNavigator.pop();
                },
                pressAble: true,
                text: 'Keluar',
              ))
        ],
      ),
    )));
  }
}
