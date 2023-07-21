part of '../pages.dart';

class FinishPaymentPage extends StatefulWidget {
  const FinishPaymentPage({Key? key}) : super(key: key);

  @override
  State<FinishPaymentPage> createState() => _FinishPaymentPageState();
}

class _FinishPaymentPageState extends State<FinishPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                width: 100.0.w,
                height: 100.0.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 100.0.w,
                        height: 50.0.w,
                        child: Center(
                            child: Container(
                                width: 70.0.w,
                                child: Image.asset(
                                    'assets/images/gopay_logo.png')))),
                    SizedBox(height: 2.0.w),
                    Text(
                      'Selesaikan Pembayaran',
                      style: TextStyle(
                          fontSize: 16.0.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0.w),
                    SizedBox(
                      width: 90.0.w,
                      child: Text(
                          'Jika Anda Sudah Melakukan Pembayaran, Silahkan Keluar Dari Halaman Ini',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Colors.black87.withOpacity(0.5))),
                    ),
                    SizedBox(height: 5.0.w),
                  ],
                )),
            Positioned(
                top: 3.0.w,
                right: 3.0.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, color: Colors.black54),
                ))
          ],
        ),
      ),
    );
  }
}

class PendingPaymentSummary extends StatefulWidget {
  final PendingPayment data;
  PendingPaymentSummary({Key? key, required this.data}) : super(key: key);

  @override
  _PendingPaymentSummaryState createState() => _PendingPaymentSummaryState();
}

class _PendingPaymentSummaryState extends State<PendingPaymentSummary> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: widget.data.type == PendingPaymentType.emoney
            ? _buildContentEmoney()
            : _buildContent());
  }

  Widget _buildContentEmoney() {
    return Container(
        width: 100.0.w,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100.0.w,
                height: 50.0.w,
                // child: Image.asset(
                //   'assets/gif/success_payment.gif',
                // )
              ),
              SizedBox(height: 2.0.w),
              Text(
                'Selesaikan Pembayaran',
                style: TextStyle(
                    fontSize: 16.0.sp,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rp',
                      style:
                          TextStyle(fontSize: 15.0.sp, color: Colors.black87)),
                  Text(moneyChanger(widget.data.amount, customLabel: ''),
                      style: TextStyle(
                          fontSize: 25.0.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                ],
              ),
              SizedBox(height: 5.0.w),
              Container(
                  width: 40.0.w,
                  height: 20.0.w,
                  child: Image.asset(widget.data.assetImage)),
              SizedBox(height: 10.0.w),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                child: CustomButton(
                    pressAble: true,
                    text: 'Bayar Sekarang',
                    onTap: () {
                      launch(widget.data.token);
                    }),
              ),
              SizedBox(height: 2.0.w),
              SizedBox(
                width: 90.0.w,
                child: Text(
                    'Jika Anda Sudah Melakukan Pembayaran, Silahkan Keluar Dari Halaman Ini',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.0.sp,
                        color: Colors.black87.withOpacity(0.5))),
              ),
              SizedBox(height: 5.0.w),
            ],
          ),
        ));
  }

  Widget _buildContent() {
    return SafeArea(
      child: Container(
          width: 100.0.w,
          child: Column(
            children: [
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 4.0.w),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close, color: ColorPallette.baseBlue))),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 90.0.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 100.0.w,
                            height: 50.0.w,
                            child: Image.asset(
                              'assets/images/Pembayaran Sukses.png',
                            )),
                        SizedBox(height: 2.0.w),
                        Text(
                          'Selesaikan Pembayaran',
                          style: TextStyle(
                              fontSize: 16.0.sp,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text('Sebelum ${widget.data.expDate}',
                            style: TextStyle(
                                fontSize: 12.0.sp,
                                color: Colors.black87.withOpacity(0.5))),
                        SizedBox(height: 10.0.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rp',
                                style: TextStyle(
                                    fontSize: 15.0.sp, color: Colors.black87)),
                            Text(
                                moneyChanger(widget.data.amount,
                                    customLabel: ''),
                                style: TextStyle(
                                    fontSize: 25.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: widget.data.amount.toInt().toString()));
                              showSnackbar(context, title: 'Berhasil disalin');
                            },
                            child: Text(
                              'Salin Jumlah',
                              style: TextStyle(
                                  fontSize: 12.0.sp,
                                  color: Theme.of(context).primaryColor),
                            )),
                        SizedBox(height: 5.0.w),
                        Card(
                            child: Container(
                                width: 90.0.w,
                                padding: EdgeInsets.all(5.0.w),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Container(
                                          width: 25.0.w,
                                          height: 10.0.w,
                                          child: Image.asset(
                                              widget.data.assetImage)),
                                      SizedBox(
                                        width: 2.0.w,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 43.0.w,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          widget.data.type ==
                                                                  PendingPaymentType
                                                                      .CStore
                                                              ? 'Kode Pembayaran'
                                                              : 'No. Virtual Account',
                                                          style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              color: Colors
                                                                  .black87
                                                                  .withOpacity(
                                                                      0.7))),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Text(
                                                            widget.data.number,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    15.0.sp,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ],
                                                  )),
                                              GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: widget
                                                              .data.number));

                                                  showSnackbar(context,
                                                      title:
                                                          'Nomor VA Berhasil disalin');
                                                },
                                                child: Container(
                                                    width: 10.0.w,
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Icon(Icons.copy,
                                                        color: Colors.black87
                                                            .withOpacity(0.5),
                                                        size: 6.0.w)),
                                              )
                                            ],
                                          ),
                                          widget.data.companyCode == null
                                              ? Container()
                                              : Row(children: [
                                                  SizedBox(
                                                      width: 43.0.w,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Kode Perusahaan',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.0.sp,
                                                                  color: Colors
                                                                      .black87
                                                                      .withOpacity(
                                                                          0.7))),
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                                widget.data
                                                                    .companyCode!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0.sp,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ],
                                                      )),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: widget.data
                                                                  .companyCode!));
                                                      showSnackbar(context,
                                                          title:
                                                              'Kode Perusahaan disalin');
                                                    },
                                                    child: Container(
                                                        width: 10.0.w,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Icon(Icons.copy,
                                                            color: Colors
                                                                .black87
                                                                .withOpacity(
                                                                    0.5),
                                                            size: 6.0.w)),
                                                  )
                                                ])
                                        ],
                                      )
                                    ]),
                                  ],
                                ))),
                        SizedBox(height: 15.0.w),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class SuccessPayment extends StatefulWidget {
  const SuccessPayment({
    Key? key,
  }) : super(key: key);

  @override
  _SuccessPaymentState createState() => _SuccessPaymentState();
}

class _SuccessPaymentState extends State<SuccessPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    String time = DateFormat('HH:mm').format(DateTime.now());
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return SafeArea(
      child: Container(
          width: 100.0.w,
          child: Column(
            children: [
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 4.0.w),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close, color: ColorPallette.baseBlue))),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 90.0.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 100.0.w,
                            height: 50.0.w,
                            child: Image.asset(
                              'assets/images/Pembayaran Sukses.png',
                            )),
                        SizedBox(height: 2.0.w),
                        Text(
                          'Pembayaran Terverifikasi',
                          style: TextStyle(
                              fontSize: 16.0.sp,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Terimakasih\nAtas Pembayaran Anda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 10.0.w),
                        Text('$date $time',
                            style: TextStyle(
                                fontSize: 12.0.sp,
                                color: Colors.black87.withOpacity(0.5))),
                        SizedBox(height: 15.0.w),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
