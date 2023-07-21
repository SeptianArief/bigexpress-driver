part of '../pages.dart';

class TopupListPage extends StatefulWidget {
  const TopupListPage({Key? key}) : super(key: key);

  @override
  State<TopupListPage> createState() => _TopupListPageState();
}

class _TopupListPageState extends State<TopupListPage> {
  UtilCubit topupCubit = UtilCubit();

  @override
  void initState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      BlocProvider.of<TopupCubit>(context)
          .fetchTopup(id: userState.user.id.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent());
  }

  Widget _buildContent() {
    return Column(
      children: [
        HeaderBar(title: 'Topup'),
        BlocBuilder<TopupCubit, UtilState>(
            bloc: BlocProvider.of<TopupCubit>(context),
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
                        margin:
                            EdgeInsets.only(top: index == 0 ? 3.0.w : 2.0.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                      ),
                    );
                  }),
                ));
              } else if (state is TopupLoaded) {
                return Expanded(
                    child: state.data.isEmpty
                        ? Center(
                            child: Text(
                              'Item Kosong',
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 12.0.sp, color: Colors.black54),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              UserState userState =
                                  BlocProvider.of<UserCubit>(context).state;
                              if (userState is UserLogged) {
                                BlocProvider.of<TopupCubit>(context).fetchTopup(
                                    id: userState.user.id.toString());
                              }
                            },
                            child: ListView(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 5.0.w),
                                children:
                                    List.generate(state.data.length, (index) {
                                  return Container(
                                      margin: EdgeInsets.only(
                                          top: index == 0 ? 3.0.w : 2.0.w,
                                          bottom: state.data.length - 1 == index
                                              ? 5.0.w
                                              : 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // if (state.data[index].status == 0 ||
                                          //     state.data[index].status == 1) {
                                          //   Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (_) => TopupWebview(
                                          //               url:
                                          //                   'https://app.midtrans.com/snap/v2/vtweb/${state.data[index].evidence}')));
                                          // }
                                        },
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Container(
                                                padding: EdgeInsets.all(5.0.w),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              state.data[index]
                                                                  .orderId,
                                                              style: FontTheme
                                                                  .regularBaseFont
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11.0
                                                                              .sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: ColorPallette
                                                                          .baseBlue)),
                                                          Text(
                                                              // dateToReadable(state
                                                              //         .data[
                                                              //             index]
                                                              //         .requestedAt
                                                              //         .substring(
                                                              //             0,
                                                              //             10)) +
                                                              //     ' ' +
                                                              //     state
                                                              //         .data[
                                                              //             index]
                                                              //         .requestedAt
                                                              //         .substring(
                                                              //             11, 16),
                                                              "",
                                                              style: FontTheme
                                                                  .regularBaseFont
                                                                  .copyWith(
                                                                      fontSize:
                                                                          9.0
                                                                              .sp,
                                                                      color: ColorPallette
                                                                          .baseBlack)),
                                                        ],
                                                      ),
                                                      SizedBox(height: 2.0.w),
                                                      Text(
                                                          moneyChanger(state
                                                              .data[index]
                                                              .amount),
                                                          style: FontTheme
                                                              .boldBaseFont
                                                              .copyWith(
                                                                  fontSize:
                                                                      13.0.sp,
                                                                  color: ColorPallette
                                                                      .baseBlue)),
                                                      Text(
                                                          state.data[index]
                                                                          .status ==
                                                                      0 ||
                                                                  state
                                                                          .data[
                                                                              index]
                                                                          .status ==
                                                                      1
                                                              ? 'Menunggu Pembayaran'
                                                              : state
                                                                          .data[
                                                                              index]
                                                                          .status ==
                                                                      2
                                                                  ? 'Sukses'
                                                                  : 'Gagal',
                                                          style: FontTheme
                                                              .regularBaseFont
                                                              .copyWith(
                                                            fontSize: 11.0.sp,
                                                            color: state.data[index].status ==
                                                                        0 ||
                                                                    state
                                                                            .data[
                                                                                index]
                                                                            .status ==
                                                                        1
                                                                ? Colors.orange
                                                                : state.data[index]
                                                                            .status ==
                                                                        2
                                                                    ? Colors.green
                                                                    : Colors.red,
                                                          )),
                                                      SizedBox(height: 3.0.w),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Metode Pembayaran',
                                                              style: FontTheme
                                                                  .regularBaseFont
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11.0
                                                                              .sp,
                                                                      color: Colors
                                                                          .black54)),
                                                          Text(
                                                              state
                                                                      .data[
                                                                          index]
                                                                      .paymentMethod
                                                                      .isEmpty
                                                                  ? '-'
                                                                  : state
                                                                      .data[
                                                                          index]
                                                                      .paymentMethod,
                                                              style: FontTheme
                                                                  .regularBaseFont
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12.0
                                                                              .sp,
                                                                      color: Colors
                                                                          .black87))
                                                        ],
                                                      )
                                                    ]))),
                                      ));
                                })),
                          ));
              } else {
                return Expanded(
                  child: FailedRequest(
                    onTap: () {
                      UserState userState =
                          BlocProvider.of<UserCubit>(context).state;
                      if (userState is UserLogged) {
                        BlocProvider.of<TopupCubit>(context)
                            .fetchTopup(id: userState.user.id.toString());
                      }
                    },
                  ),
                );
              }
            }),
        GestureDetector(
          onTap: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => TopupPage()));
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.0.w),
              color: ColorPallette.baseBlue,
              alignment: Alignment.center,
              child: Text('+ Topup',
                  style: FontTheme.boldBaseFont.copyWith(
                      fontSize: 13.0.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))),
        )
      ],
    );
  }
}
