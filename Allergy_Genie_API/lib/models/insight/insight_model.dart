class Insight {
  // int? id;
  String? photo_path;
  String? title;
  String? description;

  Insight({
    // this.id,
    this.photo_path,
    this.title,
    this.description,
  });

  Insight.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    photo_path = json['photo_path'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['photo_path'] = this.photo_path;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
