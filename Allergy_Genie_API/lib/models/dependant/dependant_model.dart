class Dependant {
  // int? id;
  String? name;
  String? date_of_birth;
  String? phone_number;
  String? profile_photo_path;
  String? registration_status;
  String? relationship;

  Dependant({
    // this.id,
    this.name,
    this.date_of_birth,
    this.phone_number,
    this.profile_photo_path,
    this.registration_status,
    this.relationship,
  });

  Dependant.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    name = json['name'];
    date_of_birth = json['date_of_birth'];
    phone_number = json['phone_number'];
    profile_photo_path = json['profile_photo_path'];
    registration_status = json['registration_status'];
    relationship = json['relationship'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    data['date_of_birth'] = this.date_of_birth;
    data['phone_number'] = this.phone_number;
    data['profile_photo_path'] = this.profile_photo_path;
    data['registration_status'] = this.registration_status;
    data['relationship'] = this.relationship;
    return data;
  }
}
