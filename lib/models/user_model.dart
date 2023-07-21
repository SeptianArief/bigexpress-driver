part of 'models.dart';

class UserModel {
  late int id;
  late String name;
  late String phone;
  late int saldo;
  late String photo;
  late String ktpNumber;
  late String ktpPhoto;
  late String alamat;
  late String email;
  late String birthPlace;
  late String birthDate;
  late String city;
  late int gender;
  late int available;
  late int currentTransaction;
  late int isValidate;
  late String lisencePhoto;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'saldo': saldo,
        'photo': photo,
        'ktp': ktpNumber,
        'ktp_photo': ktpPhoto,
        'alamat': alamat,
        'email': email,
        'birth_place': birthPlace,
        'birth_date': birthDate,
        'city': city,
        'lisence_photo': lisencePhoto,
        'gender': gender,
        'is_available': available,
        'current_transaction': currentTransaction,
        'is_validate': isValidate
      };

  UserModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    name = jsonMap['name'];
    phone = jsonMap['phone'];
    saldo = jsonMap['saldo'];
    photo = jsonMap['photo'];
    ktpNumber = jsonMap['ktp'];
    ktpPhoto = jsonMap['ktp_photo'];
    alamat = jsonMap['alamat'];
    email = jsonMap['email'];
    lisencePhoto = jsonMap['lisence_photo'];
    birthPlace = jsonMap['birth_place'];
    birthDate = jsonMap['birth_date'];
    city = jsonMap['city'];
    gender = jsonMap['gender'];
    available = jsonMap['is_available'];
    currentTransaction = jsonMap['current_transaction'];
    isValidate = jsonMap['is_validate'];
  }
}

class User {
  late int idMember;
  late String? name;
  late String? city;
  late String? phoneNumber;
  late String? email;
  late String otpCode;
  late String otpKeyId;
  late String? saldo;

  User(
      {required this.idMember,
      this.name,
      this.city,
      this.phoneNumber,
      this.email,
      this.saldo,
      required this.otpCode,
      required this.otpKeyId});

  Map<String, dynamic> toJson() => {
        'idmember': idMember.toString(),
        'nama': name,
        'kota': city,
        'hp': phoneNumber,
        'otp_code': otpCode,
        'otp_key': otpKeyId,
        'saldo': saldo
      };

  factory User.fromJson(
          Map<String, dynamic> json, String otpCodeTemp, String otpKey) =>
      User(
          idMember: int.parse(json['idmember']),
          saldo: json['saldo'],
          name: json['nama'],
          // phoneNumber: json['phone'],
          // balance: (json['balance'] as int).toDouble(),
          // gender: json['gender'],
          // address: json['address'],
          city: json['kota'],
          phoneNumber: json['hp'],
          otpCode: otpCodeTemp,
          otpKeyId: otpKey
          // latitude: double.parse(json['lat']),
          // longitude: double.parse(json['lng']),
          // province: json['province'],
          // status: json['status'],
          // avatar: json['avatar'],
          );
}
