part of '../../pages.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  UtilCubit staticticCubit = UtilCubit();

  @override
  void initState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      staticticCubit.fetchStatistic(id: userState.user.id.toString());
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
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.w),
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
                'Statistik',
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
        BlocBuilder<UtilCubit, UtilState>(
          bloc: staticticCubit,
          builder: (context, state) {
            if (state is StatisticLoaded) {
              int ratingInt = state.data.totalOrder == 0
                  ? 0
                  : (state.data.countTotal / state.data.totalOrder).floor();
              return Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                children: [
                  SizedBox(height: 5.0.w),
                  Text(
                    'Driver Rating',
                    style: FontTheme.regularBaseFont
                        .copyWith(fontSize: 10.0.sp, color: Colors.black87),
                  ),
                  SizedBox(height: 5.0.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        size: 10.0.w,
                        color: ratingInt > index ? Colors.amber : Colors.grey,
                      );
                    }),
                  ),
                  SizedBox(height: 3.0.w),
                  Center(
                    child: Text(
                      state.data.totalOrder == 0
                          ? '0'
                          : (state.data.countTotal / state.data.totalOrder)
                              .toStringAsFixed(1),
                      style: FontTheme.boldBaseFont.copyWith(
                          fontSize: 14.0.sp, color: ColorPallette.baseBlue),
                    ),
                  ),
                  SizedBox(height: 5.0.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Selesai',
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 10.0.sp, color: Colors.black87),
                      ),
                      SizedBox(height: 1.0.w),
                      Text(
                        '${state.data.totalOrder} Order',
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 14.0.sp, color: ColorPallette.baseBlue),
                      ),
                      SizedBox(height: 5.0.w),
                      Text(
                        'Perjalanan Ditempuh',
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 10.0.sp, color: Colors.black87),
                      ),
                      SizedBox(height: 1.0.w),
                      Text(
                        '${state.data.totalKm} KM',
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 14.0.sp, color: ColorPallette.baseBlue),
                      ),
                    ],
                  )
                ],
              ));
            } else if (state is UtilLoading) {
              return Expanded(
                  child: Center(child: CircularProgressIndicator()));
            } else {
              return Expanded(child: FailedRequest(
                onTap: () {
                  UserState userState =
                      BlocProvider.of<UserCubit>(context).state;
                  if (userState is UserLogged) {
                    staticticCubit.fetchStatistic(
                        id: userState.user.id.toString());
                  }
                },
              ));
            }
          },
        )
      ],
    );
  }
}
