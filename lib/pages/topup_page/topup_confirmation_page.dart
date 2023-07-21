part of '../pages.dart';

class TopupConfirmationPage extends StatefulWidget {
  final double totalAmount;
  final BankOwnerModel destinationBank;
  const TopupConfirmationPage(
      {Key? key, required this.totalAmount, required this.destinationBank})
      : super(key: key);

  @override
  State<TopupConfirmationPage> createState() => _TopupConfirmationPageState();
}

class _TopupConfirmationPageState extends State<TopupConfirmationPage> {
  XFile? selectedTopupEvidence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildContent());
  }

  Widget _buildContent() {
    return Column(
      children: [
        HeaderBar(title: 'Konfirmasi Topup'),
        Expanded(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          children: [
            SizedBox(height: 5.0.w),
            Text(
              'Total Topup',
              style: FontTheme.boldBaseFont
                  .copyWith(fontSize: 12.0.sp, color: Colors.black87),
            ),
            SizedBox(height: 1.0.w),
            Text(
              moneyChanger(widget.totalAmount),
              style: FontTheme.regularBaseFont
                  .copyWith(fontSize: 12.0.sp, color: Colors.black54),
            ),
            SizedBox(height: 5.0.w),
            Text(
              'Metode Pembayaran',
              style: FontTheme.boldBaseFont
                  .copyWith(fontSize: 12.0.sp, color: Colors.black87),
            ),
            SizedBox(height: 1.0.w),
            Text(
              'Bank Transfer (${widget.destinationBank.bankName})',
              style: FontTheme.regularBaseFont
                  .copyWith(fontSize: 12.0.sp, color: Colors.black54),
            ),
            SizedBox(height: 5.0.w),
            Text(
              'Nomor Rekening',
              style: FontTheme.boldBaseFont
                  .copyWith(fontSize: 12.0.sp, color: Colors.black87),
            ),
            SizedBox(height: 1.0.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.destinationBank.accountNumber,
                  style: FontTheme.regularBaseFont
                      .copyWith(fontSize: 11.0.sp, color: Colors.black54),
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.0.w, vertical: 2.0.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorPallette.baseBlue),
                    child: Text('Salin',
                        style:
                            TextStyle(fontSize: 10.0.sp, color: Colors.white)))
              ],
            ),
            SizedBox(height: 5.0.w),
            Text(
              'Foto Bukti Topup',
              style: FontTheme.boldBaseFont
                  .copyWith(fontSize: 12.0.sp, color: Colors.black87),
            ),
            SizedBox(height: 2.0.w),
            GestureDetector(
              onTap: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera, maxWidth: 500);

                if (photo != null) {
                  setState(() {
                    selectedTopupEvidence = photo;
                  });
                }
              },
              child: Container(
                  width: 90.0.w,
                  height: 45.0.w,
                  decoration: selectedTopupEvidence == null
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                  File(selectedTopupEvidence!.path)))),
                  child: selectedTopupEvidence != null
                      ? Center(
                          child: Text('Ganti Foto',
                              style: FontTheme.boldBaseFont.copyWith(
                                  fontSize: 13.0.sp,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold)))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_camera, color: Colors.black54),
                            SizedBox(width: 2.0.w),
                            Text('Pilih Bukti Topup',
                                style: FontTheme.regularBaseFont.copyWith(
                                    fontSize: 11.0.sp, color: Colors.black54))
                          ],
                        )),
            ),
            SizedBox(height: 2.0.w),
            Text('Mohon untuk mengunggah foto upload bukti transfer',
                style: FontTheme.regularBaseFont.copyWith(
                    fontSize: 11.0.sp,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic)),
            SizedBox(height: 10.0.w),
            CustomButton(
                onTap: () {
                  // yesOrNoDialog(context,
                  //         title: 'Konfirmasi Topup',
                  //         desc: 'Apakah Anda yakin untuk mengkonfirmasi Topup?')
                  //     .then((value) {
                  //   if (value) {
                  //     UserState userState =
                  //         BlocProvider.of<UserCubit>(context).state;
                  //     if (userState is UserLogged) {
                  //       EasyLoading.show(status: 'Mohon Tunggu');
                  //       TopupService.topup(
                  //               amount: widget.totalAmount.toInt(),
                  //               id: userState.user.id.toString(),
                  //               evidencePhoto:
                  //                   File(selectedTopupEvidence!.path))
                  //           .then((valueRequest) {
                  //         EasyLoading.dismiss();
                  //         if (valueRequest.status ==
                  //             RequestStatus.success_request) {
                  //           showSnackbar(context,
                  //               title: 'Berhasil Mengkonfirmasi Topup',
                  //               customColor: Colors.green);
                  //           Navigator.pop(context);
                  //           Navigator.pop(context);

                  //           Navigator.pop(context, true);
                  //         } else {
                  //           showSnackbar(context,
                  //               title: 'Gagal Mengkonfirmasi Topup',
                  //               customColor: Colors.orange);
                  //         }
                  //       });
                  //     }
                  //   }
                  // });
                },
                text: 'Konfirmasi Topup',
                pressAble: true),
            SizedBox(height: 10.0.w),
          ],
        ))
      ],
    );
  }
}
