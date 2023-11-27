class LoginRequestModel{
  String? phone_number;
  String? password;

  LoginRequestModel({this.phone_number, this.password});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      phone_number: json['phone_number'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_number'] = this.phone_number;
    data['password'] = this.password;
    return data;
  }
}
