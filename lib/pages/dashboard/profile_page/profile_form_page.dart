part of '../../pages.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({Key? key}) : super(key: key);

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ktpNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthPlaceController = TextEditingController();
  XFile? identityPhoto;
  XFile? lisencePhoto;
  DateTime? birthDateController;
  String? selectedCity;
  String? gender;
  String? existingPhoto;
  String? existingKTP;
  String? existingSIM;
  UtilCubit cityCubit = UtilCubit();
  bool isValidate = true;

  GlobalKey<FormState> step1FormState = GlobalKey<FormState>();

  @override
  void initState() {
    cityCubit.listingCity();
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      isValidate = userState.user.isValidate == 1;
      // isValidate = false;
      nameController.text = userState.user.name;
      phoneNumberController.text = userState.user.phone;
      ktpNumberController.text = userState.user.ktpNumber;
      addressController.text = userState.user.alamat;
      emailController.text = userState.user.email;
      birthPlaceController.text = userState.user.birthPlace;
      birthDateController =
          DateFormat('yyyy-MM-dd').parse(userState.user.birthDate);
      selectedCity = userState.user.city;
      gender = userState.user.gender == 1 ? 'Pria' : 'Wanita';
      existingPhoto = userState.user.photo;
      existingKTP = userState.user.ktpPhoto;
      existingSIM = userState.user.lisencePhoto;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: _buildContent()),
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
                'Profil',
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
        isValidate
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.0.w),
                color: Colors.green,
                alignment: Alignment.center,
                child: Text('Tervalidasi',
                    style: FontTheme.regularBaseFont
                        .copyWith(fontSize: 12.0.sp, color: Colors.white)))
            : Container(),
        Expanded(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          children: [
            SizedBox(height: 5.0.w),
            Center(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 25.0.w,
                      height: 25.0.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black12,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(baseUrl +
                                  'upload/profile_picture/' +
                                  existingPhoto!))),
                    ),
                  ),
                  isValidate
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? photo = await _picker.pickImage(
                                source: ImageSource.camera, maxWidth: 500);

                            if (photo != null) {
                              UserState userState =
                                  BlocProvider.of<UserCubit>(context).state;
                              if (userState is UserLogged) {
                                EasyLoading.show(status: 'Mohon Tunggu');
                                AuthService.updateProfilePicture(
                                        currentFile: existingPhoto!,
                                        id: userState.user.id.toString(),
                                        imageProfile: File(photo.path))
                                    .then((value) {
                                  EasyLoading.dismiss();
                                  if (value.status ==
                                      RequestStatus.success_request) {
                                    BlocProvider.of<UserCubit>(context)
                                        .refreshProfile(
                                            id: userState.user.id.toString());
                                    showSnackbar(context,
                                        title:
                                            'Berhasil Update Profile Picture',
                                        customColor: Colors.green);
                                    Navigator.pop(context);
                                  } else {
                                    showSnackbar(context,
                                        title: 'Gagal Update Profile Picture',
                                        customColor: Colors.orange);
                                  }
                                });
                              }
                            }
                          },
                          child: Center(
                            child: Container(
                              width: 25.0.w,
                              height: 25.0.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black38),
                              alignment: Alignment.center,
                              child:
                                  Icon(Icons.camera_alt, color: Colors.white),
                            ),
                          ),
                        )
                ],
              ),
            ),
            SizedBox(height: 10.0.w),
            Form(
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
                    enabled: !isValidate,
                    borderType: 'border',
                  ),
                  SizedBox(height: 5.0.w),
                  InputField(
                    controller: ktpNumberController,
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
                    enabled: !isValidate,
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
                    enabled: !isValidate,
                    borderType: 'border',
                  ),
                  SizedBox(height: 5.0.w),
                  InputField(
                    controller: phoneNumberController,
                    onChanged: (value) {},
                    hintText: 'Nomor Handphone',
                    enabled: false,
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
                    enabled: !isValidate,
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
                    enabled: !isValidate,
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
                      if (!isValidate) {
                        DateTime? result = await showDialog(
                            context: context,
                            builder: (context) {
                              return DateSinglePicker(
                                selectedDate: birthDateController,
                                endDate: DateTime.now()
                                    .add(const Duration(days: 365 * -17)),
                                startDate: DateTime.now()
                                    .add(const Duration(days: 365 * -55)),
                              );
                            });

                        if (result != null) {
                          setState(() {
                            birthDateController = result;
                          });
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 3.0.w, horizontal: 5.0.w),
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
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 10.0.sp, color: Colors.red)),
                        )
                      : Container(),
                  SizedBox(height: 5.0.w),
                  GestureDetector(
                    onTap: () async {
                      if (!isValidate) {
                        City? resultCity = await modalBottomSheet(context,
                            data: [],
                            title: 'Pilih Kota Anda',
                            customWidget: BlocBuilder<UtilCubit, UtilState>(
                                bloc: cityCubit,
                                builder: (context, state) {
                                  if (state is UtilLoading) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10.0.h),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(),
                                    );
                                  } else if (state is CityLoaded) {
                                    return Column(
                                      children: List.generate(state.data.length,
                                          (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pop(
                                                context, state.data[index]);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.0.w,
                                                vertical: 3.0.w),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color:
                                                            Colors.black12))),
                                            child: Text(
                                              state.data[index].name,
                                              style: FontTheme.regularBaseFont
                                                  .copyWith(
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
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 10.0.sp, color: Colors.red)),
                        )
                      : Container(),
                  SizedBox(height: 5.0.w),
                  GestureDetector(
                    onTap: () async {
                      if (!isValidate) {
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
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 10.0.sp, color: Colors.red)),
                        )
                      : Container(),
                ],
              ),
            ),
            SizedBox(height: 5.0.w),
            Text(
              'Foto KTP Anda',
              style: FontTheme.boldBaseFont
                  .copyWith(fontSize: 10.0.sp, color: Colors.black45),
            ),
            SizedBox(height: 3.0.w),
            Stack(
              children: [
                Container(
                  width: 25.0.w,
                  height: 25.0.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              baseUrl + 'upload/ktp/$existingKTP'))),
                ),
                isValidate
                    ? Container()
                    : GestureDetector(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? photo = await _picker.pickImage(
                              source: ImageSource.camera, maxWidth: 500);

                          if (photo != null) {
                            UserState userState =
                                BlocProvider.of<UserCubit>(context).state;
                            if (userState is UserLogged) {
                              EasyLoading.show(status: 'Mohon Tunggu');
                              AuthService.updateProfileKtp(
                                      currentFile: existingKTP!,
                                      id: userState.user.id.toString(),
                                      imageProfile: File(photo.path))
                                  .then((value) {
                                EasyLoading.dismiss();
                                if (value.status ==
                                    RequestStatus.success_request) {
                                  BlocProvider.of<UserCubit>(context)
                                      .refreshProfile(
                                          id: userState.user.id.toString());
                                  showSnackbar(context,
                                      title: 'Berhasil Update KTP',
                                      customColor: Colors.green);
                                  Navigator.pop(context);
                                } else {
                                  showSnackbar(context,
                                      title: 'Gagal Update KTP',
                                      customColor: Colors.orange);
                                }
                              });
                            }
                          }
                        },
                        child: Container(
                            width: 25.0.w,
                            height: 25.0.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black54),
                            alignment: Alignment.center,
                            child: Icon(Icons.camera_alt, color: Colors.white)))
              ],
            ),
            SizedBox(height: 2.0.w),
            Text(
              'Pastikan foto jelas terlihat oleh kamera',
              style: FontTheme.regularBaseFont
                  .copyWith(fontSize: 7.0.sp, color: Colors.black45),
            ),
            SizedBox(height: 5.0.w),
            Text(
              'Foto SIM Anda',
              style: FontTheme.boldBaseFont
                  .copyWith(fontSize: 10.0.sp, color: Colors.black45),
            ),
            SizedBox(height: 3.0.w),
            Stack(
              children: [
                Container(
                  width: 25.0.w,
                  height: 25.0.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              baseUrl + 'upload/sim/$existingSIM'))),
                ),
                isValidate
                    ? Container()
                    : GestureDetector(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? photo = await _picker.pickImage(
                              source: ImageSource.camera, maxWidth: 500);

                          if (photo != null) {
                            UserState userState =
                                BlocProvider.of<UserCubit>(context).state;
                            if (userState is UserLogged) {
                              EasyLoading.show(status: 'Mohon Tunggu');
                              AuthService.updateProfileSim(
                                      currentFile: existingSIM!,
                                      id: userState.user.id.toString(),
                                      imageProfile: File(photo.path))
                                  .then((value) {
                                EasyLoading.dismiss();
                                if (value.status ==
                                    RequestStatus.success_request) {
                                  BlocProvider.of<UserCubit>(context)
                                      .refreshProfile(
                                          id: userState.user.id.toString());
                                  showSnackbar(context,
                                      title: 'Berhasil Update SIM',
                                      customColor: Colors.green);
                                  Navigator.pop(context);
                                } else {
                                  showSnackbar(context,
                                      title: 'Gagal Update SIM',
                                      customColor: Colors.orange);
                                }
                              });
                            }
                          }
                        },
                        child: Container(
                            width: 25.0.w,
                            height: 25.0.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black54),
                            alignment: Alignment.center,
                            child: Icon(Icons.camera_alt, color: Colors.white)))
              ],
            ),
            SizedBox(height: 2.0.w),
            Text(
              'Pastikan foto jelas terlihat oleh kamera',
              style: FontTheme.regularBaseFont
                  .copyWith(fontSize: 7.0.sp, color: Colors.black45),
            ),
            SizedBox(height: isValidate ? 0 : 10.0.w),
            isValidate
                ? Container()
                : CustomButton(
                    onTap: () {
                      UserState userState =
                          BlocProvider.of<UserCubit>(context).state;
                      if (userState is UserLogged) {
                        yesOrNoDialog(context,
                                title: 'Simpan Profil',
                                desc:
                                    'Apakah Anda yakin untuk menyimpan profil?')
                            .then((valueConfirm) {
                          if (valueConfirm) {
                            EasyLoading.show(status: 'Mohon Tunggu');
                            AuthService.updateProfile(
                                    name: nameController.text,
                                    identityNumber: ktpNumberController.text,
                                    bornPlace: birthPlaceController.text,
                                    city: selectedCity!,
                                    bornDate: DateFormat('yyyy-MM-dd')
                                        .format(birthDateController!),
                                    address: addressController.text,
                                    email: emailController.text,
                                    gender: gender == 'Pria' ? '1' : '0',
                                    id: userState.user.id.toString())
                                .then((value) {
                              EasyLoading.dismiss();
                              if (value.status ==
                                  RequestStatus.success_request) {
                                BlocProvider.of<UserCubit>(context)
                                    .refreshProfile(
                                        id: userState.user.id.toString());
                                Navigator.pop(context);
                                showSnackbar(context,
                                    title: 'Berhasil Melakukan Update Profil',
                                    customColor: Colors.green);
                              } else {
                                showSnackbar(context,
                                    title: 'Gagal Melakukan Update Profil',
                                    customColor: Colors.orange);
                              }
                            });
                          }
                        });
                      }
                    },
                    text: 'Simpan',
                    pressAble: true),
            SizedBox(height: 10.0.w),
          ],
        ))
      ],
    );
  }
}
