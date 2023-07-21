part of 'widgets.dart';

class FailedRequest extends StatelessWidget {
  final Function onTap;
  const FailedRequest({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.0.w,
            height: 30.0.w,
            child:
                Image.asset('assets/images/emoji-sad.png', fit: BoxFit.cover),
          ),
          SizedBox(height: 5.0.w),
          Text(
            'Gagal Memuat Data',
            style: FontTheme.regularBaseFont.copyWith(
                fontSize: 13.0.sp,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2.0.w),
          Text(
            'Silahkan untuk mencoba kembali',
            style: FontTheme.regularBaseFont
                .copyWith(fontSize: 11.0.sp, color: Colors.black54),
          ),
          SizedBox(height: 5.0.w),
          SizedBox(
              width: 70.0.w,
              child: CustomButton(
                  onTap: () {
                    onTap();
                  },
                  text: 'Coba Lagi',
                  pressAble: true))
        ],
      ),
    );
  }
}
