part of 'pages.dart';

class FailedCheckLocationPage extends StatelessWidget {
  const FailedCheckLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      width: 100.0.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: 30.0.w),
          SizedBox(height: 10.0.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            child: Text('Gagal Melakukan Pengecekan Lokasi',
                textAlign: TextAlign.center,
                style: FontTheme.regularBaseFont.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0.sp,
                    color: ColorPallette.baseBlue)),
          ),
          SizedBox(height: 2.0.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            child: Text(
              'Aplikasi Gagal Melakukan Pengecekan Lokasi Mohon Cek Koneksi Anda dan coba lagi',
              textAlign: TextAlign.center,
              style: FontTheme.regularBaseFont
                  .copyWith(fontSize: 10.0.sp, color: Colors.black54),
            ),
          ),
          SizedBox(height: 10.0.w),
          SizedBox(
              width: 90.0.w,
              child: CustomButton(
                onTap: () async {
                  Position myPosition = await Geolocator.getCurrentPosition();
                  EasyLoading.show(status: 'Mohon Tunggu..');

                  AuthService.checkRegion(
                          lat: myPosition.latitude.toString(),
                          lon: myPosition.longitude.toString(),
                          id: '')
                      .then((valueAPI) {
                    EasyLoading.dismiss();
                    if (valueAPI.status == RequestStatus.success_request) {
                      if (valueAPI.data) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => LocationRequestPage()));
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => AppLockedPage()));
                      }
                    } else {
                      showSnackbar(context,
                          title: 'Gagal Melakukan Pengecekan Lokasi',
                          customColor: Colors.orange);
                    }
                  });
                },
                pressAble: true,
                text: 'Coba Lagi',
              ))
        ],
      ),
    )));
  }
}
