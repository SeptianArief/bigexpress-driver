part of '../pages.dart';

class TopupSelectPaymentPage extends StatefulWidget {
  final double topupAmount;
  const TopupSelectPaymentPage({Key? key, required this.topupAmount})
      : super(key: key);

  @override
  State<TopupSelectPaymentPage> createState() => _TopupSelectPaymentPageState();
}

class _TopupSelectPaymentPageState extends State<TopupSelectPaymentPage> {
  UtilCubit utilCubit = UtilCubit();

  @override
  void initState() {
    utilCubit.fetchBank();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(children: [
      HeaderBar(title: 'Pilih Metode Pembayaran'),
      BlocBuilder<UtilCubit, UtilState>(
          bloc: utilCubit,
          builder: (context, state) {
            if (state is UtilLoading) {
              return Expanded(
                  child: Center(child: CircularProgressIndicator()));
            } else if (state is BankListLoaded) {
              return Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                children: [
                  SizedBox(height: 5.0.w),
                  Text('Transfer Bank',
                      style: FontTheme.boldBaseFont.copyWith(
                          fontSize: 13.0.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 3.0.w),
                  Column(
                      children: List.generate(state.data.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TopupConfirmationPage(
                                      destinationBank: state.data[index],
                                      totalAmount: widget.topupAmount,
                                    )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.0.w, horizontal: 5.0.w),
                            child: Row(
                              children: [
                                Text(
                                  state.data[index].bankName,
                                  style: FontTheme.boldBaseFont.copyWith(
                                    fontSize: 12.0.sp,
                                    color: ColorPallette.baseBlue,
                                  ),
                                ),
                                SizedBox(width: 3.0.w),
                                Expanded(
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.data[index].holderName,
                                              style: FontTheme.boldBaseFont
                                                  .copyWith(
                                                      fontSize: 12.0.sp,
                                                      color: Colors.black87),
                                            ),
                                            Text(
                                              state.data[index].accountNumber,
                                              style: FontTheme.regularBaseFont
                                                  .copyWith(
                                                      fontSize: 10.0.sp,
                                                      color: Colors.black54),
                                            ),
                                          ],
                                        ))),
                                SizedBox(width: 3.0.w),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black12,
                                )
                              ],
                            )),
                      ),
                    );
                  }))
                ],
              ));
            } else {
              return Expanded(child: FailedRequest(
                onTap: () {
                  utilCubit.fetchBank();
                },
              ));
            }
          })
    ]);
  }
}
