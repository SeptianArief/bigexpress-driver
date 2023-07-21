part of '../pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int _selectedIndex = 0;

  UtilCubit specialOrder = UtilCubit();
  UtilCubit genderalOrder = UtilCubit();
  UtilCubit activeOrder = UtilCubit();
  UtilCubit doneOrder = UtilCubit();

  refreshData(BuildContext context) {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      specialOrder.specialOrder(id: userState.user.id.toString());
      BlocProvider.of<UserCubit>(context)
          .refreshProfile(id: userState.user.id.toString());
      genderalOrder.listOpenOrder();
      activeOrder.myOrder(id: userState.user.id.toString(), isActive: '1');
      doneOrder.myOrder(id: userState.user.id.toString(), isActive: '0');
    }
  }

  @override
  void initState() {
    refreshData(context);
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  Widget tabIndicator(String title, int index, int notif) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 3.0.w),
        child: Row(
          children: [
            Text(
              title,
              style: FontTheme.regularBaseFont.copyWith(
                  fontSize: 10.0.sp,
                  fontWeight: _selectedIndex == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedIndex == index
                      ? ColorPallette.baseBlue
                      : Colors.black38),
            ),
            notif > 0
                ? Container(
                    margin: EdgeInsets.only(left: 1.0.w),
                    padding: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: Text(notif.toString(),
                        style: FontTheme.regularBaseFont
                            .copyWith(color: Colors.white, fontSize: 7.0.sp)))
                : Container()
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: BlocProvider.of<UserCubit>(context),
      builder: (context, state) {
        if (state is UserLogged) {
          return SafeArea(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 4.0.w, horizontal: 5.0.w),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          ColorPallette.baseBlue,
                          Color(0xFFBAC8DE),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BIG Kurir',
                          style: FontTheme.mediumBaseFont.copyWith(
                            fontSize: 14.0.sp,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            // Icon(Icons.notifications_none_rounded,
                            //     size: 8.0.w, color: Colors.white),
                            // SizedBox(width: 5.0.w),
                            SizedBox(
                              width: 8.0.w,
                              height: 8.0.w,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ProfilePage()));
                                },
                                child: ImageIcon(
                                  const AssetImage(
                                      'assets/images/Group 367.png'),
                                  color: Colors.white,
                                  size: 8.0.w,
                                ),
                              ),
                            ),
                            SizedBox(width: 5.0.w),
                            GestureDetector(
                              onTap: () async {
                                UserState userState =
                                    BlocProvider.of<UserCubit>(context).state;
                                if (userState is UserLogged) {
                                  EasyLoading.show(status: 'Mohon Tunggu..');
                                  OrderService.onOffBid(
                                          id: userState.user.id.toString(),
                                          status: userState.user.available == 1
                                              ? false
                                              : true)
                                      .then((value) {
                                    EasyLoading.dismiss();
                                    if (value.status ==
                                        RequestStatus.success_request) {
                                      BlocProvider.of<UserCubit>(context)
                                          .refreshProfile(
                                              id: userState.user.id.toString());
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: value.data ??
                                              'Gagal Menonaktifkan Bid, Silahkan Coba Lagi Nanti');
                                    }
                                  });
                                }
                              },
                              child: SizedBox(
                                width: 8.0.w,
                                height: 8.0.w,
                                child: Image.asset(state.user.available == 1
                                    ? 'assets/images/emoji-happy.png'
                                    : 'assets/images/emoji-sad.png'),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                Container(
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
                  child: TabBar(
                      isScrollable: true,
                      controller: tabController,
                      onTap: (value) {
                        setState(() {
                          _selectedIndex = value;
                        });
                      },
                      indicatorColor: ColorPallette.baseBlue,
                      tabs: [
                        BlocBuilder<UtilCubit, UtilState>(
                            bloc: specialOrder,
                            builder: (context, spesialState) {
                              return tabIndicator(
                                  'Pesanan Khusus',
                                  0,
                                  spesialState is TransactionLoaded
                                      ? spesialState.data.length
                                      : 0);
                            }),
                        BlocBuilder<UtilCubit, UtilState>(
                            bloc: genderalOrder,
                            builder: (context, genState) {
                              return tabIndicator(
                                  'Pesanan Umum',
                                  1,
                                  genState is TransactionLoaded
                                      ? genState.data.length
                                      : 0);
                            }),
                        BlocBuilder<UtilCubit, UtilState>(
                            bloc: activeOrder,
                            builder: (context, activeState) {
                              return tabIndicator(
                                  'Order Aktif',
                                  2,
                                  activeState is TransactionLoaded
                                      ? activeState.data.length
                                      : 0);
                            }),
                        BlocBuilder<UtilCubit, UtilState>(
                            bloc: doneOrder,
                            builder: (context, doneState) {
                              return tabIndicator(
                                  'Order Selesai',
                                  3,
                                  doneState is TransactionLoaded
                                      ? doneState.data.length
                                      : 0);
                            }),
                      ]),
                ),
                Expanded(child: _buildContent(state))
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildContent(UserLogged state) {
    Widget _nonActiveWidget() {
      return Container(
        width: 100.0.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 25.0.w,
              height: 25.0.w,
              child: Image.asset(
                'assets/images/emoji-sad.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.0.w),
            Text(
              'Kamu sedang tidak bekerja',
              style: FontTheme.mediumBaseFont
                  .copyWith(color: ColorPallette.baseBlue, fontSize: 13.0.sp),
            ),
            SizedBox(
              height: 2.0.w,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
              child: Text(
                'Pekerjaan tidak tersedia sampai kamu melanjutkan pekerjaan',
                textAlign: TextAlign.center,
                style: FontTheme.regularBaseFont
                    .copyWith(color: Colors.black54, fontSize: 10.0.sp),
              ),
            ),
            SizedBox(
              height: 10.0.w,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
              child: CustomButton(
                  onTap: () async {
                    UserState userState =
                        BlocProvider.of<UserCubit>(context).state;
                    if (userState is UserLogged) {
                      EasyLoading.show(status: 'Mohon Tunggu..');
                      OrderService.onOffBid(
                              id: userState.user.id.toString(),
                              status:
                                  userState.user.available == 1 ? false : true)
                          .then((value) {
                        EasyLoading.dismiss();
                        if (value.status == RequestStatus.success_request) {
                          BlocProvider.of<UserCubit>(context)
                              .refreshProfile(id: userState.user.id.toString());
                        } else {
                          showSnackbar(context, title: 'Gagal Update Status');
                        }
                      });
                    }
                  },
                  text: 'Lanjutkan Pekerjaan',
                  pressAble: true),
            )
          ],
        ),
      );
    }

    Widget validationSaldo(Widget dataScreen) {
      return BlocBuilder<MasterCubit, MasterState>(
        bloc: BlocProvider.of<MasterCubit>(context),
        builder: (context, stateSaldo) {
          if (stateSaldo is MasterLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (stateSaldo is MasterLoaded) {
            if (state.user.saldo < stateSaldo.data) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30.0.w,
                    height: 30.0.w,
                    child: Image.asset('assets/images/wallet(2) 2.png'),
                  ),
                  SizedBox(height: 3.0.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                    child: Text(
                      'Saldo Minimal untuk menerima pesanan adalah ${moneyChanger(stateSaldo.data)}, saldo Anda saat ini ${moneyChanger(state.user.saldo.toDouble())} Silahkan melakukan Topup Terlebih Dahulu',
                      textAlign: TextAlign.center,
                      style: FontTheme.regularBaseFont.copyWith(
                        fontSize: 10.0.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0.w),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                      child: CustomButton(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TopupListPage()));
                          },
                          text: 'Topup',
                          pressAble: true)),
                  SizedBox(height: 5.0.w),
                  GestureDetector(
                    onTap: () {
                      refreshData(context);
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.0.w,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10.0.w),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorPallette.baseBlue)),
                        alignment: Alignment.center,
                        child: Text('Refresh',
                            style: FontTheme.regularBaseFont.copyWith(
                                fontSize: 12.0.sp,
                                color: ColorPallette.baseBlue))),
                  )
                ],
              );
            } else {
              return dataScreen;
            }
          } else {
            return FailedRequest(
              onTap: () {
                refreshData(context);
                BlocProvider.of<MasterCubit>(context).fetchMasterAmount();
              },
            );
          }
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        refreshData(context);
      },
      child: TabBarView(controller: tabController, children: [
        state.user.available == 1
            ? validationSaldo(SpecialOrderSection(
                transactionCubit: specialOrder,
                onRefresh: () async {
                  refreshData(context);
                },
              ))
            : _nonActiveWidget(),
        state.user.available == 1
            ? validationSaldo(GeneralOrderSection(
                transactionCubit: genderalOrder,
                onRefresh: () async {
                  refreshData(context);
                },
              ))
            : _nonActiveWidget(),
        state.user.available == 1
            ? ActiveOrderSection(
                transactionCubit: activeOrder,
                onRefresh: () async {
                  refreshData(context);
                },
              )
            : _nonActiveWidget(),
        state.user.available == 1
            ? DoneOrderSection(
                transactionCubit: doneOrder,
                onRefresh: () async {
                  refreshData(context);
                },
              )
            : _nonActiveWidget(),
      ]),
    );
  }
}
