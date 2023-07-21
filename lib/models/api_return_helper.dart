part of 'models.dart';

class ApiReturnValue<T> {
  T data;
  RequestStatus status;

  ApiReturnValue({required this.data, required this.status});

  static Future<ApiReturnValue<dynamic>?> httpRequest(BuildContext context,
      {required http.MultipartRequest request,
      List<int>? exceptionStatusCode,
      bool? auth}) async {
    ApiReturnValue<dynamic>? returnValue;
    bool authHeader = auth ?? true;

    if (authHeader) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final jsonMap = json.decode(prefs.getString('login')!);

      // request.headers['Authorization'] =
      //     'Bearer ${User.fromJson(jsonMap).token}';
    }

    print(request.method + " Request to:");
    print(request.url);
    print('Header : ${request.headers}');
    print('Body : ${request.fields} ');
    print('----------------------------------------------------');

    try {
      final streamSend = await request.send();
      final response = await http.Response.fromStream(streamSend);
      var data = json.decode(response.body);
      print(data);

      if (response.statusCode != 200) {
        if (exceptionStatusCode != null) {
          if (exceptionStatusCode.contains(response.statusCode)) {
            returnValue = ApiReturnValue(
                status: RequestStatus.success_request, data: data);
          } else {
            returnValue = ApiReturnValue(
                data: data, status: RequestStatus.failed_request);
          }
        } else {
          returnValue =
              ApiReturnValue(data: data, status: RequestStatus.failed_request);
        }
      } else {
        returnValue =
            ApiReturnValue(status: RequestStatus.success_request, data: data);
      }
    } on SocketException {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.internet_issue);
    } catch (e) {
      print(e);
      returnValue =
          ApiReturnValue(status: RequestStatus.server_error, data: null);
    }

    return returnValue;
  }
}

enum RequestStatus {
  success_request,
  failed_request,
  failed_parsing,
  server_error,
  internet_issue
}
