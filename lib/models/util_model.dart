part of 'models.dart';

class BankModel {
  late int id;
  late String accountNumber;
  late String accountName;
  late String bankName;

  BankModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    accountName = jsonMap['account_name'];
    accountNumber = jsonMap['account_number'];
    bankName = jsonMap['bank_name'];
  }
}

class StatisticModel {
  late int id;
  late int totalOrder;
  late int countTotal;
  late int totalKm;

  StatisticModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    totalOrder = jsonMap['total_order'];
    countTotal = jsonMap['total_count'];
    totalKm = jsonMap['total_km'];
  }
}

class VehicleModel {
  late int id;
  late String platNumber;
  late String motorcycle;
  late String type;
  late String year;

  VehicleModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    platNumber = jsonMap['plat_number'];
    motorcycle = jsonMap['motorcycle'];
    type = jsonMap['type'];
    year = jsonMap['year'];
  }
}

class City {
  late int id;
  late String name;

  City.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    name = jsonMap['name'];
  }
}

class TransactionPreview {
  late int id;
  late Map<String, dynamic> addressSender;
  late Map<String, dynamic> addressReceiver1;
  late Map<String, dynamic>? addressReceiver2;
  late Map<String, dynamic>? addressReceiver3;
  late Map<String, dynamic> item;
  late double price;
  late double discount;
  late String createdAt;
  late int transactionStatus;
  late String service;

  TransactionPreview.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    addressSender = json.decode(jsonMap['address_sender']);
    addressReceiver1 = json.decode(jsonMap['address_receiver_1']);
    item = json.decode(jsonMap['item']);
    addressReceiver2 = jsonMap['address_receiver_2'].isEmpty
        ? null
        : json.decode(jsonMap['address_receiver_2']);
    addressReceiver3 = jsonMap['address_receiver_3'].isEmpty
        ? null
        : json.decode(jsonMap['address_receiver_3']);
    transactionStatus = jsonMap['transaction_status'];
    service = jsonMap['service'];
    price = double.parse(jsonMap['price'].toString());
    discount = double.parse(jsonMap['discount'].toString());
    createdAt = jsonMap['created_at'];
  }
}

class TopupModel {
  late int id;
  late double amount;
  late String evidence;
  late String requestedAt;
  late int status;
  late String orderId;
  late String paymentMethod;

  TopupModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    amount = double.parse(jsonMap['amount'].toString());
    evidence = jsonMap['evidence'];
    requestedAt = jsonMap['request'];
    status = jsonMap['status'];
    paymentMethod = jsonMap['payment_method'];
    orderId = jsonMap['order_id'];
  }
}

class BankOwnerModel {
  late int id;
  late String bankName;
  late String accountNumber;
  late String holderName;

  BankOwnerModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    bankName = jsonMap['bank_name'];
    accountNumber = jsonMap['account_number'];
    holderName = jsonMap['holder_name'];
  }
}

class EvidenceModel {
  late int id;
  late String photo;
  late String timestamp;
  late int indexLocation;

  EvidenceModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    photo = jsonMap['photo'];
    timestamp = jsonMap['timestamp'];
    indexLocation = jsonMap['index_location'];
  }
}

class TransactionDetail {
  late int id;
  late Map<String, dynamic> addressSender;
  late Map<String, dynamic> addressReceiver1;
  late Map<String, dynamic>? addressReceiver2;
  late Map<String, dynamic>? addressReceiver3;
  late Map<String, dynamic> item;
  late double price;
  late double discount;
  late String createdAt;
  late int transactionStatus;
  late String service;
  late int? driverSelected;
  late int runningStatus;
  late String customerName;
  late String customerPhone;
  late int isWallet;
  late int billIndex;
  late List<EvidenceModel> dataEvidence = [];

  TransactionDetail.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    addressSender = json.decode(jsonMap['address_sender']);
    addressReceiver1 = json.decode(jsonMap['address_receiver_1']);
    item = json.decode(jsonMap['item']);
    addressReceiver2 = jsonMap['address_receiver_2'].isEmpty
        ? null
        : json.decode(jsonMap['address_receiver_2']);
    addressReceiver3 = jsonMap['address_receiver_3'].isEmpty
        ? null
        : json.decode(jsonMap['address_receiver_3']);
    transactionStatus = jsonMap['transaction_status'];
    service = jsonMap['service'];
    price = double.parse(jsonMap['price'].toString());
    discount = double.parse(jsonMap['discount'].toString());
    createdAt = jsonMap['created_at'];
    driverSelected = jsonMap['driver_selected'];
    runningStatus = jsonMap['running_status'];
    customerName = jsonMap['customer_name'];
    customerPhone = jsonMap['customer_phone'];
    isWallet = jsonMap['is_wallet'];
    billIndex = jsonMap['bill_index'];
    for (var i = 0; i < jsonMap['evidence'].length; i++) {
      dataEvidence.add(EvidenceModel.fromJson(jsonMap['evidence'][i]));
    }
  }
}

class WithdrawModel {
  late int id;
  late int amount;
  late String requestedAt;
  late int status;
  late String confirmedAt;
  late String reason;
  late String bankName;
  late String bankAccount;
  late String bankOwner;

  WithdrawModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    amount = jsonMap['amount'];
    requestedAt = jsonMap['requested_at'];
    status = jsonMap['status'];
    confirmedAt = jsonMap['confirmed_at'];
    reason = jsonMap['reason'];
    bankName = jsonMap['bank_name'];
    bankAccount = jsonMap['bank_account'];
    bankOwner = jsonMap['bank_owner'];
  }
}
