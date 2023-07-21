part of 'services.dart';

class UtilService {
  static Future<ApiReturnValue<List<BankOwnerModel>?>> listBankOwner() async {
    ApiReturnValue<List<BankOwnerModel>?> apiReturnValue;

    String url = baseUrl + "dashboard/fetch_owner_bank.php";

    var request = http.MultipartRequest('GET', Uri.parse(url));

    print(request.fields);

    try {
      final streamSend = await request.send();
      final response = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(response.body);
      print('------------------------------------------');

      if (response.statusCode == 200) {
        var dataRaw = json.decode(response.body);

        List<BankOwnerModel> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(BankOwnerModel.fromJson(dataRaw['data'][i]));
        }

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request, data: dataFinal);
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

  static Future<ApiReturnValue<List<TopupModel>?>> listTopup(
      {required String id}) async {
    ApiReturnValue<List<TopupModel>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_topup.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http
          .post(Uri.parse(url), body: {'id_user': id, 'user_type': '1'});

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<TopupModel> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(TopupModel.fromJson(dataRaw['data'][i]));
        }

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request, data: dataFinal);
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

  static Future<ApiReturnValue<List<WithdrawModel>?>> listWithdraw(
      {required String id}) async {
    ApiReturnValue<List<WithdrawModel>?> apiReturnValue;

    const String url = baseUrl + "driver/fetch_withdraw.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {'id': id});

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<WithdrawModel> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(WithdrawModel.fromJson(dataRaw['data'][i]));
        }

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request, data: dataFinal);
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

  static Future<ApiReturnValue<List<City>?>> listCity() async {
    ApiReturnValue<List<City>?> apiReturnValue;

    const String url = baseUrl + "customer/fetch_city.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
        },
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<City> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(City.fromJson(dataRaw['data'][i]));
        }

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request, data: dataFinal);
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

  static Future<ApiReturnValue<BankModel?>> fetchBank(
      {required String id}) async {
    ApiReturnValue<BankModel?> apiReturnValue;

    const String url = baseUrl + "driver/get_bank_info.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
        body: {'id_user': id},
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request,
            data: BankModel.fromJson(dataRaw['data']));
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

  static Future<ApiReturnValue<StatisticModel?>> fetchStatistic(
      {required String id}) async {
    ApiReturnValue<StatisticModel?> apiReturnValue;

    const String url = baseUrl + "driver/get_statictic.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
        body: {'id_user': id},
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request,
            data: StatisticModel.fromJson(dataRaw['data']));
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

  static Future<ApiReturnValue<VehicleModel?>> fetchVehicle(
      {required String id}) async {
    ApiReturnValue<VehicleModel?> apiReturnValue;

    const String url = baseUrl + "driver/get_vehicle.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
        body: {'id_user': id},
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request,
            data: VehicleModel.fromJson(dataRaw['data']));
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

  static Future<ApiReturnValue<TransactionDetail?>> fetchTransaction(
      {required String id}) async {
    ApiReturnValue<TransactionDetail?> apiReturnValue;

    const String url = baseUrl + "driver/transaction_detail.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
        body: {'id': id},
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request,
            data: TransactionDetail.fromJson(dataRaw['data']));
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

  static Future<ApiReturnValue<double?>> getMasterAmount() async {
    ApiReturnValue<double?> apiReturnValue;

    const String url = baseUrl + "dashboard/fetch_config.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request,
            data: double.parse(dataRaw['data']['min_saldo'].toString()));
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

  static Future<ApiReturnValue> updateVehicle(
      {required String id,
      required String type,
      required String plat,
      required String name,
      required String year}) async {
    ApiReturnValue apiReturnValue;

    const String url = baseUrl + "driver/vehicle_update.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(
        Uri.parse(url),
        body: {
          'id': id,
          'type': type,
          'plat': plat,
          'name': name,
          'year': year
        },
      );

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

  static Future<ApiReturnValue<List<TransactionPreview>?>>
      fetchOpenOrder() async {
    ApiReturnValue<List<TransactionPreview>?> apiReturnValue;

    const String url = baseUrl + "driver/fetch_general_order.php";

    print('GET REQUEST TO $url');

    try {
      var request = await http.get(
        Uri.parse(url),
      );

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<TransactionPreview> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(TransactionPreview.fromJson(dataRaw['data'][i]));
        }

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request, data: dataFinal);
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

  static Future<ApiReturnValue<List<TransactionPreview>?>> myOrder(
      {required String userId, required String isActive}) async {
    ApiReturnValue<List<TransactionPreview>?> apiReturnValue;

    const String url = baseUrl + "driver/fetch_active_transaction.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http
          .post(Uri.parse(url), body: {'id_user': userId, 'active': isActive});

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<TransactionPreview> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(TransactionPreview.fromJson(dataRaw['data'][i]));
        }

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request, data: dataFinal);
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

  static Future<ApiReturnValue<List<TransactionPreview>?>> specialOrder({
    required String userId,
  }) async {
    ApiReturnValue<List<TransactionPreview>?> apiReturnValue;

    const String url = baseUrl + "driver/fetch_special_order.php";

    print('POST REQUEST TO $url');

    try {
      var request = await http.post(Uri.parse(url), body: {
        'id_user': userId,
      });

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        var dataRaw = json.decode(request.body);

        List<TransactionPreview> dataFinal = [];
        for (var i = 0; i < dataRaw['data'].length; i++) {
          dataFinal.add(TransactionPreview.fromJson(dataRaw['data'][i]));
        }

        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request, data: dataFinal);
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
