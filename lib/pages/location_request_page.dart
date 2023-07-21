part of 'pages.dart';

class LocationRequestPage extends StatefulWidget {
  const LocationRequestPage({Key? key}) : super(key: key);

  @override
  State<LocationRequestPage> createState() => _LocationRequestPageState();
}

class _LocationRequestPageState extends State<LocationRequestPage> {
  startNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('login') != null) {
      BlocProvider.of<UserCubit>(context).loadSession();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainPage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationPermission>(
        future: Geolocator.checkPermission(),
        builder: (context, data) {
          if (data.hasData) {
            if (data.data!.name == 'whileInUse' ||
                data.data!.name == 'always') {
              startNavigate();
            }
            return Scaffold(
              body: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 40.0.w,
                          height: 40.0.w,
                          child: Image.asset('assets/images/Titik Awal.png')),
                      SizedBox(height: 10.0.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        child: Text(
                          'Akses Lokasi diperlukan untuk mengakases Aplikasi Ini',
                          textAlign: TextAlign.center,
                          style: FontTheme.boldBaseFont.copyWith(
                              fontSize: 12.0.sp, color: ColorPallette.baseBlue),
                        ),
                      ),
                      SizedBox(height: 10.0.w),
                      SizedBox(
                          width: 90.0.w,
                          child: CustomButton(
                            onTap: () {
                              Geolocator.requestPermission().then((value) {
                                setState(() {});
                              });
                            },
                            pressAble: true,
                            text: 'Berikan Akses Lokasi',
                          ))
                    ],
                  )),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
