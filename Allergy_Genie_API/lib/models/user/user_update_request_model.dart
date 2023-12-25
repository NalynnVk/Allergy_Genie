class UpdateUserRequestModel {
  String? name;
  String? date_of_birth;
  // String? phone_number;

  UpdateUserRequestModel({
    this.name,
    this.date_of_birth,
    // this.phone_number,
  });

  UpdateUserRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date_of_birth = json['date_of_birth'];
    // phone_number = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    data['date_of_birth'] = this.date_of_birth;
    // data['phone_number'] = this.phone_number;
    return data;
  }
}
