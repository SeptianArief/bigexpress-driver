part of 'services.dart';

class AuthService {
  static Future<ApiReturnValue> checkRegion(
      {required String lat, required String lon, required String id}) async {
    late ApiReturnValue returnValue;
    String apiUrl =
        'https://bigexpress.co.id/API/big/API/driver/check_region.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'id': id, 'lat': lat, 'lon': lon},
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'Failed') {
          returnValue = ApiReturnValue(
              data: false, status: RequestStatus.success_request);
        } else {
          returnValue =
              ApiReturnValue(data: true, status: RequestStatus.success_request);
        }
      } else {
        returnValue = ApiReturnValue(
            data: 'Terjadi Kesalahan, Mohon Coba Lagi',
            status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      returnValue = ApiReturnValue(
          data: 'Terjadi Kesalahan', status: RequestStatus.failed_parsing);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> checkOTP({
    required String phone,
    required String otp,
    required String token,
    required String otpKey,
  }) async {
    late ApiReturnValue returnValue;
    String apiURL = baseUrl + 'driver/check_otp.php';

    try {
      final response = await http.post(
        Uri.parse(apiURL),
        body: {
          'phone': phone,
          'otp_key': otp,
          'otp_key_id': otpKey,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        returnValue = ApiReturnValue(
            data: UserModel.fromJson(data['data']),
            status: RequestStatus.success_request);
      } else {
        returnValue = ApiReturnValue(
            data: 'Terjadi Kesalahan, Mohon Coba Lagi',
            status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      returnValue = ApiReturnValue(
          data: 'Terjadi Kesalahan', status: RequestStatus.failed_parsing);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> saveToken({
    required String id,
    required String token,
  }) async {
    late ApiReturnValue returnValue;
    String apiURL = baseUrl + 'driver/save_token.php';

    try {
      final response = await http.post(
        Uri.parse(apiURL),
        body: {
          'id': id,
          'token': token,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        returnValue =
            ApiReturnValue(data: null, status: RequestStatus.success_request);
      } else {
        returnValue = ApiReturnValue(
            data: 'Terjadi Kesalahan, Mohon Coba Lagi',
            status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      returnValue = ApiReturnValue(
          data: 'Terjadi Kesalahan', status: RequestStatus.failed_parsing);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> getProfile({
    required String id,
  }) async {
    late ApiReturnValue returnValue;
    String apiURL = baseUrl + 'driver/fetch_profile.php';

    try {
      final response = await http.post(
        Uri.parse(apiURL),
        body: {
          'id': id,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        returnValue = ApiReturnValue(
            data: UserModel.fromJson(data['data']),
            status: RequestStatus.success_request);
      } else {
        returnValue = ApiReturnValue(
            data: 'Terjadi Kesalahan, Mohon Coba Lagi',
            status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      returnValue = ApiReturnValue(
          data: 'Terjadi Kesalahan', status: RequestStatus.failed_parsing);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> login({
    required String phoneNumber,
  }) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/create_otp.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['phone'] = phoneNumber;

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        final dataRaw = json.decode(request.body);
        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request,
            data: dataRaw['data']['otp_key_id']);
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.server_error);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> updateLocation(
      {required String lat, required String lon, required String id}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/update_location.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['lat'] = lat;
    requestSend.fields['lon'] = lon;
    requestSend.fields['timestamp'] =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    requestSend.fields['id'] = id;

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        apiReturnValue =
            ApiReturnValue(status: RequestStatus.success_request, data: null);
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.server_error);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> otpCheck(
      {required String phoneNumber,
      required String otpKey,
      required String otpKeyId}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'api/v1/otpdriver';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['phone'] = phoneNumber;
    requestSend.fields['otp_code'] = otpKey;
    requestSend.fields['otp_key_id'] = otpKeyId;

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        apiReturnValue =
            ApiReturnValue(status: RequestStatus.success_request, data: null);
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.server_error);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> register({
    required String name,
    required String identityNumber,
    required String bornPlace,
    required String city,
    required String bornDate,
    required String phoneNumber,
    required String address,
    required String email,
    required String gender,
    required String bankName,
    required String bankNumber,
    required String bankOwner,
    required String motorcycleType,
    required String motorcyclePlatNumber,
    required String motorcycleName,
    required String motorcycleYear,
    required String referal,
    required File selfiePhoto,
    required File lisencePhoto,
    required File identityPhoto,
    required File bankPhoto,
  }) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/register.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['name'] = name.toString();
    requestSend.fields['id_number'] = identityNumber.toString();
    requestSend.fields['birth_place'] = bornPlace.toString();
    requestSend.fields['birth_date'] = bornDate.toString();
    requestSend.fields['city'] = city.toString();
    requestSend.fields['phone'] = phoneNumber.toString();
    requestSend.fields['address'] = address.toString();
    requestSend.fields['email'] = email.toString();
    requestSend.fields['gender'] = gender.toString();
    requestSend.fields['bank_name'] = bankName.toString();
    requestSend.fields['account_number'] = bankNumber.toString();
    requestSend.fields['account_name'] = bankOwner.toString();
    requestSend.fields['vehicle_type'] = motorcycleType.toString();
    requestSend.fields['vehicle_plat'] = motorcyclePlatNumber.toString();
    requestSend.fields['vehicle_name'] = motorcycleName.toString();
    requestSend.fields['vehicle_year'] = motorcycleYear.toString();
    requestSend.fields['referal'] = referal.toString();

    requestSend.files
        .add(await http.MultipartFile.fromPath('image', selfiePhoto.path));
    requestSend.files.add(
        await http.MultipartFile.fromPath('image_lisence', lisencePhoto.path));
    requestSend.files
        .add(await http.MultipartFile.fromPath('image_id', identityPhoto.path));
    requestSend.files
        .add(await http.MultipartFile.fromPath('image_bank', bankPhoto.path));

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200 || request.statusCode == 201) {
        apiReturnValue =
            ApiReturnValue(status: RequestStatus.success_request, data: null);
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.server_error);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> updateProfile(
      {required String name,
      required String identityNumber,
      required String bornPlace,
      required String city,
      required String bornDate,
      required String address,
      required String email,
      required String gender,
      required String id}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/update_profile.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['name'] = name.toString();
    requestSend.fields['id_number'] = identityNumber.toString();
    requestSend.fields['birth_place'] = bornPlace.toString();
    requestSend.fields['birth_date'] = bornDate.toString();
    requestSend.fields['city'] = city.toString();
    requestSend.fields['address'] = address.toString();
    requestSend.fields['email'] = email.toString();
    requestSend.fields['gender'] = gender.toString();
    requestSend.fields['id'] = id.toString();

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200 || request.statusCode == 201) {
        apiReturnValue =
            ApiReturnValue(status: RequestStatus.success_request, data: null);
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.server_error);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> changeBankInfo(
      {required String bankName,
      required String bankNumber,
      required String id,
      required String bankOwner,
      required File bankPhoto,
      required String idDriver,
      required String bookName}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/change_bank_info.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['bank_name'] = bankName.toString();
    requestSend.fields['id'] = id.toString();
    requestSend.fields['account_number'] = bankNumber.toString();
    requestSend.fields['account_name'] = bankOwner.toString();
    requestSend.fields['id_driver'] = idDriver.toString();

    requestSend.files
        .add(await http.MultipartFile.fromPath('image_bank', bankPhoto.path));

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200 || request.statusCode == 201) {
        if (json.decode(request.body)['status']) {
          apiReturnValue =
              ApiReturnValue(status: RequestStatus.success_request, data: null);
        } else {
          apiReturnValue =
              ApiReturnValue(data: null, status: RequestStatus.failed_request);
        }
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.server_error);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> updateProfilePicture({
    required String currentFile,
    required String id,
    required File imageProfile,
  }) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/update_profile_picture.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['id'] = id.toString();
    requestSend.fields['name'] = currentFile.toString();

    requestSend.files
        .add(await http.MultipartFile.fromPath('image', imageProfile.path));

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200 || request.statusCode == 201) {
        if (json.decode(request.body)['status']) {
          apiReturnValue =
              ApiReturnValue(status: RequestStatus.success_request, data: null);
        } else {
          apiReturnValue =
              ApiReturnValue(data: null, status: RequestStatus.failed_request);
        }
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.server_error);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> updateProfileSim({
    required String currentFile,
    required String id,
    required File imageProfile,
  }) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/update_profile_sim.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['id'] = id.toString();
    requestSend.fields['name'] = currentFile.toString();

    requestSend.files
        .add(await http.MultipartFile.fromPath('image', imageProfile.path));

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200 || request.statusCode == 201) {
        if (json.decode(request.body)['status']) {
          apiReturnValue =
              ApiReturnValue(status: RequestStatus.success_request, data: null);
        } else {
          apiReturnValue =
              ApiReturnValue(data: null, status: RequestStatus.failed_request);
        }
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.server_error);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> updateProfileKtp({
    required String currentFile,
    required String id,
    required File imageProfile,
  }) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/update_profile_ktp.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['id'] = id.toString();
    requestSend.fields['name'] = currentFile.toString();

    requestSend.files
        .add(await http.MultipartFile.fromPath('image', imageProfile.path));

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200 || request.statusCode == 201) {
        if (json.decode(request.body)['status']) {
          apiReturnValue =
              ApiReturnValue(status: RequestStatus.success_request, data: null);
        } else {
          apiReturnValue =
              ApiReturnValue(data: null, status: RequestStatus.failed_request);
        }
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.server_error);
    }

    return apiReturnValue;
  }

  static Future<ApiReturnValue> withdraw(
      {required String bankName,
      required String accountName,
      required String accountNumber,
      required String amount,
      required String idDriver}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/withdraw.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['bank_name'] = bankName.toString();
    requestSend.fields['bank_account'] = accountNumber.toString();
    requestSend.fields['bank_owner'] = accountName.toString();

    requestSend.fields['id_driver'] = idDriver.toString();
    requestSend.fields['amount'] = amount.toString();
    requestSend.fields['timestamp'] =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200 || request.statusCode == 201) {
        if (json.decode(request.body)['status']) {
          apiReturnValue =
              ApiReturnValue(status: RequestStatus.success_request, data: null);
        } else {
          apiReturnValue =
              ApiReturnValue(data: null, status: RequestStatus.failed_request);
        }
      } else {
        apiReturnValue =
            ApiReturnValue(data: null, status: RequestStatus.failed_request);
      }
    } catch (e) {
      print(e);
      apiReturnValue =
          ApiReturnValue(data: null, status: RequestStatus.server_error);
    }

    return apiReturnValue;
  }
}
