part of '../../pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: BlocProvider.of<UserCubit>(context),
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                UserState userState = BlocProvider.of<UserCubit>(context).state;
                if (userState is UserLogged) {
                  BlocProvider.of<UserCubit>(context)
                      .refreshProfile(id: userState.user.id.toString());
                }
              },
              child: ListView(
                children: [
                  _buildBanner(state is UserLogged ? state.user : null),
                  _buildWallet(state is UserLogged ? state.user : null),
                  _buildProfileMenu(),
                  SizedBox(height: 10.0.w),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      child: CustomButton(
                          onTap: () {
                            yesOrNoDialog(context,
                                    title: 'Keluar',
                                    desc:
                                        'Apakah Anda yakin untuk keluar dari Akun Anda?')
                                .then((value) {
                              if (value) {
                                BlocProvider.of<UserCubit>(context).logout();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginPage()),
                                    (route) => false);
                              }
                            });
                          },
                          gradient: const LinearGradient(
                            colors: [
                              ColorPallette.baseYellow,
                              ColorPallette.baseYellow
                            ],
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                          text: 'Keluar',
                          pressAble: true)),
                  SizedBox(height: 10.0.w),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileMenu() {
    Widget _menuProfile(
        {required String imageAsset,
        required String title,
        required String desc,
        required Function() onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(5.0.w),
          child: Row(
            children: [
              SizedBox(
                width: 6.0.w,
                height: 6.0.w,
                child: Image.asset(imageAsset),
              ),
              SizedBox(width: 5.0.w),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: FontTheme.mediumBaseFont.copyWith(
                          fontSize: 12.0.sp, color: ColorPallette.baseBlue)),
                  Text(desc,
                      style: FontTheme.mediumBaseFont
                          .copyWith(fontSize: 8.0.sp, color: Colors.black54))
                ],
              )),
              SizedBox(width: 3.0.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 4.0.w,
                color: ColorPallette.baseBlue,
              )
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _menuProfile(
            imageAsset: 'assets/images/wallet(2) 2.png',
            desc: 'Lihat Riwayat Pencarian Anda Disini',
            title: 'Riwayat Pencairan',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => WithdrawListPage()));
            }),
        _menuProfile(
            imageAsset: 'assets/images/Group 367.png',
            desc: 'Atur Profil Anda',
            title: 'Profil Anda',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ProfileFormPage()));
            }),
        _menuProfile(
            imageAsset: 'assets/images/trending-up.png',
            desc: 'Lihat Statistik Anda',
            title: 'Statistik Anda',
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => StatisticPage()));
            }),
        _menuProfile(
            imageAsset: 'assets/images/plus.png',
            desc: 'Atur Kendaraan Anda',
            title: 'Kendaraan Anda',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => VehicleFormPage()));
            }),
        _menuProfile(
            imageAsset: 'assets/images/Vector.png',
            desc: 'Lihat Ketentuan Mengenai Big Express',
            title: 'Ketentuan Big Express',
            onTap: () {
              launch('https://bigexpress.co.id/terms.driver.php');
            }),
      ],
    );
  }

  Widget _buildWallet(UserModel? data) {
    return Container(
      padding: EdgeInsets.all(5.0.w),
      child: Row(
        children: [
          SizedBox(
            width: 8.0.w,
            height: 8.0.w,
            child: Image.asset('assets/images/wallet(2) 2.png'),
          ),
          SizedBox(width: 5.0.w),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo Saya',
                style: FontTheme.boldBaseFont
                    .copyWith(fontSize: 8.0.sp, color: Colors.black87),
              ),
              SizedBox(height: 1.0.w),
              Text(
                data == null
                    ? '-'
                    : moneyChanger(double.parse(data.saldo.toString())),
                style: FontTheme.boldBaseFont
                    .copyWith(fontSize: 11.0.sp, color: ColorPallette.baseBlue),
              ),
            ],
          )),
          SizedBox(width: 3.0.w),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => TopupListPage()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorPallette.baseYellow),
              child: Text(
                'Top Up',
                style: FontTheme.regularBaseFont
                    .copyWith(fontSize: 8.0.sp, color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 3.0.w),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => WithdrawPage()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.w),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorPallette.baseYellow),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent),
              child: Text(
                'Tarik Saldo',
                style: FontTheme.regularBaseFont.copyWith(
                    fontSize: 8.0.sp, color: ColorPallette.baseYellow),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(UserModel? data) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: SizedBox(
              width: 30.0.w,
              child: Image.asset("assets/images/Motor Backdrop.png")),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                ColorPallette.baseBlue,
                const Color(0xFFBAC8DE).withOpacity(0.3),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 5.0.w),
              Text(
                'Profile',
                style: FontTheme.boldBaseFont
                    .copyWith(fontSize: 13.0.sp, color: Colors.white),
              ),
              SizedBox(height: 5.0.w),
              Container(
                width: 25.0.w,
                height: 25.0.w,
                decoration: data == null
                    ? BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black12)
                    : BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(baseUrl +
                                'upload/profile_picture/' +
                                data.photo))),
              ),
              SizedBox(height: 3.0.w),
              Text(
                data == null ? '' : data.name,
                style: FontTheme.mediumBaseFont
                    .copyWith(fontSize: 12.0.sp, color: Colors.white),
              ),
              SizedBox(height: 2.0.w),
              data == null
                  ? Container()
                  : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: data.isValidate == 1
                                      ? Colors.green
                                      : Colors.orange),
                              padding: EdgeInsets.all(1.0.w),
                              child: Icon(
                                  data.isValidate == 1
                                      ? Icons.check
                                      : Icons.info_rounded,
                                  color: Colors.white)),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.0.w),
                              child: Text(
                                  data.isValidate == 1
                                      ? 'Tervalidasi'
                                      : 'Belum Tervalidasi',
                                  style: FontTheme.regularBaseFont.copyWith(
                                      fontSize: 10.0.sp,
                                      color: data.isValidate == 1
                                          ? Colors.green
                                          : Colors.orange))),
                        ],
                      )),
              SizedBox(height: 10.0.w)
            ],
          ),
        ),
        Positioned(
          left: 8.0.w,
          top: 8.0.w,
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
