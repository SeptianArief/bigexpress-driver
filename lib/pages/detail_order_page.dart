part of 'pages.dart';

class DetailOrderPage extends StatefulWidget {
  final TransactionPreview data;
  const DetailOrderPage({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  int statusDelivery = 0;
  int totalDeliveryAddress = 3;

  UtilCubit transactionDetail = UtilCubit();

  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(-6.2623194, 106.9780988),
    zoom: 15.8,
  );

  BitmapDescriptor _myLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _finishLocationIcon = BitmapDescriptor.defaultMarker;
  final Set<Marker> _markers = {};

  /// INITIAL ROUTE POLYLINES
  Set<Polyline> _polylines = {};

  /// INITIAL POLYLINE COORDINATES
  final List<LatLng> _polylineCoordinates = [];

  /// INJECT POLYLINE LIBRARY
  final PolylinePoints _polylinePoints = PolylinePoints();

  static Future<Uint8List> _getBytesFromAsset(String path) async {
    ByteData data = await rootBundle.load(path);

    return data.buffer.asUint8List();
  }

  final Completer<GoogleMapController> _controller = Completer();

  _getPolylines() async {
    late PolylineResult result;
    result = await _polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(-6.182520, 106.819078),
      PointLatLng(-6.168239903587017, 106.83047829336311),
      travelMode: TravelMode.transit,
    );

    setState(() {
      /// ADD INTO POLYLINES
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          _polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
      }

      Polyline polyline = Polyline(
        polylineId: const PolylineId("poly"),
        color: ColorPallette.baseBlue,
        width: 5,
        points: _polylineCoordinates,
      );

      _polylines.add(polyline);
    });
  }

  @override
  void initState() {
    transactionDetail.detailOrder(id: widget.data.id.toString());
    // INIT USER MARKER IMAGE
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      if (userState.user.isValidate == 1) {
        _getBytesFromAsset("assets/images/Motor Kurir Verified.png")
            .then((onValue) {
          setState(() {
            _myLocationIcon = BitmapDescriptor.fromBytes(onValue);
            _markers.add(
              Marker(
                markerId: MarkerId('2'),
                position: LatLng(-6.182520, 106.819078),
                icon: _myLocationIcon,
                rotation: 0,
              ),
            );
          });
        });
      } else {
        _getBytesFromAsset("assets/images/Motor Kurir.png").then((onValue) {
          setState(() {
            _myLocationIcon = BitmapDescriptor.fromBytes(onValue);
            _markers.add(
              Marker(
                markerId: MarkerId('2'),
                position: LatLng(-6.182520, 106.819078),
                icon: _myLocationIcon,
                rotation: 0,
              ),
            );
          });
        });
      }
    }

    // INIT FINISH MARKER IMAGE
    _getBytesFromAsset("assets/images/Titik Akhir.png").then((onValue) {
      setState(() {
        _finishLocationIcon = BitmapDescriptor.fromBytes(onValue);
        _markers.add(
          Marker(
            markerId: MarkerId('1'),
            position: LatLng(-6.168239903587017, 106.83047829336311),
            icon: _finishLocationIcon,
            rotation: 0,
          ),
        );
      });
    });

    // _getPolylines();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UtilCubit, UtilState>(
      bloc: transactionDetail,
      builder: (context, state) {
        return SafeArea(
            child: Scaffold(
          body: _buildContent(state),
        ));
      },
    );
  }

  Widget _buildBottomNavBar(TransactionDetail data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 3.0.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              //terima orderan
              if (data.transactionStatus == 1) {
                yesOrNoDialog(context,
                        title: 'Ambil Orderan',
                        desc: 'Apakah Anda yakin untuk mengambil orderan ini?')
                    .then((value) {
                  if (value) {
                    EasyLoading.show(status: 'Mohon Tunggu');
                    UserState userState =
                        BlocProvider.of<UserCubit>(context).state;
                    if (userState is UserLogged) {
                      OrderService.bidOrder(
                              id: userState.user.id.toString(),
                              idTransaction: widget.data.id.toString())
                          .then((valueAPI) {
                        EasyLoading.dismiss();
                        if (valueAPI.status == RequestStatus.success_request) {
                          transactionDetail.detailOrder(
                              id: widget.data.id.toString());

                          showSnackbar(context,
                              title: 'Berhasil Menerima Order',
                              customColor: Colors.green);
                        } else {
                          showSnackbar(context,
                              title: valueAPI.data ?? 'Gagal Menerima Order',
                              customColor: Colors.orange);
                        }
                      });
                    }
                  }
                });
              } else {
                ValueNotifier<XFile?> selectedPhoto = ValueNotifier(null);

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text(
                            'Apakah kamu yakin\nsudah tiba di tujuan?',
                            textAlign: TextAlign.center,
                            style: FontTheme.mediumBaseFont.copyWith(
                                fontSize: 13.0.sp,
                                color: ColorPallette.baseBlue),
                          ),
                          content: StatefulBuilder(builder: (context, _) {
                            return ValueListenableBuilder(
                                valueListenable: selectedPhoto,
                                builder: (context, XFile? selectd, _) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      selectd == null
                                          ? const SizedBox()
                                          : Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 3.0.w),
                                              width: 60.0.w,
                                              height: 30.0.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: FileImage(
                                                          File(selectd.path)))),
                                            ),
                                      GestureDetector(
                                        onTap: () async {
                                          final ImagePicker _picker =
                                              ImagePicker();
                                          final XFile? image =
                                              await _picker.pickImage(
                                                  source: ImageSource.camera);

                                          if (image != null) {
                                            selectedPhoto.value = image;
                                          }
                                        },
                                        child: Container(
                                          width: 60.0.w,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0.w),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color:
                                                      ColorPallette.baseBlue)),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Ambil Foto',
                                            style: FontTheme.regularBaseFont
                                                .copyWith(
                                                    fontSize: 11.0.sp,
                                                    color:
                                                        ColorPallette.baseBlue),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 3.0.w),
                                      GestureDetector(
                                        onTap: () {
                                          EasyLoading.show(
                                              status: 'Mohon Tunggu');

                                          bool isDone = false;

                                          if (data.runningStatus == 1 &&
                                              data.addressReceiver2 == null) {
                                            isDone = true;
                                          }

                                          if (data.runningStatus == 2 &&
                                              data.addressReceiver3 == null) {
                                            isDone = true;
                                          }

                                          if (data.runningStatus == 3) {
                                            isDone = true;
                                          }

                                          OrderService.confirmationArrive(
                                                  id: data.id.toString(),
                                                  evidence: File(selectd!.path),
                                                  indexLocation: data
                                                      .runningStatus
                                                      .toString(),
                                                  status: isDone ? '3' : '2',
                                                  runningStatus:
                                                      (data.runningStatus + 1)
                                                          .toString())
                                              .then((value) {
                                            EasyLoading.dismiss();
                                            if (value.status ==
                                                RequestStatus.success_request) {
                                              if (isDone) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            MainPage()),
                                                    (route) => false);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            DonePage(
                                                                data: data)));
                                              } else {
                                                Navigator.pop(context);

                                                transactionDetail.detailOrder(
                                                    id: widget.data.id
                                                        .toString());
                                              }
                                            } else {
                                              showSnackbar(context,
                                                  title: 'Gagal Menfkonfirmasi',
                                                  customColor: Colors.orange);
                                            }
                                          });

                                          // setState(() {
                                          //   statusDelivery = statusDelivery + 1;
                                          // });

                                          // if (statusDelivery >
                                          //     (totalDeliveryAddress + 2)) {
                                          //   Navigator.pushAndRemoveUntil(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (_) => MainPage()),
                                          //       (route) => false);
                                          //   Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (_) =>
                                          //               DonePage()));
                                          // } else {
                                          //   Navigator.pop(context);
                                          // }
                                        },
                                        child: Container(
                                          width: 60.0.w,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0.w),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: selectd == null
                                                ? Colors.grey
                                                : ColorPallette.baseBlue,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Konfirmasi',
                                            style: FontTheme.regularBaseFont
                                                .copyWith(
                                                    fontSize: 11.0.sp,
                                                    color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          }));
                    });
              }

              // if (statusDelivery == 0) {
              //   showDialog(
              //       context: context,
              //       builder: (context) {
              //         return AlertDialog(
              //           title: Text(
              //             'Apakah kamu yakin\nmenerima order ini?',
              //             textAlign: TextAlign.center,
              //             style: FontTheme.mediumBaseFont.copyWith(
              //                 fontSize: 13.0.sp, color: ColorPallette.baseBlue),
              //           ),
              //           content: Text(
              //             'Anda akan langsung mendapatkan pesanan setlehah menekan \"Yakin\"',
              //             textAlign: TextAlign.center,
              //             style: FontTheme.regularBaseFont.copyWith(
              //                 fontSize: 10.0.sp, color: Colors.black54),
              //           ),
              //           actions: [
              //             Container(
              //               padding: EdgeInsets.symmetric(
              //                   vertical: 3.0.w, horizontal: 5.0.w),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 children: [
              //                   GestureDetector(
              //                     onTap: () {
              //                       Navigator.pop(context);
              //                     },
              //                     child: Text(
              //                       'Tidak',
              //                       style: FontTheme.regularBaseFont.copyWith(
              //                           fontSize: 11.0.sp,
              //                           color: Colors.black54),
              //                     ),
              //                   ),
              //                   SizedBox(width: 5.0.w),
              //                   GestureDetector(
              //                     onTap: () {
              //                       setState(() {
              //                         statusDelivery = statusDelivery + 1;
              //                       });
              //                       Navigator.pop(context);
              //                     },
              //                     child: Text(
              //                       'Yakin',
              //                       style: FontTheme.regularBaseFont.copyWith(
              //                           fontSize: 11.0.sp,
              //                           color: ColorPallette.baseBlue),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             )
              //           ],
              //         );
              //       });
              // } else if (statusDelivery == 1) {
              //   showDialog(
              //       context: context,
              //       builder: (context) {
              //         return AlertDialog(
              //           title: Text(
              //             'Apakah kamu yakin\nmemulai pengantaran?',
              //             textAlign: TextAlign.center,
              //             style: FontTheme.mediumBaseFont.copyWith(
              //                 fontSize: 13.0.sp, color: ColorPallette.baseBlue),
              //           ),
              //           content: Text(
              //             'Silahkan tekan tombol \"Yakin\" untuk memulai pengantaran',
              //             textAlign: TextAlign.center,
              //             style: FontTheme.regularBaseFont.copyWith(
              //                 fontSize: 10.0.sp, color: Colors.black54),
              //           ),
              //           actions: [
              //             Container(
              //               padding: EdgeInsets.symmetric(
              //                   vertical: 3.0.w, horizontal: 5.0.w),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 children: [
              //                   GestureDetector(
              //                     onTap: () {
              //                       Navigator.pop(context);
              //                     },
              //                     child: Text(
              //                       'Tidak',
              //                       style: FontTheme.regularBaseFont.copyWith(
              //                           fontSize: 11.0.sp,
              //                           color: Colors.black54),
              //                     ),
              //                   ),
              //                   SizedBox(width: 5.0.w),
              //                   GestureDetector(
              //                     onTap: () {
              //                       setState(() {
              //                         statusDelivery = statusDelivery + 1;
              //                       });
              //                       Navigator.pop(context);
              //                     },
              //                     child: Text(
              //                       'Yakin',
              //                       style: FontTheme.regularBaseFont.copyWith(
              //                           fontSize: 11.0.sp,
              //                           color: ColorPallette.baseBlue),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             )
              //           ],
              //         );
              //       });
              // } else {
              //
              // }
            },
            child: Container(
              width: 90.0.w,
              padding: EdgeInsets.symmetric(vertical: 2.0.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorPallette.baseBlue),
              child: Center(
                child: Text(
                  data.transactionStatus == 1
                      ? 'Terima Order'
                      : 'Tiba di Tujuan',
                  style: FontTheme.regularBaseFont.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.0.sp,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          data.transactionStatus == 2
              ? data.isWallet == 1
                  ? const SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : data.runningStatus == data.billIndex
                      ? Container(
                          margin: EdgeInsets.only(top: 2.0.w),
                          child: Text(
                              'Mohon Untuk Menagih Uang Perjalanan Pada Alamat Ini',
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 8.0.sp,
                                  color: ColorPallette.baseBlue)),
                        )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        )
              : SizedBox(height: 0, width: 0)
        ],
      ),
    );
  }

  Widget _buildContent(UtilState state) {
    EvidenceModel? isAvailableEvidence(List<EvidenceModel> data, int index) {
      EvidenceModel? dataReturn;
      for (var i = 0; i < data.length; i++) {
        if (data[i].indexLocation == index) {
          dataReturn = data[i];
        }
      }

      return dataReturn;
    }

    bool isChatOver(TransactionDetail dataDetail) {
      DateTime currentDateTime = DateTime.now();

      if (dataDetail.addressReceiver2 == null) {
        if (isAvailableEvidence(dataDetail.dataEvidence, 1) != null) {
          DateTime dataDateTime = DateFormat('yyyy-MM-dd HH:mm')
              .parse(isAvailableEvidence(dataDetail.dataEvidence, 1)!.timestamp)
              .add(Duration(minutes: 30));
          if (currentDateTime.isAfter(dataDateTime)) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        if (dataDetail.addressReceiver3 == null) {
          if (isAvailableEvidence(dataDetail.dataEvidence, 2) != null) {
            DateTime dataDateTime = DateFormat('yyyy-MM-dd HH:mm')
                .parse(
                    isAvailableEvidence(dataDetail.dataEvidence, 2)!.timestamp)
                .add(Duration(minutes: 30));
            if (currentDateTime.isAfter(dataDateTime)) {
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        } else {
          if (isAvailableEvidence(dataDetail.dataEvidence, 3) != null) {
            DateTime dataDateTime = DateFormat('yyyy-MM-dd HH:mm')
                .parse(
                    isAvailableEvidence(dataDetail.dataEvidence, 3)!.timestamp)
                .add(Duration(minutes: 30));
            if (currentDateTime.isAfter(dataDateTime)) {
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        }
      }
    }

    Widget _addressListWidget(
        {required String title,
        required Map<String, dynamic> address,
        bool isDone = false,
        EvidenceModel? photoEvidence}) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: FontTheme.regularBaseFont.copyWith(
                fontSize: 8.0.sp,
                color: isDone ? Colors.black54 : ColorPallette.baseBlue)),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address['owner'] ?? 'Nama Tidak Diketahui',
                      style: FontTheme.boldBaseFont.copyWith(
                          fontSize: 8.0.sp,
                          color: isDone
                              ? Colors.black54
                              : ColorPallette.baseBlack)),
                  Text(address['address'],
                      style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 8.0.sp,
                          color: isDone
                              ? Colors.black54
                              : ColorPallette.baseBlack)),
                  SizedBox(height: 1.0.w),
                  Text(address['note'],
                      style: FontTheme.regularBaseFont
                          .copyWith(fontSize: 8.0.sp, color: Colors.black54)),
                ],
              ),
            ),
            !isDone
                ? Row(
                    children: [
                      SizedBox(
                        width: 3.0.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          String phoneNumber =
                              address['phone'].toString().replaceAll('-', '');
                          launch("https://wa.me/62${phoneNumber.substring(1)}");
                        },
                        child: Container(
                          width: 12.0.w,
                          height: 12.0.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green),
                          child: Icon(Icons.chat, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 2.0.w),
                      GestureDetector(
                        onTap: () {
                          String locationFinal = address['lat'].toString() +
                              '%2c' +
                              address['lon'].toString();
                          launch(
                              'https://www.google.com/maps/search/?api=1&query=$locationFinal');
                        },
                        child: Container(
                          width: 12.0.w,
                          height: 12.0.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorPallette.baseBlue),
                          child: Icon(Icons.location_on, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : photoEvidence == null
                    ? Icon(Icons.check, color: Colors.green)
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PhotoPreviewPage(
                                        urlPhoto: baseUrl +
                                            'upload/evidence/' +
                                            photoEvidence.photo,
                                      )));
                        },
                        child: Container(
                            width: 15.0.w,
                            height: 15.0.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black12,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(baseUrl +
                                        'upload/evidence/' +
                                        photoEvidence.photo)))),
                      ),
          ],
        ),
        SizedBox(height: 3.0.w)
      ]);
    }

    Widget _buildMapsSection(TransactionDetail data) {
      return Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            initialCameraPosition: _initialCameraPosition,
            indoorViewEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            trafficEnabled: false,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              //create polyline
              late PolylineResult result;
              late LatLng destinationMarker;

              //get location
              Position myPosition = await Geolocator.getCurrentPosition();

              if (data.runningStatus == 0) {
                destinationMarker = LatLng(
                    data.addressSender['lat'], data.addressSender['lon']);
                result = await _polylinePoints.getRouteBetweenCoordinates(
                    googleAPIKey,
                    PointLatLng(myPosition.latitude, myPosition.longitude),
                    PointLatLng(
                        data.addressSender['lat'], data.addressSender['lon']),
                    travelMode: TravelMode.transit);
              } else if (data.runningStatus == 1) {
                destinationMarker = LatLng(
                    data.addressReceiver1['lat'], data.addressReceiver1['lon']);
                result = await _polylinePoints.getRouteBetweenCoordinates(
                    googleAPIKey,
                    PointLatLng(myPosition.latitude, myPosition.longitude),
                    PointLatLng(data.addressReceiver1['lat'],
                        data.addressReceiver1['lon']),
                    travelMode: TravelMode.transit);
              } else if (data.runningStatus == 2) {
                destinationMarker = LatLng(data.addressReceiver2!['lat'],
                    data.addressReceiver2!['lon']);
                result = await _polylinePoints.getRouteBetweenCoordinates(
                    googleAPIKey,
                    PointLatLng(myPosition.latitude, myPosition.longitude),
                    PointLatLng(data.addressReceiver2!['lat'],
                        data.addressReceiver2!['lon']),
                    travelMode: TravelMode.transit);
              } else if (data.runningStatus == 3) {
                destinationMarker = LatLng(data.addressReceiver3!['lat'],
                    data.addressReceiver3!['lon']);
                result = await _polylinePoints.getRouteBetweenCoordinates(
                    googleAPIKey,
                    PointLatLng(myPosition.latitude, myPosition.longitude),
                    PointLatLng(data.addressReceiver3!['lat'],
                        data.addressReceiver3!['lon']),
                    travelMode: TravelMode.transit);
              }

              setState(() {
                /// ADD INTO POLYLINES
                if (result.points.isNotEmpty) {
                  for (var point in result.points) {
                    _polylineCoordinates.add(
                      LatLng(point.latitude, point.longitude),
                    );
                  }
                }

                Polyline polyline = Polyline(
                  polylineId: const PolylineId("poly"),
                  color: ColorPallette.baseBlue,
                  width: 5,
                  points: _polylineCoordinates,
                );

                _polylines.add(polyline);

                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(myPosition.latitude, myPosition.longitude),
                      zoom: 17.00,
                    ),
                  ),
                );

                _markers.addAll([
                  Marker(
                    markerId: const MarkerId('1'),
                    position: LatLng(
                      myPosition.latitude,
                      myPosition.longitude,
                    ),
                    icon: _myLocationIcon,
                    rotation: 0,
                  ),
                  Marker(
                    markerId: const MarkerId('5'),
                    position: destinationMarker,
                    icon: _finishLocationIcon,
                    rotation: 0,
                  ),
                ]);
              });
            },
          ),
          Positioned(
            bottom: 3.0.w,
            right: 3.0.w,
            child: GestureDetector(
              onTap: () async {
                final GoogleMapController controller = await _controller.future;

                Position myPosition = await Geolocator.getCurrentPosition();
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      // target: LatLng(myPosition.latitude, myPosition.longitude),
                      target: LatLng(
                          data.addressSender['lat'], data.addressSender['lon']),
                      zoom: 17.00,
                    ),
                  ),
                );
              },
              child: Container(
                  width: 12.0.w,
                  height: 12.0.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: ColorPallette.baseBlue),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.my_location_rounded,
                    color: Colors.white,
                  )),
            ),
          )
        ],
      );
    }

    Widget _buildOrderSection(TransactionDetail data) {
      return Column(children: [
        data.transactionStatus == 2
            ? SizedBox(
                height: 40.0.h, width: 100.0.w, child: _buildMapsSection(data))
            : SizedBox(),
        Expanded(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          children: [
            Container(
              padding: EdgeInsets.all(5.0.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.service,
                              style: FontTheme.boldBaseFont.copyWith(
                                  fontSize: 13.0.sp,
                                  color: ColorPallette.baseBlue)),
                          SizedBox(height: 2.0.w),
                          Text(
                            'No. ID',
                            style: FontTheme.regularBaseFont.copyWith(
                                fontSize: 11.0.sp, color: Colors.black87),
                          ),
                          Text(
                            generateIdTransaction(
                                createdAt: data.createdAt,
                                idService:
                                    data.service == 'BIG Express' ? '1' : '2',
                                id: data.id.toString()),
                            style: FontTheme.mediumBaseFont.copyWith(
                                fontSize: 13.0.sp, color: Colors.black87),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: FontTheme.regularBaseFont.copyWith(
                                fontSize: 10.0.sp, color: Colors.black87),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              data.discount > 0
                                  ? Text(
                                      moneyChanger(data.price),
                                      style: FontTheme.regularBaseFont.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 10.0.sp,
                                          color: Colors.black87),
                                    )
                                  : Container(),
                              Text(
                                moneyChanger(data.price - data.discount),
                                style: FontTheme.regularBaseFont.copyWith(
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorPallette.baseBlue),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.0.w),
                          Text('Batas Waktu Antar',
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 9.0.sp, color: Colors.black87)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              data.service == 'BIG Express'
                                  ? '1 Jam'
                                  : 'Hari Ini',
                              style: FontTheme.regularBaseFont.copyWith(
                                  fontSize: 10.0.sp, color: Colors.black54),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),

            ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Pemesan',
                    style: FontTheme.regularBaseFont
                        .copyWith(fontSize: 10.0.sp, color: Colors.black54),
                  )
                ],
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.customerName,
                              style: FontTheme.boldBaseFont.copyWith(
                                  fontSize: 10.0.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    data.customerPhone,
                                    style: FontTheme.regularBaseFont.copyWith(
                                      fontSize: 10.0.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      data.transactionStatus > 3
                          ? Container()
                          : isChatOver(data)
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    launch(
                                        'https://wa.me/62${data.customerPhone.substring(1)}');
                                  },
                                  child: Container(
                                    width: 12.0.w,
                                    height: 12.0.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green),
                                    child:
                                        Icon(Icons.chat, color: Colors.white),
                                  ),
                                ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0.w),
              ],
            ),

            //detail pesanan

            ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Barang',
                    style: FontTheme.regularBaseFont
                        .copyWith(fontSize: 10.0.sp, color: Colors.black54),
                  )
                ],
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.item['name'],
                        style: FontTheme.boldBaseFont.copyWith(
                            fontSize: 10.0.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${data.item['weight']} KG",
                        style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 10.0.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 3.0.w),
                      Text(
                        'Catatan',
                        style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 10.0.sp,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        data.item['note'].isEmpty
                            ? 'Tidak Ada Catatan'
                            : data.item['note'],
                        style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 10.0.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 3.0.w),
                      Text(
                        'Barang Pecah Belah',
                        style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 10.0.sp,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        data.item['isBrokenItem']
                            ? 'Ya Barang Pecah Belah'
                            : 'Bukan Barang Pecah Belah',
                        style: FontTheme.regularBaseFont.copyWith(
                          fontSize: 10.0.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5.0.w)
                    ],
                  ),
                )
              ],
            ),

            ExpansionTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Alamat',
                    style: FontTheme.regularBaseFont
                        .copyWith(fontSize: 10.0.sp, color: Colors.black54),
                  )
                ],
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _addressListWidget(
                            title: 'Alamat 1',
                            address: data.addressSender,
                            photoEvidence:
                                isAvailableEvidence(data.dataEvidence, 0),
                            isDone: data.runningStatus > 0),
                        _addressListWidget(
                            title: 'Alamat 2',
                            address: data.addressReceiver1,
                            photoEvidence:
                                isAvailableEvidence(data.dataEvidence, 1),
                            isDone: data.runningStatus > 1),
                        data.addressReceiver2 == null
                            ? Container()
                            : _addressListWidget(
                                title: 'Alamat 3',
                                address: data.addressReceiver2!,
                                photoEvidence:
                                    isAvailableEvidence(data.dataEvidence, 2),
                                isDone: data.runningStatus > 2),
                        data.addressReceiver3 == null
                            ? Container()
                            : _addressListWidget(
                                title: 'Alamat 4',
                                address: data.addressReceiver3!,
                                photoEvidence:
                                    isAvailableEvidence(data.dataEvidence, 3),
                                isDone: data.runningStatus > 3),
                      ]),
                ),
                SizedBox(height: 5.0.w)
              ],
            ),

            data.transactionStatus == 2
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: Text(
                                  'Batalkan Pesanan',
                                  textAlign: TextAlign.center,
                                  style: FontTheme.mediumBaseFont.copyWith(
                                      fontSize: 13.0.sp,
                                      color: ColorPallette.baseBlue),
                                ),
                                content: StatefulBuilder(
                                  builder: (context, _) {
                                    TextEditingController controller =
                                        TextEditingController();
                                    return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InputField(
                                            controller: controller,
                                            onChanged: (value) {},
                                            maxLines: 3,
                                            borderType: 'solid',
                                            hintText: 'Alasan Pembatalan',
                                          ),
                                          SizedBox(height: 3.0.w),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 60.0.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0.w),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: ColorPallette
                                                          .baseBlue)),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Batal',
                                                style: FontTheme.regularBaseFont
                                                    .copyWith(
                                                        fontSize: 11.0.sp,
                                                        color: ColorPallette
                                                            .baseBlue),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3.0.w),
                                          GestureDetector(
                                            onTap: () {
                                              yesOrNoDialog(context,
                                                      title: 'Batalkan Order?',
                                                      desc:
                                                          'Apakah Anda Yakin untuk membatalkan orderan ini?')
                                                  .then((valueCancel) {
                                                if (valueCancel) {
                                                  EasyLoading.show(
                                                      status: 'Mohon Tunggu');
                                                  OrderService.cancelOrder(
                                                          id: widget.data.id
                                                              .toString(),
                                                          reason:
                                                              controller.text)
                                                      .then((value) {
                                                    EasyLoading.dismiss();
                                                    if (value.status ==
                                                        RequestStatus
                                                            .success_request) {
                                                      showSnackbar(context,
                                                          title:
                                                              'Berhasil Cancel Orderan',
                                                          customColor:
                                                              Colors.green);

                                                      transactionDetail
                                                          .detailOrder(
                                                              id: widget.data.id
                                                                  .toString());
                                                      Navigator.pop(context);
                                                    } else {
                                                      showSnackbar(context,
                                                          title:
                                                              'Gagal Cancel Orderan',
                                                          customColor:
                                                              Colors.orange);
                                                    }
                                                  });
                                                }
                                              });
                                            },
                                            child: Container(
                                              width: 60.0.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0.w),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ColorPallette.baseBlue,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Konfirmasi',
                                                style: FontTheme.regularBaseFont
                                                    .copyWith(
                                                        fontSize: 11.0.sp,
                                                        color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ]);
                                  },
                                ));
                          });
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0.w),
                        padding: EdgeInsets.symmetric(vertical: 2.0.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red),
                            color: Colors.transparent),
                        alignment: Alignment.center,
                        child: Text(
                          'Batalkan Order',
                          style: FontTheme.regularBaseFont
                              .copyWith(fontSize: 10.0.sp, color: Colors.red),
                        )),
                  )
                : Container(),
          ],
        )),
        data.transactionStatus <= 2 ? _buildBottomNavBar(data) : Container()
      ]);
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.0.w, horizontal: 5.0.w),
          color: ColorPallette.baseBlue,
          child: Row(
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              SizedBox(width: 3.0.w),
              Expanded(
                  child: Text('Detail Order',
                      style: FontTheme.boldBaseFont
                          .copyWith(fontSize: 13.0.sp, color: Colors.white))),
              SizedBox(width: 3.0.w),
              GestureDetector(
                onTap: () {
                  transactionDetail.detailOrder(id: widget.data.id.toString());
                },
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: state is UtilLoading
                ? const Center(child: CircularProgressIndicator())
                : state is TransactionDetailLoaded
                    ? _buildOrderSection(state.data)
                    : FailedRequest(
                        onTap: () {
                          transactionDetail.detailOrder(
                              id: widget.data.id.toString());
                        },
                      ))
      ],
    );

    // return Stack(
    //   children: [
    //     SizedBox(
    //       width: 100.0.w,
    //       height: 100.0.h,
    //     ),
    //     Container(
    //       width: 100.0.w,
    //       height: 58.0.h,
    //       child: GoogleMap(
    //         polylines: _polylines,
    //         zoomControlsEnabled: false,
    //         markers: _markers,
    //         initialCameraPosition: CameraPosition(
    //             target: LatLng(-6.174686747126254, 106.8268177318247),
    //             zoom: 14),
    //       ),
    //     ),
    //     Positioned(
    //       top: 5.0.w,
    //       left: 5.0.w,
    //       child: GestureDetector(
    //         onTap: () {
    //           Navigator.pop(context);
    //         },
    //         child: Container(
    //           padding: EdgeInsets.all(2.0.w),
    //           decoration:
    //               BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    //           child: Icon(
    //             Icons.arrow_back,
    //             color: ColorPallette.baseBlue,
    //           ),
    //         ),
    //       ),
    //     ),
    //     Positioned(
    //       top: 5.0.w,
    //       right: 5.0.w,
    //       child: Container(
    //         padding: EdgeInsets.all(2.0.w),
    //         decoration:
    //             BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    //         child: Icon(
    //           Icons.refresh,
    //           color: ColorPallette.baseBlue,
    //         ),
    //       ),
    //     ),
    //     Positioned(
    //       bottom: 0,
    //       child: SizedBox(
    //         width: 100.0.w,
    //         height: 100.0.h,
    //         child: DraggableScrollableSheet(
    //           minChildSize: 0.3,
    //           maxChildSize: 0.5,
    //           initialChildSize: 0.3,
    //           builder: (context, scroll) {
    //             return Container(
    //               color: Colors.white,
    //               child: ListView(
    //                 controller: scroll,
    //                 children: [
    //                   Column(
    //                     children: [
    //                       //package information
    //                       Container(
    //                         padding: EdgeInsets.all(5.0.w),
    //                         child: Column(
    //                           children: [
    //                             Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 Column(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   children: [
    //                                     Text('BIG Sameday',
    //                                         style: FontTheme.boldBaseFont
    //                                             .copyWith(
    //                                                 fontSize: 13.0.sp,
    //                                                 color: ColorPallette
    //                                                     .baseBlue)),
    //                                     SizedBox(height: 2.0.w),
    //                                     Text(
    //                                       'No. ID',
    //                                       style: FontTheme.regularBaseFont
    //                                           .copyWith(
    //                                               fontSize: 11.0.sp,
    //                                               color: Colors.black87),
    //                                     ),
    //                                     Text(
    //                                       'BG743251',
    //                                       style: FontTheme.mediumBaseFont
    //                                           .copyWith(
    //                                               fontSize: 14.0.sp,
    //                                               color: Colors.black87),
    //                                     )
    //                                   ],
    //                                 ),
    //                                 Column(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   children: [
    //                                     Text(
    //                                       'Total',
    //                                       style: FontTheme.regularBaseFont
    //                                           .copyWith(
    //                                               fontSize: 10.0.sp,
    //                                               color: Colors.black87),
    //                                     ),
    //                                     Text(
    //                                       'Rp 10.000',
    //                                       style: FontTheme.regularBaseFont
    //                                           .copyWith(
    //                                               fontSize: 15.0.sp,
    //                                               fontWeight: FontWeight.w600,
    //                                               color:
    //                                                   ColorPallette.baseBlue),
    //                                     ),
    //                                     SizedBox(height: 3.0.w),
    //                                     Text('Batas Waktu Antar',
    //                                         style: FontTheme.regularBaseFont
    //                                             .copyWith(
    //                                                 fontSize: 9.0.sp,
    //                                                 color: Colors.black87)),
    //                                     Align(
    //                                       alignment: Alignment.centerRight,
    //                                       child: Text(
    //                                         '2 Jam',
    //                                         style: FontTheme.regularBaseFont
    //                                             .copyWith(
    //                                                 fontSize: 10.0.sp,
    //                                                 color: Colors.black54),
    //                                       ),
    //                                     )
    //                                   ],
    //                                 )
    //                               ],
    //                             )
    //                           ],
    //                         ),
    //                       ),

    //                       //detail pesanan
    //                       ExpansionTile(
    //                         title: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Text(
    //                               'Detail Pesanan',
    //                               style: FontTheme.regularBaseFont.copyWith(
    //                                   fontSize: 10.0.sp, color: Colors.black54),
    //                             )
    //                           ],
    //                         ),
    //                         children: [
    //                           Container(
    //                             width: double.infinity,
    //                             padding:
    //                                 EdgeInsets.symmetric(horizontal: 5.0.w),
    //                             child: Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 Text(
    //                                   'Nama Item',
    //                                   style: FontTheme.boldBaseFont.copyWith(
    //                                       fontSize: 10.0.sp,
    //                                       color: Colors.black87,
    //                                       fontWeight: FontWeight.bold),
    //                                 ),
    //                                 Text(
    //                                   '8.0 KG',
    //                                   style: FontTheme.regularBaseFont.copyWith(
    //                                     fontSize: 10.0.sp,
    //                                     color: Colors.black87,
    //                                   ),
    //                                 ),
    //                                 SizedBox(height: 3.0.w),
    //                                 Text(
    //                                   'Catatan',
    //                                   style: FontTheme.regularBaseFont.copyWith(
    //                                     fontSize: 10.0.sp,
    //                                     color: Colors.black54,
    //                                   ),
    //                                 ),
    //                                 Text(
    //                                   'Catatan ada disini',
    //                                   style: FontTheme.regularBaseFont.copyWith(
    //                                     fontSize: 10.0.sp,
    //                                     color: Colors.black87,
    //                                   ),
    //                                 ),
    //                                 SizedBox(height: 5.0.w)
    //                               ],
    //                             ),
    //                           )
    //                         ],
    //                       ),

    //                       ExpansionTile(
    //                         title: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Text(
    //                               'Detail Alamat',
    //                               style: FontTheme.regularBaseFont.copyWith(
    //                                   fontSize: 10.0.sp, color: Colors.black54),
    //                             )
    //                           ],
    //                         ),
    //                         children: [
    //                           Container(
    //                             width: double.infinity,
    //                             padding:
    //                                 EdgeInsets.symmetric(horizontal: 5.0.w),
    //                             child: Column(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: List.generate(
    //                                     totalDeliveryAddress, (index) {
    //                                   return Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                       children: [
    //                                         Text('Alamat ${index + 1}',
    //                                             style: FontTheme.regularBaseFont
    //                                                 .copyWith(
    //                                                     fontSize: 8.0.sp,
    //                                                     color: ColorPallette
    //                                                         .baseBlue)),
    //                                         Text(
    //                                             'Jl Pendidikan No 5 RT 11 RW 5, Jawa Barat',
    //                                             style: FontTheme.regularBaseFont
    //                                                 .copyWith(
    //                                                     fontSize: 8.0.sp,
    //                                                     color: ColorPallette
    //                                                         .baseBlack)),
    //                                         Text('Jarak Pengiriman 2.0 KM',
    //                                             style: FontTheme.regularBaseFont
    //                                                 .copyWith(
    //                                                     fontSize: 8.0.sp,
    //                                                     color: Colors.black54)),
    //                                         SizedBox(height: 3.0.w)
    //                                       ]);
    //                                 })),
    //                           ),
    //                           SizedBox(height: 5.0.w)
    //                         ],
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
