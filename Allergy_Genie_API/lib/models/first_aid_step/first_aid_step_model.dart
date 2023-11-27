class FirstAidStep {
  // int? id;
  String? step;

  FirstAidStep({
    // this.id,
    this.step,
  });

  FirstAidStep.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    step = json['step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['step'] = this.step;
    return data;
  }
}
