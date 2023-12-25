class UserRequestModel {
  String? name;
  String? date_of_birth;
  String? phone_number;
  String? password;

  UserRequestModel({
    this.name,
    this.date_of_birth,
    this.phone_number,
    this.password,
  });

  UserRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date_of_birth = json['date_of_birth'];
    phone_number = json['phone_number'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    data['date_of_birth'] = this.date_of_birth;
    data['phone_number'] = this.phone_number;
    data['password'] = this.password;
    return data;
  }
}
