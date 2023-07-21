part of 'services.dart';

class OrderService {
  static Future<ApiReturnValue> onOffBid(
      {required String id, required bool status}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/change_available_status.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['status'] = status ? '1' : '0';
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
        if (json.decode(request.body)['status']) {
          apiReturnValue =
              ApiReturnValue(status: RequestStatus.success_request, data: null);
        } else {
          apiReturnValue = ApiReturnValue(
              status: RequestStatus.failed_request,
              data: json.decode(request.body)['msg']);
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

  static Future<ApiReturnValue> cancelOrder(
      {required String id, required String reason}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/cancel_transaction.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['reason'] = reason;
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
        if (json.decode(request.body)['status']) {
          apiReturnValue =
              ApiReturnValue(status: RequestStatus.success_request, data: null);
        } else {
          apiReturnValue = ApiReturnValue(
              status: RequestStatus.failed_request,
              data: json.decode(request.body)['msg']);
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

  static Future<ApiReturnValue> confirmationArrive(
      {required String id,
      required File evidence,
      required String indexLocation,
      required String status,
      required String runningStatus}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/arrive_at_location.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['status'] = status;
    requestSend.fields['timestamp'] =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    requestSend.fields['id'] = id;
    requestSend.fields['index_location'] = indexLocation;
    requestSend.fields['running_status'] = runningStatus;

    requestSend.files
        .add(await http.MultipartFile.fromPath('image', evidence.path));

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

  static Future<ApiReturnValue> bidOrder(
      {required String id, required String idTransaction}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'driver/bid_order.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    requestSend.fields['id_user'] = id;
    requestSend.fields['id_transaction'] = idTransaction;

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200) {
        if (json.decode(request.body)['status']) {
          apiReturnValue =
              ApiReturnValue(status: RequestStatus.success_request, data: null);
        } else {
          apiReturnValue = ApiReturnValue(
              status: RequestStatus.failed_request,
              data: json.decode(request.body)['msg']);
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
