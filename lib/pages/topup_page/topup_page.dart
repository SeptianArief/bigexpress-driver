part of '../pages.dart';

class TopupPage extends StatefulWidget {
  const TopupPage({Key? key}) : super(key: key);

  @override
  State<TopupPage> createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent());
  }

  Widget _buildContent() {
    return Column(children: [
      HeaderBar(title: 'Topup'),
      Expanded(
          child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
        children: [
          SizedBox(height: 5.0.w),
          Text(
            'Jumlah yang akan di Topup',
            style: FontTheme.boldBaseFont.copyWith(
                fontSize: 12.0.sp,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3.0.w),
          InputField(
              controller: controller,
              borderType: 'solid',
              keyboardType: TextInputType.number,
              inputFormatter: CurrencyTextInputFormatter(
                  decimalDigits: 0, locale: 'id', symbol: ''),
              verticalPadding: 4.0.w,
              hintText: 'Minimal Rp10.000',
              onChanged: (value) {}),
          SizedBox(height: 10.0.w),
          CustomButton(
              onTap: () {
                if (int.parse(controller.text.replaceAll('.', '')) < 10000) {
                  showSnackbar(context,
                      title: 'Minimal Topup Rp10.000',
                      customColor: Colors.orange);
                } else {
                  yesOrNoDialog(context,
                          title: 'Topup',
                          desc: 'Apakah Anda yakin untuk melakukan Topup?')
                      .then((value) {
                    if (value) {
                      UserState userState =
                          BlocProvider.of<UserCubit>(context).state;
                      if (userState is UserLogged) {
                        BlocProvider.of<UserCubit>(context)
                            .refreshProfile(id: userState.user.id.toString());
                        if ((userState.user.saldo +
                                int.parse(
                                    controller.text.replaceAll('.', ''))) <=
                            2000000) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => TopupListPaymentPage(
                                        totalTopup: double.parse(controller.text
                                            .replaceAll('.', '')),
                                      )));
                          // TopupService.topup(
                          //         amount: int.parse(
                          //             controller.text.replaceAll('.', '')),
                          //         id: userState.user.id.toString(),
                          //         name: userState.user.name,
                          //         phone: userState.user.phoneNumber)
                          //     .then((value) {
                          //   if (value.status == RequestStatus.successRequest) {
                          //     Navigator.pushReplacement(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (_) => TopupWebview(
                          //                 url:
                          //                     'https://app.midtrans.com/snap/v2/vtweb/${value.data!}')));
                          //   } else {
                          //     showSnackbar(context,
                          //         title: 'Gagal Melakukan Pengajuan Topup',
                          //         customColor: Colors.orange);
                          //   }
                          // });
                        } else {
                          int sisa = 2000000 - userState.user.saldo;
                          String readAmount = moneyChanger(
                            sisa.toDouble(),
                          );
                          showSnackbar(context,
                              title:
                                  'Saldo Maksimal adalah Rp2.000.000 Anda dapat melakukan Topup Sebesar $readAmount lagi',
                              customColor: Colors.orange);
                        }
                      }
                    }
                  });
                }
              },
              text: 'Topup',
              pressAble: true),
          SizedBox(height: 10.0.w),
        ],
      ))
    ]);
  }
}
