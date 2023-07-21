part of '../pages.dart';

class TopupWebview extends StatefulWidget {
  final String url;
  const TopupWebview({Key? key, required this.url}) : super(key: key);

  @override
  State<TopupWebview> createState() => _TopupWebviewState();
}

class _TopupWebviewState extends State<TopupWebview> {
  final Completer<wv.WebViewController> _controller =
      Completer<wv.WebViewController>();

  List<String> paymentHandleList = [
    'bca-va-number',
    'permata-va-number',
    'mandiri-bill-number',
    'bni-va-number',
    'bri-va-number',
    'all-bank-va-number',
    'payment-code'
  ];

  List<String> emoneyPaymentHandle = ['gojek://gopay'];

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) wv.WebView.platform = wv.AndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: wv.WebView(
        initialUrl: widget.url,
        javascriptMode: wv.JavascriptMode.unrestricted,
        onWebViewCreated: (wv.WebViewController webViewController) {
          setState(() {
            _controller.complete(webViewController);
          });
        },
        javascriptChannels: <wv.JavascriptChannel>[].toSet(),
        onPageFinished: (url) {
          String status = url.split('/')[url.split('/').length - 1];

          if (paymentHandleList.contains(status)) {
            FinanceAPI.virtualAccountDetail(url, status).then((value) {
              if (value.status == RequestStatus.success_request) {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => MainPage()));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            PendingPaymentSummary(data: value.data!)));
              }
            });
          }

          if (url.contains('gojek://gopay') ||
              url.contains('intent://gopay') ||
              url.contains('com.gojek.app')) {
            String finalUrl = url.substring(6);
            finalUrl = 'gojek' + finalUrl;
            launch(finalUrl);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => FinishPaymentPage()));
          }

          //Emoney
          // if (url.contains('https://simulator.sandbox.midtrans.com')) {
          //   Navigator.of(context).popUntil((route) => route.isFirst);
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (_) => MainPage()));
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (_) => SuccessPayment(
          //                 project: widget.project,
          //                 unitBuy: widget.unitBuy,
          //               )));
          // }

          if (status == 'success' || status == 'payment') {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainPage()));
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SuccessPayment()));
          }
        },
      )),
    );
  }
}
