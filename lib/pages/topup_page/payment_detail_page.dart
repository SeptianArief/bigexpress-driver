import 'dart:async';

import 'package:bigexpress_driver/cubits/cubits.dart';
import 'package:bigexpress_driver/models/payment_list_model.dart';
import 'package:bigexpress_driver/shared/shared.dart';
import 'package:bigexpress_driver/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class PaymentDetailPage extends StatefulWidget {
  final double totalTopup;
  final PaymentListLoaded stateCurrent;
  final PaymentList data;
  final int timeRemaining;
  const PaymentDetailPage(
      {super.key,
      required this.totalTopup,
      required this.stateCurrent,
      required this.timeRemaining,
      required this.data});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  UtilCubit paymentListCubit = UtilCubit();
  Timer? timerCountdown;
  late int expiredDate;

  @override
  void dispose() {
    timerCountdown?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      expiredDate = widget.timeRemaining;
    });

    timerCountdown = Timer.periodic(Duration(seconds: 1), (timer) {
      if (expiredDate > 0) {
        setState(() {
          expiredDate = expiredDate - 1;
        });
      }
    });

    paymentListCubit.fetchPaymentDetail(context,
        data: widget.stateCurrent.data,
        isVA: widget.data.code == 'BCAVA',
        amount: widget.totalTopup.toStringAsFixed(0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        UserState userState = BlocProvider.of<UserCubit>(context).state;
        if (userState is UserLogged) {
          BlocProvider.of<TopupCubit>(context)
              .fetchTopup(id: userState.user.id.toString());
        }
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).viewPadding.top,
              color: Theme.of(context).primaryColor,
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.0.w),
                  width: double.infinity,
                  color: Colors.black38,
                  padding: EdgeInsets.only(
                      bottom: 25.0.w, left: 5.0.w, right: 5.0.w, top: 5.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Big Express',
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 12.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.0.w),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                        height: 28.0.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total',
                                  style: FontTheme.regularBaseFont.copyWith(
                                    fontSize: 10.0.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Bayar Sebelum ',
                                      style: FontTheme.regularBaseFont.copyWith(
                                        fontSize: 10.0.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      '${(expiredDate ~/ 3600).toString().padLeft(2, '0')}:${((expiredDate % 3600) ~/ 60).toString().padLeft(2, '0')}:${((expiredDate % 3600) % 60).toString().padLeft(2, '0')}',
                                      style: FontTheme.regularBaseFont.copyWith(
                                        fontSize: 11.0.sp,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.0.w,
                            ),
                            BlocBuilder<UtilCubit, UtilState>(
                                bloc: paymentListCubit,
                                builder: (context, state) {
                                  if (state is PaymentListDetailLoaded) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          moneyChanger(
                                              double.parse(state.data.amount)),
                                          style: FontTheme.boldBaseFont
                                              .copyWith(
                                                  fontSize: 14.0.sp,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 2.0.w,
                                        ),
                                        Text(
                                          'Order ID #${state.data.orderId}',
                                          style: FontTheme.regularBaseFont
                                              .copyWith(
                                            fontSize: 9.0.sp,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (state is UtilLoading) {
                                    return PlaceHolder(
                                      child: Container(
                                        width: 40.0.w,
                                        height: 5.0.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                      ),
                                    );
                                  }

                                  return Container();
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
                child: BlocBuilder<UtilCubit, UtilState>(
                    bloc: paymentListCubit,
                    builder: (context, state) {
                      if (state is PaymentListDetailLoaded) {
                        return ListView(
                          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5.0.w,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.data.name,
                                        style: FontTheme.boldBaseFont.copyWith(
                                            fontSize: 13.0.sp,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3.0.w,
                                    ),
                                    Container(
                                      width: 12.0.w,
                                      height: 12.0.w,
                                      child: Image.network(widget.data.icon),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3.0.w,
                                ),
                                Text(
                                  widget.data.desc,
                                  style: FontTheme.regularBaseFont,
                                ),
                                SizedBox(
                                  height: 5.0.w,
                                ),
                                Text(
                                  widget.data.code == 'BCAVA'
                                      ? 'Rekening Virtual Account Big Express'
                                      : 'Rekening PT Big Express',
                                  style: FontTheme.boldBaseFont.copyWith(
                                      fontSize: 12.0.sp,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 3.0.w),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black12))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state.data.norek,
                                          style: FontTheme.boldBaseFont
                                              .copyWith(
                                                  fontSize: 12.0.sp,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3.0.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: state.data.norek));
                                          showSnackbar(context,
                                              title:
                                                  'Nomor Rekening Berhasil di salin',
                                              customColor: Colors.green);
                                        },
                                        child: Text(
                                          'Copy',
                                          style: FontTheme.boldBaseFont
                                              .copyWith(
                                                  fontSize: 12.0.sp,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 3.0.w,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.help,
                                      color: Theme.of(context).primaryColor,
                                      size: 5.0.w,
                                    ),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                    Text(
                                      'How to pay',
                                      style: FontTheme.boldBaseFont.copyWith(
                                          fontSize: 11.0.sp,
                                          color:
                                              Theme.of(context).primaryColor),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0.w,
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(3.0.w),
                                  color: Color(0xffeef2f6),
                                  child: Text(
                                    state.data.data.howto,
                                    style: FontTheme.regularBaseFont.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9.0.sp,
                                        color: Colors.black87),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    UserState userState =
                                        BlocProvider.of<UserCubit>(context)
                                            .state;
                                    if (userState is UserLogged) {
                                      BlocProvider.of<TopupCubit>(context)
                                          .fetchTopup(
                                              id: userState.user.id.toString());
                                    }
                                    Navigator.pop(context, true);
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 3.0.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).primaryColor),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Kembali',
                                      style: FontTheme.regularBaseFont.copyWith(
                                          fontSize: 11.0.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0.w,
                                )
                              ],
                            ),
                          ],
                        );
                      } else if (state is UtilLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        );
                      } else {
                        return FailedRequest(onTap: () {
                          paymentListCubit.fetchPaymentDetail(context,
                              data: widget.stateCurrent.data,
                              isVA: widget.data.code == 'BCAVA',
                              amount: widget.totalTopup.toStringAsFixed(0));
                        });
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
