import 'dart:io';

import 'package:bigexpress_driver/models/models.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;
import 'dart:math' show cos, sqrt, asin;

const String googleAPIKey = "AIzaSyAnCRQ395mqfS6TkNYdO9R8ad7O4ed2sU4";

const baseUrl = 'https://bigexpress.co.id/API/big/API/';

class ColorPallette {
  static const Color baseBlue = Color(0xFF164690);

  static const Color baseYellow = Color(0xFFFFCA00);

  static const Color baseBlack = Color(0xFF000000);

  static const Color baseGrey = Color(0xFF999999);

  static const Color baseWhite = Color(0xFFFFFFFF);

  static const Color secondaryGrey = Color(0xFFF2F2F2);
}

class FontTheme {
  static const TextStyle regularPoppinsFont = TextStyle(
    fontFamily: 'Poppins',
    color: ColorPallette.baseBlack,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle mediumPoppinsFont = TextStyle(
    fontFamily: 'Poppins',
    color: ColorPallette.baseBlack,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle semiBoldPoppinsFont = TextStyle(
    fontFamily: 'Poppins',
    color: ColorPallette.baseBlack,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle boldPoppinsFont = TextStyle(
    fontFamily: 'Poppins',
    color: ColorPallette.baseBlack,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle regularBaseFont = TextStyle(
    fontFamily: 'Poppins',
    color: ColorPallette.baseBlack,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle mediumBaseFont = TextStyle(
    fontFamily: 'Poppins',
    color: ColorPallette.baseBlack,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle semiBoldBaseFont = TextStyle(
    fontFamily: 'Poppins',
    color: ColorPallette.baseBlack,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle boldBaseFont = TextStyle(
    fontFamily: 'Poppins',
    color: ColorPallette.baseBlack,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle extraBoldBaseFont = TextStyle(
    fontFamily: 'Poppins',
    color: ColorPallette.baseBlack,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle boldUbuntuFont = TextStyle(
    fontFamily: 'Ubuntu',
    color: ColorPallette.baseBlack,
    fontWeight: FontWeight.w700,
  );
}

bool isAvailableApp(mapTool.LatLng currLocation) {
  bool returnValue = false;

  List<List<double>> polygonGresik = [
    [112.62982178, -5.84188604],
    [112.62776947, -5.85353518],
    [112.59087372, -5.85321903],
    [112.58023071, -5.84212065],
    [112.58423615, -5.82927418],
    [112.57468414, -5.82696819],
    [112.58924866, -5.77219725],
    [112.61146545, -5.76828051],
    [112.61080933, -5.75488424],
    [112.62610626, -5.74709463],
    [112.63632965, -5.73553705],
    [112.64755249, -5.72903442],
    [112.66983032, -5.73627377],
    [112.67486572, -5.72250175],
    [112.6897049, -5.7243762],
    [112.70463562, -5.73292065],
    [112.72724915, -5.73803043],
    [112.72466278, -5.75800037],
    [112.73619843, -5.7648387],
    [112.73194885, -5.77458096],
    [112.7390976, -5.77920008],
    [112.73834991, -5.7892108],
    [112.72707367, -5.81635904],
    [112.73226929, -5.82921267],
    [112.72158813, -5.83070898],
    [112.71308899, -5.84225702],
    [112.69853973, -5.84941053],
    [112.65727997, -5.85015345],
    [112.62982178, -5.84188604],
    [112.36825562, -7.32472992],
    [112.38808441, -7.31933451],
    [112.40866852, -7.30594254],
    [112.40765381, -7.28769779],
    [112.4119873, -7.27354574],
    [112.3970108, -7.26456833],
    [112.41957855, -7.23179007],
    [112.43375397, -7.22905731],
    [112.43643188, -7.22267628],
    [112.4527359, -7.20820522],
    [112.47301483, -7.20461464],
    [112.4841156, -7.19718027],
    [112.50231171, -7.19228315],
    [112.50460815, -7.17199707],
    [112.49777985, -7.16355133],
    [112.47883606, -7.1644001],
    [112.47015381, -7.15933418],
    [112.47609711, -7.12565517],
    [112.49647522, -7.1273737],
    [112.50144958, -7.10683107],
    [112.51794434, -7.10340261],
    [112.53591156, -7.09571314],
    [112.53095245, -7.08768511],
    [112.54786682, -7.06560183],
    [112.55238342, -7.05038881],
    [112.54059601, -7.05282402],
    [112.52472687, -7.03925371],
    [112.51400757, -7.04118729],
    [112.49839783, -7.03099632],
    [112.50691986, -7.0211072],
    [112.50593567, -7.01204538],
    [112.48716736, -7.00874805],
    [112.48087311, -7.002388],
    [112.46154022, -7.00748587],
    [112.45040894, -7.00143766],
    [112.42879486, -7.00257158],
    [112.42166901, -6.99599743],
    [112.38986969, -6.98584557],
    [112.37021637, -6.9858551],
    [112.36663818, -6.97712612],
    [112.37490082, -6.95817709],
    [112.40387726, -6.95840263],
    [112.42324829, -6.95044994],
    [112.42742157, -6.93410873],
    [112.42326355, -6.92249107],
    [112.42531586, -6.90712929],
    [112.44065857, -6.89871883],
    [112.44564056, -6.88646173],
    [112.44055939, -6.87484169],
    [112.44885254, -6.87883997],
    [112.45391846, -6.88334799],
    [112.47533417, -6.89984512],
    [112.50572205, -6.90719175],
    [112.54291534, -6.90928888],
    [112.54875946, -6.90649652],
    [112.55513763, -6.8874836],
    [112.54766083, -6.87648249],
    [112.53449249, -6.87517452],
    [112.55286407, -6.85270309],
    [112.57322693, -6.89474583],
    [112.59812927, -6.90749216],
    [112.59902191, -6.92284203],
    [112.59365845, -6.93920422],
    [112.59806824, -6.95608759],
    [112.6076889, -6.96098089],
    [112.62213135, -6.9829855],
    [112.64091492, -6.99254465],
    [112.64888763, -7.01723289],
    [112.65426636, -7.05535793],
    [112.63757324, -7.06599617],
    [112.63153076, -7.07675362],
    [112.63407898, -7.09898043],
    [112.62320709, -7.1204257],
    [112.62815094, -7.13532495],
    [112.65791321, -7.15100193],
    [112.66744995, -7.18011379],
    [112.66149139, -7.1930027],
    [112.65917206, -7.19635439],
    [112.63481903, -7.19963551],
    [112.61344147, -7.20904303],
    [112.59268951, -7.20230389],
    [112.5989151, -7.22958851],
    [112.61455536, -7.24820757],
    [112.61721039, -7.25752592],
    [112.63188171, -7.26093245],
    [112.62688446, -7.27648211],
    [112.62941742, -7.31164026],
    [112.64935303, -7.31456327],
    [112.64850616, -7.33530045],
    [112.65383148, -7.33899784],
    [112.65634155, -7.35682011],
    [112.63024139, -7.36778831],
    [112.61824036, -7.36636209],
    [112.5927124, -7.37229729],
    [112.56628418, -7.39793062],
    [112.54248047, -7.40595198],
    [112.52375031, -7.40361261],
    [112.49377441, -7.40917397],
    [112.49208069, -7.39909077],
    [112.48287201, -7.39778614],
    [112.47637939, -7.38183594],
    [112.47719574, -7.35406494],
    [112.48468018, -7.34086895],
    [112.47978973, -7.32925987],
    [112.47738647, -7.30573893],
    [112.46234894, -7.31241512],
    [112.44429016, -7.3050189],
    [112.44034576, -7.31409645],
    [112.40975189, -7.3176136],
    [112.39401245, -7.32754517],
    [112.39147186, -7.3333602],
    [112.36825562, -7.32472992]
  ];

  List<List<double>> polygonSidoarjo = [
    [112.83726370255887, -7.566480528952477],
    [112.8165206183329, -7.558917813305648],
    [112.78470604065228, -7.562778279992809],
    [112.76955353886582, -7.573585864695088],
    [112.7690151992931, -7.573855520115332],
    [112.72283027369917, -7.568798766249252],
    [112.70618431815285, -7.544932674702349],
    [112.68256546822283, -7.548573899265254],
    [112.67089097124232, -7.560773413261598],
    [112.67052521876487, -7.560774814405371],
    [112.6447616503309, -7.536817965975573],
    [112.6445460000989, -7.536759992079174],
    [112.63125599966567, -7.533225992784541],
    [112.60276225407586, -7.501311282788661],
    [112.60260078080239, -7.501148696154594],
    [112.58184318871326, -7.491911370912245],
    [112.57032500109892, -7.478124993273021],
    [112.5117420001942, -7.466801991817649],
    [112.48671435058782, -7.458960897326728],
    [112.46864300017535, -7.445290992684368],
    [112.47066327499124, -7.430545111267063],
    [112.4716200619174, -7.43003020712758],
    [112.49374267018914, -7.409200587436378],
    [112.49399560271594, -7.408981188830003],
    [112.5237503048337, -7.403612613930198],
    [112.54248355627215, -7.40595185039678],
    [112.56628678340941, -7.397930734115282],
    [112.5927123428014, -7.372297142898058],
    [112.63024133417129, -7.367788176882077],
    [112.65634340832264, -7.356820135140314],
    [112.6982989806145, -7.341501739912595],
    [112.6991742161182, -7.340649822930176],
    [112.70460233513074, -7.336239198679279],
    [112.70480957130576, -7.336236408982301],
    [112.72717775744854, -7.348411023449164],
    [112.72745506430078, -7.348456216180637],
    [112.73623648182922, -7.346255136264747],
    [112.73632701837823, -7.34616340361737],
    [112.74286918066925, -7.340994340615512],
    [112.74299520986212, -7.340832573263872],
    [112.7554091537105, -7.336743195840999],
    [112.79752442581265, -7.345279308892199],
    [112.79774086385089, -7.345259718060734],
    [112.82568351928, -7.343300163670781],
    [112.84265609510373, -7.333724724815405],
    [112.83249000131354, -7.420120000137108],
    [112.83758000041769, -7.47057000010461],
    [112.81289000127357, -7.478479999751357],
    [112.83737798300852, -7.511763028240352],
    [112.86450710092298, -7.518292983133859],
    [112.87251706021516, -7.535422994274933],
    [112.86835962929456, -7.569080633563606],
    [112.84682742324799, -7.575654809920771],
    [112.83726370255887, -7.566480528952477]
  ];

  List<List<double>> polygonSurabaya = [
    [112.82568351928, -7.343300163670781],
    [112.79774086385089, -7.345259718060734],
    [112.79752442581265, -7.345279308892199],
    [112.7554091537105, -7.336743195840999],
    [112.74299520986212, -7.340832573263872],
    [112.74286918066925, -7.340994340615512],
    [112.73632701837823, -7.34616340361737],
    [112.73623648182922, -7.346255136264747],
    [112.72745506430078, -7.348456216180637],
    [112.72717775744854, -7.348411023449164],
    [112.70480957130576, -7.336236408982301],
    [112.70460233513074, -7.336239198679279],
    [112.6991742161182, -7.340649822930176],
    [112.6982989806145, -7.341501739912595],
    [112.65634340832264, -7.356820135140314],
    [112.64850907583423, -7.335300282181488],
    [112.64934661895234, -7.314615261784136],
    [112.62941887538182, -7.31164044025332],
    [112.62862254729372, -7.289650845309447],
    [112.62861626283131, -7.289074753096605],
    [112.63185113502288, -7.260907963231092],
    [112.61720553430905, -7.257547210234742],
    [112.59538262960575, -7.219614861236038],
    [112.59811212597492, -7.211987597648721],
    [112.66147996263123, -7.193020197823052],
    [112.66834000019198, -7.220135000329209],
    [112.68608800026209, -7.225521998740422],
    [112.71413999976221, -7.216290000182546],
    [112.71928000027287, -7.204980000226056],
    [112.74332000001903, -7.194339998791131],
    [112.76479818109226, -7.196254563696367],
    [112.78001973372477, -7.208660769777911],
    [112.80654903621009, -7.255701375117563],
    [112.8363269282462, -7.267322187068485],
    [112.84641999978417, -7.307640000384882],
    [112.82687000025135, -7.333260000148066],
    [112.82568351928, -7.343300163670781]
  ];

  print('masuk sini');

  if (mapTool.PolygonUtil.containsLocation(
      currLocation,
      List.generate(polygonSurabaya.length, (index) {
        return mapTool.LatLng(
            polygonSurabaya[index][1], polygonSurabaya[index][0]);
      }),
      false)) {
    returnValue = true;
  }

  if (mapTool.PolygonUtil.containsLocation(
      currLocation,
      List.generate(polygonSidoarjo.length, (index) {
        return mapTool.LatLng(
            polygonSidoarjo[index][1], polygonSidoarjo[index][0]);
      }),
      false)) {
    returnValue = true;
  }

  if (mapTool.PolygonUtil.containsLocation(
      currLocation,
      List.generate(polygonGresik.length, (index) {
        return mapTool.LatLng(polygonGresik[index][1], polygonGresik[index][0]);
      }),
      false)) {
    returnValue = true;
  }

  return returnValue;
}

void showSnackbar(BuildContext context,
    {required String title, Color? customColor}) {
  final snack = SnackBar(
    content: Text(
      title,
      style: FontTheme.regularBaseFont
          .copyWith(fontSize: 12.0.sp, color: Colors.white),
    ),
    backgroundColor: customColor ?? Theme.of(context).primaryColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}

String moneyChanger(double value, {String? customLabel}) {
  return NumberFormat.currency(
          name: customLabel ?? 'Rp', decimalDigits: 0, locale: 'id')
      .format(value.round());
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

Widget imagePickerForm(XFile? data, Function(XFile) onPicked) {
  return GestureDetector(
    onTap: () async {
      final ImagePicker _picker = ImagePicker();
      final XFile? photo =
          await _picker.pickImage(source: ImageSource.camera, maxWidth: 500);

      if (photo != null) {
        onPicked(photo);
      }
    },
    child: data == null
        ? DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(4),
            color: Colors.black45,
            padding: EdgeInsets.symmetric(horizontal: 7.0.w, vertical: 6.0.w),
            child: Column(
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black45,
                  size: 8.0.w,
                ),
                SizedBox(height: 1.0.w),
                Text(
                  'Tambah',
                  style: FontTheme.regularBaseFont
                      .copyWith(fontSize: 8.0.sp, color: Colors.black38),
                )
              ],
            ))
        : Stack(
            children: [
              Container(
                width: 25.0.w,
                height: 25.0.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: FileImage(File(data.path)), fit: BoxFit.cover)),
              ),
              GestureDetector(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? photo = await _picker.pickImage(
                      source: ImageSource.camera, maxWidth: 500);

                  if (photo != null) {
                    onPicked(photo);
                  }
                },
                child: Container(
                  width: 25.0.w,
                  height: 25.0.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black38),
                  alignment: Alignment.center,
                  child: Text(
                    'Ganti',
                    style: FontTheme.regularBaseFont.copyWith(
                      fontSize: 10.0.sp,
                      color: Colors.orange,
                    ),
                  ),
                ),
              )
            ],
          ),
  );
}

String generateIdTransaction(
    {required String createdAt,
    required String idService,
    required String id}) {
  List<String> dateSplit = createdAt.substring(0, 10).split('-');

  return 'BG$idService${dateSplit[2]}${dateSplit[1]}$id';
}

String getDistance(TransactionPreview data) {
  List<List<double>> dataAddress = [
    [data.addressSender['lat'], data.addressSender['lon']],
    [data.addressReceiver1['lat'], data.addressReceiver1['lon']]
  ];

  if (data.addressReceiver2 != null) {
    dataAddress
        .add([data.addressReceiver2!['lat'], data.addressReceiver2!['lon']]);
  }

  if (data.addressReceiver3 != null) {
    dataAddress
        .add([data.addressReceiver3!['lat'], data.addressReceiver3!['lon']]);
  }

  double distanceTotal = 0;
  for (var i = 0; i < dataAddress.length - 1; i++) {
    distanceTotal += calculateDistance(dataAddress[i][0], dataAddress[i][1],
        dataAddress[i + 1][0], dataAddress[i + 1][1]);
  }

  return distanceTotal.toStringAsFixed(2);
}

String dateToReadable(String date) {
  String finalString = '';

  List<String> breakDate = date.split('-');

  switch (breakDate[1]) {
    case '01':
      finalString = finalString + 'Jan';
      break;
    case '02':
      finalString = finalString + 'Feb';
      break;
    case '03':
      finalString = finalString + 'Mar';
      break;
    case '04':
      finalString = finalString + 'Apr';
      break;
    case '05':
      finalString = finalString + 'Mei';
      break;
    case '06':
      finalString = finalString + 'Jun';
      break;
    case '07':
      finalString = finalString + 'Jul';
      break;
    case '08':
      finalString = finalString + 'Aug';
      break;
    case '09':
      finalString = finalString + 'Sep';
      break;
    case '10':
      finalString = finalString + 'Okt';
      break;
    case '11':
      finalString = finalString + 'Nov';
      break;
    case '12':
      finalString = finalString + 'Des';
      break;
    default:
  }

  finalString = breakDate[2] + ' $finalString ' + breakDate[0];

  return finalString;
}
