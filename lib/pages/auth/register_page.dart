part of '../pages.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> step1FormState = GlobalKey<FormState>();
  GlobalKey<FormState> step2FormState = GlobalKey<FormState>();
  GlobalKey<FormState> step3FormState = GlobalKey<FormState>();

  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController identityController = TextEditingController();
  TextEditingController birthPlaceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  DateTime? birthDateController;
  UtilCubit cityCubit = UtilCubit();
  String? selectedCity;
  String? gender;

  //step 2
  String? bankName;
  TextEditingController bankNumber = TextEditingController();
  TextEditingController bankOwner = TextEditingController();
  XFile? bankBook;

  //step 3
  XFile? selfiePhoto;
  XFile? identityPhoto;
  XFile? lisencePhoto;
  String? motorcycleType;
  TextEditingController platNumberController = TextEditingController();
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController vehicleYearController = TextEditingController();
  TextEditingController referalCodeController = TextEditingController();

  bool isAgree = false;

  int _selectedIndex = 0;
  List<String> statusStep = [
    'Pengisian Data Pribadi',
    'Langkah Selanjutnya Data Rekening',
    'Langkah Selanjutnya Data Pendukung',
    'Ini Adalah Langkah Terakhir'
  ];

  @override
  void initState() {
    cityCubit.listingCity();
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
    Widget _step1Section() {
      return Form(
        key: step1FormState,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              controller: nameController,
              onChanged: (value) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nama Tidak Boleh Kosong';
                } else {
                  if (isAlpha(value.replaceAll(' ', ''))) {
                    return null;
                  } else {
                    return 'Nama Tidak Valid';
                  }
                }
              },
              hintText: 'Nama Lengkap',
              borderType: 'border',
            ),
            SizedBox(height: 5.0.w),
            InputField(
              controller: identityController,
              onChanged: (value) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nomor KTP tidak boleh kosong';
                } else {
                  if (isNumeric(value) && value.length == 16) {
                    return null;
                  } else {
                    return 'Nomor KTP Tidak Valid';
                  }
                }
              },
              hintText: 'Nomor KTP',
              keyboardType: TextInputType.number,
              borderType: 'border',
            ),
            SizedBox(height: 5.0.w),
            InputField(
              controller: addressController,
              maxLines: 3,
              onChanged: (value) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Alamat Tidak Boleh Kosong';
                } else {
                  return null;
                }
              },
              hintText: 'Alamat',
              borderType: 'border',
            ),
            SizedBox(height: 5.0.w),
            InputField(
              controller: phoneController,
              onChanged: (value) {},
              hintText: 'Nomor Handphone',
              borderType: 'border',
              inputFormatter: MaskedInputFormatter(
                '####-####-#####',
                allowedCharMatcher: RegExp(r'[0-9]'),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Masukkan Nomor Handphone Anda';
                } else {
                  if (isNumeric(value.replaceAll('-', '')) &&
                      value.replaceAll('-', '').length < 8) {
                    return 'Nomor Handphone Tidak Valid';
                  } else {
                    return null;
                  }
                }
              },
            ),
            SizedBox(height: 5.0.w),
            InputField(
              controller: emailController,
              onChanged: (value) {},
              hintText: 'Alamat Email',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email Tidak Boleh Kosong';
                } else {
                  if (isEmail(value)) {
                    return null;
                  } else {
                    return 'Email Tidak Valid';
                  }
                }
              },
              keyboardType: TextInputType.emailAddress,
              borderType: 'border',
            ),
            SizedBox(height: 5.0.w),
            InputField(
              controller: birthPlaceController,
              onChanged: (value) {},
              hintText: 'Tempat Lahir',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Tempat Lahir Tidak Boleh Kosong';
                } else {
                  return null;
                }
              },
              borderType: 'border',
            ),
            SizedBox(height: 5.0.w),
            GestureDetector(
              onTap: () async {
                DateTime? result = await showDialog(
                    context: context,
                    builder: (context) {
                      return DateSinglePicker(
                        selectedDate: birthDateController,
                        endDate:
                            DateTime.now().add(const Duration(days: 365 * -17)),
                        startDate:
                            DateTime.now().add(const Duration(days: 365 * -55)),
                      );
                    });

                if (result != null) {
                  setState(() {
                    birthDateController = result;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(vertical: 3.0.w, horizontal: 5.0.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black87)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        birthDateController == null
                            ? 'Tanggal Lahir'
                            : DateFormat('dd/MM/yyyy')
                                .format(birthDateController!),
                        style: FontTheme.regularBaseFont.copyWith(
                            fontSize: 12.sp,
                            color: birthDateController == null
                                ? Colors.black54
                                : Colors.black87),
                      ),
                    ),
                    SizedBox(width: 2.0.w),
                    const Icon(
                      Icons.date_range,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
            ),
            birthDateController == null
                ? Container(
                    margin: EdgeInsets.only(top: 2.0.w),
                    child: Text('Mohon Isi Tanggal Lahir Anda',
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 10.0.sp, color: Colors.red)),
                  )
                : Container(),
            SizedBox(height: 5.0.w),
            GestureDetector(
              onTap: () async {
                City? resultCity = await modalBottomSheet(context,
                    data: [],
                    title: 'Pilih Kota Anda',
                    customWidget: BlocBuilder<UtilCubit, UtilState>(
                        bloc: cityCubit,
                        builder: (context, state) {
                          if (state is UtilLoading) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0.h),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            );
                          } else if (state is CityLoaded) {
                            return Column(
                              children:
                                  List.generate(state.data.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, state.data[index]);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0.w, vertical: 3.0.w),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black12))),
                                    child: Text(
                                      state.data[index].name,
                                      style: FontTheme.regularBaseFont.copyWith(
                                          fontSize: 12.0.sp,
                                          color: Colors.black87),
                                    ),
                                  ),
                                );
                              }),
                            );
                          } else {
                            return FailedRequest(
                              onTap: () {
                                cityCubit.listingCity();
                              },
                            );
                          }
                        }));

                if (resultCity != null) {
                  setState(() {
                    selectedCity = resultCity.name;
                  });
                }
              },
              child: CustomDropdown(
                hintText: 'Pilih Kota Anda',
                value: selectedCity,
              ),
            ),
            selectedCity == null
                ? Container(
                    margin: EdgeInsets.only(top: 2.0.w),
                    child: Text('Mohon Isi Kota Domisili Anda',
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 10.0.sp, color: Colors.red)),
                  )
                : Container(),
            SizedBox(height: 5.0.w),
            GestureDetector(
              onTap: () async {
                List<String> genderList = ['Pria', 'Wanita'];
                int? resultGender = await modalBottomSheet(
                  context,
                  data: genderList,
                  title: 'Pilih Jenis Kelamin Anda',
                );

                if (resultGender != null) {
                  setState(() {
                    gender = genderList[resultGender];
                  });
                }
              },
              child: CustomDropdown(
                hintText: 'Pilih Jenis Kelamin Anda',
                value: gender,
              ),
            ),
            gender == null
                ? Container(
                    margin: EdgeInsets.only(top: 2.0.w),
                    child: Text('Mohon Isi Jenis Kelamin Anda',
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 10.0.sp, color: Colors.red)),
                  )
                : Container(),
          ],
        ),
      );
    }

    Widget _step2Section() {
      return Form(
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
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 10.0.sp, color: Colors.red)),
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
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 10.0.sp, color: Colors.red)),
                  )
                : Container(),
          ],
        ),
      );
    }

    Widget _step3Section() {
      return Form(
          key: step3FormState,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  List<String> dataMotorList = [
                    'Matic',
                    'Gigi',
                    'Kopling',
                  ];
                  int? result = await modalBottomSheet(
                    context,
                    data: dataMotorList,
                    title: 'Pilih Jenis Motor Anda',
                  );

                  if (result != null) {
                    setState(() {
                      motorcycleType = dataMotorList[result];
                    });
                  }
                },
                child: CustomDropdown(
                  hintText: 'Pilih Jenis Motor Anda',
                  value: motorcycleType,
                ),
              ),
              motorcycleType == null
                  ? Container(
                      margin: EdgeInsets.only(top: 2.0.w),
                      child: Text('Mohon Isi Jenis Motor Anda',
                          style: FontTheme.regularBaseFont
                              .copyWith(fontSize: 10.0.sp, color: Colors.red)),
                    )
                  : Container(),
              SizedBox(height: 5.0.w),
              InputField(
                controller: platNumberController,
                onChanged: (value) {},
                hintText: 'Plat Nomor',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mohon Isi Plat Nomor Kendaraan Anda';
                  } else {
                    return null;
                  }
                },
                borderType: 'border',
              ),
              SizedBox(height: 5.0.w),
              InputField(
                controller: vehicleNameController,
                onChanged: (value) {},
                hintText: 'Nama Motor (Vario, Beat, dll)',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mohon Isi Nama Motor Anda';
                  } else {
                    return null;
                  }
                },
                borderType: 'border',
              ),
              SizedBox(height: 5.0.w),
              InputField(
                controller: vehicleYearController,
                onChanged: (value) {},
                hintText: 'Tahun Motor',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mohon Isi Tahun Motor Kendaraan Anda';
                  } else {
                    return null;
                  }
                },
                borderType: 'border',
              ),
              SizedBox(height: 5.0.w),
              Text(
                'Foto Diri Anda',
                style: FontTheme.boldBaseFont
                    .copyWith(fontSize: 10.0.sp, color: Colors.black45),
              ),
              SizedBox(height: 3.0.w),
              imagePickerForm(selfiePhoto, (value) {
                setState(() {
                  selfiePhoto = value;
                });
              }),
              SizedBox(height: 2.0.w),
              Text(
                'Pastikan muka anda jelas terlihat oleh kamera',
                style: FontTheme.regularBaseFont
                    .copyWith(fontSize: 7.0.sp, color: Colors.black45),
              ),
              selfiePhoto == null
                  ? Container(
                      margin: EdgeInsets.only(top: 2.0.w),
                      child: Text('Mohon Upload Foto Diri Anda',
                          style: FontTheme.regularBaseFont
                              .copyWith(fontSize: 10.0.sp, color: Colors.red)),
                    )
                  : Container(),
              SizedBox(height: 5.0.w),
              Text(
                'Foto KTP Anda',
                style: FontTheme.boldBaseFont
                    .copyWith(fontSize: 10.0.sp, color: Colors.black45),
              ),
              SizedBox(height: 3.0.w),
              imagePickerForm(identityPhoto, (value) {
                setState(() {
                  identityPhoto = value;
                });
              }),
              SizedBox(height: 2.0.w),
              Text(
                'Pastikan foto jelas terlihat oleh kamera',
                style: FontTheme.regularBaseFont
                    .copyWith(fontSize: 7.0.sp, color: Colors.black45),
              ),
              selfiePhoto == null
                  ? Container(
                      margin: EdgeInsets.only(top: 2.0.w),
                      child: Text('Mohon Upload Foto KTP Anda',
                          style: FontTheme.regularBaseFont
                              .copyWith(fontSize: 10.0.sp, color: Colors.red)),
                    )
                  : Container(),
              SizedBox(height: 5.0.w),
              Text(
                'Foto SIM Anda',
                style: FontTheme.boldBaseFont
                    .copyWith(fontSize: 10.0.sp, color: Colors.black45),
              ),
              SizedBox(height: 3.0.w),
              imagePickerForm(lisencePhoto, (value) {
                setState(() {
                  lisencePhoto = value;
                });
              }),
              SizedBox(height: 2.0.w),
              Text(
                'Pastikan foto jelas terlihat oleh kamera',
                style: FontTheme.regularBaseFont
                    .copyWith(fontSize: 7.0.sp, color: Colors.black45),
              ),
              lisencePhoto == null
                  ? Container(
                      margin: EdgeInsets.only(top: 2.0.w),
                      child: Text('Mohon Upload Foto SIM Anda',
                          style: FontTheme.regularBaseFont
                              .copyWith(fontSize: 10.0.sp, color: Colors.red)),
                    )
                  : Container(),
              SizedBox(height: 5.0.w),
              Text(
                'Kode Referal',
                style: FontTheme.boldBaseFont
                    .copyWith(fontSize: 10.0.sp, color: Colors.black45),
              ),
              SizedBox(height: 3.0.w),
              InputField(
                controller: referalCodeController,
                onChanged: (value) {},
                hintText: 'Nomor HP Reveral Anda (Opsional)',
                borderType: 'border',
              ),
              SizedBox(height: 5.0.w),
              Row(
                children: [
                  SizedBox(
                      width: 7.0.w,
                      height: 7.0.w,
                      child: Checkbox(
                          value: isAgree,
                          activeColor: ColorPallette.baseBlue,
                          onChanged: (value) {
                            setState(() {
                              isAgree = value!;
                            });
                          })),
                  SizedBox(width: 1.0.w),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Saya menyetujui ',
                        style: FontTheme.regularBaseFont
                            .copyWith(fontSize: 10.0.sp)),
                    TextSpan(
                        text: 'Syarat dan Ketentuan',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch('https://bigexpress.co.id/terms.driver.php');
                          },
                        style: FontTheme.boldBaseFont.copyWith(
                            color: ColorPallette.baseBlue, fontSize: 10.0.sp)),
                  ]))
                ],
              )
            ],
          ));
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
      children: [
        SizedBox(height: 10.0.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (_selectedIndex == 0) {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    _selectedIndex--;
                  });
                }
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5.0.w),
            Text(
              'Lengkapi Data Diri Anda',
              style: FontTheme.boldBaseFont
                  .copyWith(fontSize: 14.0.sp, color: ColorPallette.baseBlue),
            ),
            SizedBox(height: 5.0.w),
            Row(
              children: [
                CircularPercentIndicator(
                  startAngle: 180,
                  radius: 20.0.w,
                  lineWidth: 5.0,
                  percent: _selectedIndex == 0
                      ? 0.33
                      : _selectedIndex == 1
                          ? 0.66
                          : 1,
                  center: Text(
                    "Langkah\n${_selectedIndex + 1} dari 3",
                    textAlign: TextAlign.center,
                    style: FontTheme.regularBaseFont.copyWith(
                        fontSize: 7.0.sp, color: ColorPallette.baseBlack),
                  ),
                  progressColor: ColorPallette.baseBlue,
                ),
                SizedBox(width: 3.0.w),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusStep[_selectedIndex],
                      style: FontTheme.mediumBaseFont.copyWith(
                          fontSize: 11.0.sp, color: ColorPallette.baseBlack),
                    ),
                    SizedBox(height: 2.0.w),
                    Text(
                      statusStep[_selectedIndex + 1],
                      style: FontTheme.mediumBaseFont
                          .copyWith(fontSize: 10.0.sp, color: Colors.black54),
                    ),
                  ],
                ))
              ],
            ),
            SizedBox(height: 5.0.w),
            _selectedIndex == 0
                ? _step1Section()
                : _selectedIndex == 1
                    ? _step2Section()
                    : _step3Section(),
            SizedBox(
              height: 15.0.w,
            ),
            CustomButton(
                onTap: () {
                  if (_selectedIndex == 2) {
                    if (step3FormState.currentState!.validate() &&
                        motorcycleType != null &&
                        selfiePhoto != null &&
                        identityPhoto != null &&
                        lisencePhoto != null &&
                        isAgree) {
                      yesOrNoDialog(context,
                              title: 'Daftar',
                              desc:
                                  'Apakah anda yakin untuk melakukan pendaftaran?')
                          .then((value) {
                        if (value) {
                          EasyLoading.show(status: 'Mohon Tunggu');
                          AuthService.register(
                                  city: selectedCity!,
                                  name: nameController.text,
                                  referal: referalCodeController.text,
                                  motorcycleName: vehicleNameController.text,
                                  motorcycleYear: vehicleYearController.text,
                                  identityNumber: identityController.text,
                                  bornPlace: birthPlaceController.text,
                                  bornDate: DateFormat('yyyy-MM-dd')
                                      .format(birthDateController!),
                                  phoneNumber:
                                      phoneController.text.replaceAll('-', ''),
                                  address: addressController.text,
                                  email: emailController.text,
                                  gender: gender == 'Pria' ? '1' : '0',
                                  bankName: bankName!,
                                  bankNumber: bankNumber.text,
                                  bankOwner: bankOwner.text,
                                  motorcycleType: motorcycleType!,
                                  motorcyclePlatNumber:
                                      platNumberController.text,
                                  selfiePhoto: File(selfiePhoto!.path),
                                  lisencePhoto: File(lisencePhoto!.path),
                                  identityPhoto: File(identityPhoto!.path),
                                  bankPhoto: File(bankBook!.path))
                              .then((value) {
                            EasyLoading.dismiss();
                            if (value.status == RequestStatus.success_request) {
                              Navigator.pop(context);
                              showSnackbar(context,
                                  title: 'Berhasil Melakukan Pendaftaran',
                                  customColor: Colors.green);
                            } else {
                              showSnackbar(context,
                                  title: 'Gagal Melakukan Pendaftaran',
                                  customColor: Colors.orange);
                            }
                          });
                        }
                      });
                    } else {
                      showSnackbar(context,
                          title: 'Mohon Cek isian Anda',
                          customColor: Colors.orange);
                    }
                  } else {
                    if (_selectedIndex == 0) {
                      if (step1FormState.currentState!.validate() &&
                          birthDateController != null &&
                          selectedCity != null &&
                          gender != null) {
                        setState(() {
                          _selectedIndex++;
                        });
                      } else {
                        showSnackbar(context,
                            title: 'Mohon Cek isian Anda',
                            customColor: Colors.orange);
                      }
                    } else if (_selectedIndex == 1) {
                      if (step2FormState.currentState!.validate() &&
                          bankName != null &&
                          bankBook != null) {
                        setState(() {
                          _selectedIndex++;
                        });
                      } else {
                        showSnackbar(context,
                            title: 'Mohon Cek isian Anda',
                            customColor: Colors.orange);
                      }
                    }
                  }
                },
                text: _selectedIndex == 2 ? 'Selesai' : 'Selanjutnya',
                pressAble: true),
            SizedBox(
              height: 15.0.w,
            ),
          ],
        )
      ],
    );
  }
}
