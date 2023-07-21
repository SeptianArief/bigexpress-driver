part of '../../pages.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  TextEditingController controller = TextEditingController();
  UtilCubit bankCubit = UtilCubit();

  @override
  void initState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      bankCubit.listingBank(id: userState.user.id.toString());
    }
    super.initState();
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
    return BlocBuilder<UserCubit, UserState>(
        bloc: BlocProvider.of<UserCubit>(context),
        builder: (context, state) {
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.0.w, vertical: 5.0.w),
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
                    alignment: Alignment.center,
                    child: Text(
                      'Tarik Saldo',
                      style: FontTheme.mediumBaseFont
                          .copyWith(color: Colors.white, fontSize: 13.0.sp),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                children: [
                  SizedBox(height: 10.0.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo Tersedia',
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 8.0.sp, color: Colors.black87),
                      ),
                      SizedBox(height: 2.0.w),
                      Text(
                        state is UserLogged
                            ? moneyChanger(
                                double.parse(state.user.saldo.toString()))
                            : '-',
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 14.0.sp, color: ColorPallette.baseBlue),
                      ),
                      SizedBox(height: 10.0.w),
                      Text(
                        'Masukkan jumlah yang ingin ditarik',
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 10.0.sp, color: Colors.black87),
                      ),
                      SizedBox(height: 3.0.w),
                      InputField(
                        controller: controller,
                        onChanged: (val) {},
                        hintText: 'Nominal',
                        validator: (value) {},
                        borderType: 'border',
                        prefixIcon: Center(
                          widthFactor: 1,
                          child: Text(
                            ' Rp ',
                            style: FontTheme.boldBaseFont.copyWith(
                                fontSize: 12.0.sp, color: Colors.black54),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0.w),
                      Text(
                        'Rekening Tujuan',
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 10.0.sp, color: Colors.black87),
                      ),
                      SizedBox(
                        height: 2.0.w,
                      ),
                      state is UserLogged
                          ? BlocBuilder<UtilCubit, UtilState>(
                              bloc: bankCubit,
                              builder: (context, stateBank) {
                                if (stateBank is UtilLoading) {
                                  return PlaceHolder(
                                      child: Container(
                                    width: 90.0.w,
                                    height: 20.0.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                  ));
                                } else if (stateBank is BankLoaded) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 3.0.w),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0.w, vertical: 3.0.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(stateBank.data.bankName,
                                            style: FontTheme.boldBaseFont
                                                .copyWith(
                                                    fontSize: 14.0.sp,
                                                    color:
                                                        ColorPallette.baseBlue,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        SizedBox(width: 3.0.w),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              stateBank.data.accountName,
                                              style: FontTheme.regularBaseFont
                                                  .copyWith(
                                                      fontSize: 8.0.sp,
                                                      color: Colors.black54),
                                            ),
                                            Text(
                                              stateBank.data.accountNumber,
                                              style: FontTheme.regularBaseFont
                                                  .copyWith(
                                                      fontSize: 10.0.sp,
                                                      color: Colors.black87),
                                            ),
                                          ],
                                        )),
                                        SizedBox(width: 2.0.w),
                                        GestureDetector(
                                            onTap: () async {
                                              bool? result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          AccountBankFormPage(
                                                              data: stateBank
                                                                  .data)));
                                              if (result != null) {
                                                UserState userState =
                                                    BlocProvider.of<UserCubit>(
                                                            context)
                                                        .state;
                                                if (userState is UserLogged) {
                                                  bankCubit.listingBank(
                                                      id: userState.user.id
                                                          .toString());
                                                }
                                              }
                                            },
                                            child: Text(
                                              'Ubah',
                                              style: FontTheme.regularBaseFont
                                                  .copyWith(
                                                      fontSize: 11.0.sp,
                                                      color: Colors.orange),
                                            ))
                                      ],
                                    ),
                                  );
                                } else {
                                  return FailedRequest(onTap: () {
                                    UserState userState =
                                        BlocProvider.of<UserCubit>(context)
                                            .state;
                                    if (userState is UserLogged) {
                                      bankCubit.listingBank(
                                          id: userState.user.id.toString());
                                    }
                                  });
                                }
                              },
                            )
                          : Container(),
                      SizedBox(height: 10.0.w),
                      CustomButton(
                          onTap: () {
                            //validasi
                            int withdrawAmount = int.parse(
                                controller.text.isEmpty
                                    ? '0'
                                    : controller.text);

                            if (withdrawAmount < 10000) {
                              showSnackbar(context,
                                  customColor: Colors.orange,
                                  title:
                                      'Minimal Penarikan Saldo Adalah Rp10.000');
                            } else {
                              if (state is UserLogged) {
                                if (withdrawAmount > state.user.saldo) {
                                  showSnackbar(context,
                                      customColor: Colors.orange,
                                      title:
                                          'Maksimal Penarikan Saldo Adalah ${moneyChanger(double.parse(state.user.saldo.toString()))}');
                                } else {
                                  yesOrNoDialog(context,
                                          title: 'Withdraw',
                                          desc:
                                              'Apakah Anda yakin untuk melakukan withdraw?')
                                      .then((value) {
                                    if (value) {
                                      UtilState bankState = bankCubit.state;
                                      UserState userState =
                                          BlocProvider.of<UserCubit>(context)
                                              .state;
                                      if (userState is UserLogged &&
                                          bankState is BankLoaded) {
                                        EasyLoading.show(
                                            status: 'Mohon Tunggu');
                                        AuthService.withdraw(
                                                bankName:
                                                    bankState.data.bankName,
                                                accountName:
                                                    bankState.data.accountName,
                                                accountNumber: bankState
                                                    .data.accountNumber,
                                                amount:
                                                    withdrawAmount.toString(),
                                                idDriver: userState.user.id
                                                    .toString())
                                            .then((valueAPI) {
                                          EasyLoading.dismiss();
                                          if (valueAPI.status ==
                                              RequestStatus.success_request) {
                                            EasyLoading.dismiss();
                                            showSnackbar(context,
                                                title:
                                                    'Berhasil Melakukan Withdraw',
                                                customColor: Colors.green);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        WithdrawListPage()));
                                          } else {
                                            showSnackbar(context,
                                                title:
                                                    'Gagal Melakukan Withdraw',
                                                customColor: Colors.orange);
                                          }
                                        });
                                      }
                                    }
                                  });
                                }
                              }
                            }
                          },
                          text: 'Tarik Saldo',
                          pressAble: true),
                      SizedBox(height: 10.0.w),
                    ],
                  )
                ],
              ))
            ],
          );
        });
  }
}
