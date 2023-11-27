class User {
  // int? id;
  String? name;
  String? date_of_birth;
  String? phone_number;
  String? profile_photo_path;
  String? registration_status;
  // int? registration_status_id;
  String? access_token;

  User({
    // this.id,
    this.name,
    this.date_of_birth,
    this.phone_number,
    this.profile_photo_path,
    this.registration_status,
    // this.registration_status_id,
    this.access_token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // id: json['id'] as int,
      name: json['name'] as String,
      date_of_birth: json['date_of_birth'] as String,
      phone_number: json['phone_number'] as String,
      profile_photo_path: json['profile_photo_path'] as String,
      registration_status: json['registration_status'] as String,
      // registration_status_id: json['registration_status_id'] as int,
      access_token: json['access_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    data['date_of_birth'] = this.date_of_birth;
    data['phone_number'] = this.phone_number;
    data['profile_photo_path'] = this.profile_photo_path;
    data['registration_status'] = this.registration_status;
    // data['registration_status_id'] = this.registration_status_id;
    data['access_token'] = this.access_token;
    return data;
  }
}
