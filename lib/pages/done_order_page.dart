part of 'pages.dart';

class DonePage extends StatefulWidget {
  final TransactionDetail data;
  const DonePage({Key? key, required this.data}) : super(key: key);

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  //test
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _buildContent(),
    ));
  }

  Widget _buildContent() {
    return Container(
      width: 100.0.w,
      height: 100.0.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 35.0.w,
              height: 35.0.w,
              child: Image.asset('assets/images/success.png')),
          SizedBox(height: 5.0.w),
          Text('Pesanan Selesai',
              style: FontTheme.boldBaseFont
                  .copyWith(fontSize: 12.0.sp, color: ColorPallette.baseBlue)),
          SizedBox(height: 3.0.w),
          SizedBox(
            width: 70.0.w,
            child: Text(
              widget.data.isWallet == 1
                  ? 'Dana ${moneyChanger(widget.data.price - widget.data.discount)} sudah masuk ke dompet kamu'
                  : 'Terimakasih sudah menyelesaikan orderan ini!',
              textAlign: TextAlign.center,
              style: FontTheme.regularBaseFont
                  .copyWith(fontSize: 11.0.sp, color: Colors.black54),
            ),
          ),
          SizedBox(height: 10.0.w),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 90.0.w,
              padding: EdgeInsets.symmetric(vertical: 3.0.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorPallette.baseBlue),
              alignment: Alignment.center,
              child: Text(
                'Kembali ke Beranda',
                style: FontTheme.regularBaseFont
                    .copyWith(fontSize: 11.0.sp, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
