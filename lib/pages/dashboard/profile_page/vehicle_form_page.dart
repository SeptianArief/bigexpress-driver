part of '../../pages.dart';

class VehicleFormPage extends StatefulWidget {
  const VehicleFormPage({Key? key}) : super(key: key);

  @override
  State<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  TextEditingController platNumberController = TextEditingController();
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController vehicleYearController = TextEditingController();
  String? motorcycleType;

  UtilCubit vehicleCubit = UtilCubit();

  @override
  void initState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      vehicleCubit.fetchVehicle(id: userState.user.id.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: _buildContent()));
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
                'Kendaraan',
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
        BlocBuilder<UtilCubit, UtilState>(
            bloc: vehicleCubit,
            builder: (context, state) {
              if (state is UtilLoading) {
                return Expanded(
                    child: Center(child: CircularProgressIndicator()));
              } else if (state is VehicleLoaded) {
                motorcycleType = state.data.type;
                platNumberController.text = state.data.platNumber;
                vehicleNameController.text = state.data.motorcycle;
                vehicleYearController.text = state.data.year;

                return Expanded(
                    child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  children: [
                    SizedBox(height: 5.0.w),
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
                                style: FontTheme.regularBaseFont.copyWith(
                                    fontSize: 10.0.sp, color: Colors.red)),
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
                    SizedBox(height: 10.0.w),
                    CustomButton(
                        onTap: () {
                          yesOrNoDialog(context,
                                  title: 'Simpan Data Kendaraan',
                                  desc:
                                      'Apakah Anda yakin untuk menyimpan data kendaraan?')
                              .then((value) {
                            if (value) {
                              EasyLoading.show(status: 'Mohon Tunggu');
                              UtilService.updateVehicle(
                                      id: state.data.id.toString(),
                                      type: motorcycleType!,
                                      plat: platNumberController.text,
                                      name: vehicleNameController.text,
                                      year: vehicleYearController.text)
                                  .then((valueAPI) {
                                EasyLoading.dismiss();
                                if (valueAPI.status ==
                                    RequestStatus.success_request) {
                                  Navigator.pop(context);
                                  showSnackbar(context,
                                      title: 'Berhasil Menyimpan Data',
                                      customColor: Colors.green);
                                } else {
                                  showSnackbar(context,
                                      title: 'Gagal Menyimpan Data',
                                      customColor: Colors.orange);
                                }
                              });
                            }
                          });
                        },
                        text: 'Simpan',
                        pressAble: true),
                    SizedBox(height: 10.0.w),
                  ],
                ));
              } else {
                return Expanded(child: FailedRequest(
                  onTap: () {
                    UserState userState =
                        BlocProvider.of<UserCubit>(context).state;
                    if (userState is UserLogged) {
                      vehicleCubit.fetchVehicle(
                          id: userState.user.id.toString());
                    }
                  },
                ));
              }
            })
      ],
    );
  }
}
