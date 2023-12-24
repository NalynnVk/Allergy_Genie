class AllergenRequestModel {
  // int? id;
  String? name;

  AllergenRequestModel({this.name});

  factory AllergenRequestModel.fromJson(Map<String, dynamic> json) {
    return AllergenRequestModel(
      // id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
