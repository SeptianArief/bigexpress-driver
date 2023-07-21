import 'dart:async';

import 'package:bigexpress_driver/cubits/cubits.dart';
import 'package:bigexpress_driver/pages/topup_page/payment_detail_page.dart';
import 'package:bigexpress_driver/shared/shared.dart';
import 'package:bigexpress_driver/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class TopupListPaymentPage extends StatefulWidget {
  final double totalTopup;
  const TopupListPaymentPage({super.key, required this.totalTopup});

  @override
  State<TopupListPaymentPage> createState() => _TopupListPaymentPageState();
}

class _TopupListPaymentPageState extends State<TopupListPaymentPage> {
  UtilCubit paymentListCubit = UtilCubit();
  Timer? timerCountdown;
  int expiredDate = 86400;

  @override
  void dispose() {
    timerCountdown?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    timerCountdown = Timer.periodic(Duration(seconds: 1), (timer) {
      if (expiredDate > 0) {
        setState(() {
          expiredDate = expiredDate - 1;
        });
      }
    });

    paymentListCubit.fetchPaymentList(context,
        amount: widget.totalTopup.toStringAsFixed(0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Text(
                            moneyChanger(widget.totalTopup),
                            style: FontTheme.boldBaseFont.copyWith(
                                fontSize: 14.0.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2.0.w,
                          ),
                          BlocBuilder<UtilCubit, UtilState>(
                              bloc: paymentListCubit,
                              builder: (context, state) {
                                if (state is PaymentListLoaded) {
                                  return Text(
                                    'Order ID #${state.data.trxId}',
                                    style: FontTheme.regularBaseFont.copyWith(
                                      fontSize: 9.0.sp,
                                      color: Colors.black54,
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
                    if (state is PaymentListLoaded) {
                      return ListView(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        children: [
                          SizedBox(
                            height: 5.0.w,
                          ),
                          Text(
                            'Pilih Cara Pembayaran',
                            style: FontTheme.boldBaseFont.copyWith(
                                fontSize: 13.0.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children:
                                List.generate(state.data.data.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => PaymentDetailPage(
                                              totalTopup: widget.totalTopup,
                                              stateCurrent: state,
                                              timeRemaining: expiredDate,
                                              data: state.data.data[index])));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(3.0.w),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black12))),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12.0.w,
                                        height: 12.0.w,
                                        child: Image.network(
                                            state.data.data[index].icon),
                                      ),
                                      SizedBox(
                                        width: 3.0.w,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.data.data[index].name,
                                            style: FontTheme.boldBaseFont
                                                .copyWith(
                                                    fontSize: 12.0.sp,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Text(
                                            state.data.data[index].desc,
                                            style: FontTheme.boldBaseFont
                                                .copyWith(
                                                    fontSize: 9.0.sp,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.normal),
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                              );
                            }),
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
                        paymentListCubit.fetchPaymentList(context,
                            amount: widget.totalTopup.toStringAsFixed(0));
                      });
                    }
                  }))
        ],
      ),
    );
  }
}
