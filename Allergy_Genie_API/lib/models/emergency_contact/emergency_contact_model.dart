class EmergencyContact {
  // int? id;
  String? name;
  String? phone_number;
  bool? is_first_responder;

  EmergencyContact({
    // this.id,
    this.name,
    this.phone_number,
    this.is_first_responder,
  });

  EmergencyContact.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    name = json['name'];
    phone_number = json['phone_number'];
    is_first_responder = json['is_first_responder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    data['phone_number'] = this.phone_number;
    data['is_first_responder'] = this.is_first_responder;
    return data;
  }
}
