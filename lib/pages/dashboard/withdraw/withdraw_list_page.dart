part of '../../pages.dart';

class WithdrawListPage extends StatefulWidget {
  const WithdrawListPage({Key? key}) : super(key: key);

  @override
  State<WithdrawListPage> createState() => _WithdrawListPageState();
}

class _WithdrawListPageState extends State<WithdrawListPage> {
  UtilCubit withdrawCubit = UtilCubit();

  @override
  void initState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      withdrawCubit.fetchWithdraw(id: userState.user.id.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent());
  }

  Widget _buildContent() {
    return Column(children: [
      HeaderBar(title: 'List Withdraw'),
      BlocBuilder<UtilCubit, UtilState>(
        bloc: withdrawCubit,
        builder: (context, state) {
          if (state is UtilLoading) {
            return Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
              children: List.generate(8, (index) {
                return PlaceHolder(
                  child: Container(
                    width: 90.0.w,
                    height: 20.0.w,
                    margin: EdgeInsets.only(top: index == 0 ? 3.0.w : 2.0.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                  ),
                );
              }),
            ));
          } else if (state is WithdrawLoaded) {
            return Expanded(
                child: state.data.isEmpty
                    ? Center(
                        child: Text(
                          'Item Kosong',
                          style: FontTheme.regularBaseFont.copyWith(
                              fontSize: 12.0.sp, color: Colors.black54),
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        children: List.generate(state.data.length, (index) {
                          return Container(
                              margin: EdgeInsets.only(
                                  top: index == 0 ? 3.0.w : 2.0.w,
                                  bottom: state.data.length - 1 == index
                                      ? 5.0.w
                                      : 0),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                      padding: EdgeInsets.all(5.0.w),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                dateToReadable(state
                                                        .data[index].requestedAt
                                                        .substring(0, 10)) +
                                                    ' ' +
                                                    state
                                                        .data[index].requestedAt
                                                        .substring(11, 16),
                                                style: FontTheme.regularBaseFont
                                                    .copyWith(
                                                        fontSize: 9.0.sp,
                                                        color: ColorPallette
                                                            .baseBlack)),
                                            SizedBox(height: 1.0.w),
                                            Text(
                                                moneyChanger(state
                                                    .data[index].amount
                                                    .toDouble()),
                                                style: FontTheme.boldBaseFont
                                                    .copyWith(
                                                        fontSize: 12.0.sp,
                                                        color: ColorPallette
                                                            .baseBlue)),
                                            Text(
                                                state.data[index].status == 1
                                                    ? 'Menunggu Konfirmasi'
                                                    : state.data[index]
                                                                .status ==
                                                            2
                                                        ? 'Diterima'
                                                        : 'Ditolak',
                                                style: FontTheme.regularBaseFont
                                                    .copyWith(
                                                  fontSize: 10.0.sp,
                                                  color: state.data[index]
                                                              .status ==
                                                          1
                                                      ? Colors.orange
                                                      : state.data[index]
                                                                  .status ==
                                                              2
                                                          ? Colors.green
                                                          : Colors.red,
                                                )),
                                            SizedBox(height: 2.0.w),
                                            state.data[index].status == 1 ||
                                                    state.data[index].status ==
                                                        2
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                        Text(
                                                          'Detail Akun Bank',
                                                          style: FontTheme
                                                              .regularBaseFont
                                                              .copyWith(
                                                                  fontSize:
                                                                      10.0.sp,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text('Bank',
                                                                style: FontTheme
                                                                    .regularBaseFont
                                                                    .copyWith(
                                                                        fontSize:
                                                                            10.0
                                                                                .sp,
                                                                        color: Colors
                                                                            .black54)),
                                                            Text(
                                                                state
                                                                    .data[index]
                                                                    .bankName,
                                                                style: FontTheme
                                                                    .regularBaseFont
                                                                    .copyWith(
                                                                        fontSize:
                                                                            10.0
                                                                                .sp,
                                                                        color: Colors
                                                                            .black87)),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'Nomor Rekening',
                                                                style: FontTheme
                                                                    .regularBaseFont
                                                                    .copyWith(
                                                                        fontSize:
                                                                            10.0
                                                                                .sp,
                                                                        color: Colors
                                                                            .black54)),
                                                            Text(
                                                                state
                                                                    .data[index]
                                                                    .bankAccount,
                                                                style: FontTheme
                                                                    .regularBaseFont
                                                                    .copyWith(
                                                                        fontSize:
                                                                            10.0
                                                                                .sp,
                                                                        color: Colors
                                                                            .black87)),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text('Pemilik',
                                                                style: FontTheme
                                                                    .regularBaseFont
                                                                    .copyWith(
                                                                        fontSize:
                                                                            10.0
                                                                                .sp,
                                                                        color: Colors
                                                                            .black54)),
                                                            Text(
                                                                state
                                                                    .data[index]
                                                                    .bankOwner,
                                                                style: FontTheme
                                                                    .regularBaseFont
                                                                    .copyWith(
                                                                        fontSize:
                                                                            10.0
                                                                                .sp,
                                                                        color: Colors
                                                                            .black87)),
                                                          ],
                                                        ),
                                                      ])
                                                : Column(
                                                    children: [],
                                                  )
                                          ]))));
                        })));
          } else {
            return Expanded(child: FailedRequest(
              onTap: () {
                UserState userState = BlocProvider.of<UserCubit>(context).state;
                if (userState is UserLogged) {
                  withdrawCubit.fetchWithdraw(id: userState.user.id.toString());
                }
              },
            ));
          }
        },
      )
    ]);
  }
}
