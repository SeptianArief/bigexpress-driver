class DetailPayment {
  late String amount;
  late String orderId;
  late PaymentList data;
  late String norek;

  DetailPayment.fromJson(Map<String, dynamic> jsonMap) {
    amount = jsonMap['amount'];
    orderId = jsonMap['order_id'];
    data = PaymentList.fromJson(jsonMap['info']);
    norek = jsonMap['norek'];
  }
}

class PaymentListMaster {
  late String amount;
  late int trxId;
  List<PaymentList> data = [];

  PaymentListMaster.fromJson(Map<String, dynamic> jsonMap) {
    amount = jsonMap['amount'];
    trxId = jsonMap['trxid'];
    for (var i = 0; i < jsonMap['data'].length; i++) {
      data.add(PaymentList.fromJson(jsonMap['data'][i]));
    }
  }
}

class PaymentList {
  late String code;
  late String norek;
  late String name;
  late String icon;
  late String charge;
  late String howto;
  late String desc;

  PaymentList.fromJson(Map<String, dynamic> jsonMap) {
    code = jsonMap['code'];
    norek = jsonMap['norek'];
    name = jsonMap['nama'];
    icon = jsonMap['icon'];
    charge = jsonMap['charge'];
    howto = jsonMap['howto'];
    desc = jsonMap['description'];
  }
}
