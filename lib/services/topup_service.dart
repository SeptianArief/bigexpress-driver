part of 'services.dart';

class TopupService {
  static Future<ApiReturnValue> topup(
      {required int amount,
      required String id,
      required String name,
      required String phone}) async {
    ApiReturnValue apiReturnValue;

    String url = baseUrl + 'payment_gateway/topup.php';

    print('POST REQUEST TO $url');

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    DateTime datetime = DateTime.now();

    requestSend.fields['amount'] = amount.toString();
    requestSend.fields['temp_id'] = 'TP' + DateFormat('dMy').format(datetime);
    requestSend.fields['id_user'] = id.toString();
    requestSend.fields['name'] = name.toString();

    requestSend.fields['type'] = '1';

    requestSend.fields['timestamp'] =
        DateFormat('yyyy-MM-dd HH:mm').format(datetime);

    print(requestSend.headers);
    print(requestSend.fields);

    try {
      final streamSend = await requestSend.send();
      final request = await http.Response.fromStream(streamSend);

      print('--------------response--------------');
      print(request.body);
      print('------------------------------------');

      if (request.statusCode == 200 || request.statusCode == 201) {
        var dataRaw = json.decode(request.body);
        apiReturnValue = ApiReturnValue(
            status: RequestStatus.success_request, data: dataRaw['data']);
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
