part of '../../pages.dart';

class AccountBankFormPage extends StatefulWidget {
  final BankModel data;
  const AccountBankFormPage({Key? key, required this.data}) : super(key: key);

  @override
  State<AccountBankFormPage> createState() => _AccountBankFormPageState();
}

class _AccountBankFormPageState extends State<AccountBankFormPage> {
  String? bankName;
  TextEditingController bankNumber = TextEditingController();
  TextEditingController bankOwner = TextEditingController();
  XFile? bankBook;
  GlobalKey<FormState> step2FormState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        HeaderBar(title: 'Ubah Informasi Rekening'),
        Expanded(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          children: [
            SizedBox(height: 5.0.w),
            Form(
              key: step2FormState,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      List<String> dataBankList = [
                        'BNI',
                        'BRI',
                        'Mandiri',
                        'BTPN',
                        'BCA'
                      ];
                      int? result = await modalBottomSheet(
                        context,
                        data: dataBankList,
                        title: 'Pilih Bank Anda',
                      );

                      if (result != null) {
                        setState(() {
                          bankName = dataBankList[result];
                        });
                      }
                    },
                    child: CustomDropdown(
                      hintText: 'Pilih Bank Anda',
                      value: bankName,
                    ),
                  ),
                  bankName == null
                      ? Container(
                          margin: EdgeInsets.only(top: 2.0.w),
                          child: Text('Mohon Isi Rekening Bank Anda',
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 10.0.sp, color: Colors.red)),
                        )
                      : Container(),
                  SizedBox(height: 5.0.w),
                  InputField(
                    controller: bankNumber,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nomor Rekening Tidak Boleh Kosong';
                      } else {
                        if (isNumeric(value)) {
                          return null;
                        } else {
                          return 'Nomor Rekening Tidak Valid';
                        }
                      }
                    },
                    keyboardType: TextInputType.number,
                    hintText: 'Nomor Rekening',
                    borderType: 'border',
                  ),
                  SizedBox(height: 5.0.w),
                  InputField(
                    controller: bankOwner,
                    onChanged: (value) {},
                    hintText: 'Nama Penerima',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Mohon Isi Nama Penerima';
                      } else {
                        if (isAlpha(value.replaceAll(' ', ''))) {
                          return null;
                        } else {
                          return 'Nama Penerima Tidak Valid';
                        }
                      }
                    },
                    borderType: 'border',
                  ),
                  SizedBox(height: 5.0.w),
                  Text(
                    'Foto Buku Tabungan Anda',
                    style: FontTheme.boldBaseFont
                        .copyWith(fontSize: 10.0.sp, color: Colors.black45),
                  ),
                  SizedBox(height: 3.0.w),
                  imagePickerForm(bankBook, (value) {
                    setState(() {
                      bankBook = value;
                    });
                  }),
                  SizedBox(height: 2.0.w),
                  Text(
                    'Hanya halaman pertama buku tabungan',
                    style: FontTheme.regularBaseFont
                        .copyWith(fontSize: 7.0.sp, color: Colors.black45),
                  ),
                  bankBook == null
                      ? Container(
                          margin: EdgeInsets.only(top: 2.0.w),
                          child: Text('Mohon Upload Foto Buku Tabungan Anda',
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 10.0.sp, color: Colors.red)),
                        )
                      : Container(),
                  SizedBox(height: 10.0.w),
                  CustomButton(
                      onTap: () {
                        yesOrNoDialog(context,
                                title: 'Ubah Rekening',
                                desc:
                                    'Apakah Anda yakin untuk merubah informasi rekening')
                            .then((value) {
                          if (value) {
                            UserState userState =
                                BlocProvider.of<UserCubit>(context).state;
                            if (userState is UserLogged) {
                              EasyLoading.show(status: 'Mohon Tunggu');

                              AuthService.changeBankInfo(
                                      bankName: bankName!,
                                      bankNumber: bankNumber.text,
                                      bankOwner: bankOwner.text,
                                      bankPhoto: File(bankBook!.path),
                                      idDriver: userState.user.id.toString(),
                                      id: widget.data.id.toString(),
                                      bookName: '')
                                  .then((valueAPI) {
                                EasyLoading.dismiss();
                                if (valueAPI.status ==
                                    RequestStatus.success_request) {
                                  showSnackbar(context,
                                      title: 'Berhasil Mengganti Data Bank',
                                      customColor: Colors.green);
                                  Navigator.pop(context, true);
                                } else {
                                  showSnackbar(context,
                                      title: 'Gagal Update Data Bank',
                                      customColor: Colors.orange);
                                }
                              });
                            }
                          }
                        });
                      },
                      text: 'Ubah Rekening',
                      pressAble: true),
                  SizedBox(height: 10.0.w),
                ],
              ),
            )
          ],
        ))
      ],
    );
  }
}
