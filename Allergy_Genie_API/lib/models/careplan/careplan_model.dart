class Careplan {

  String? pdfUrl;

  Careplan({
    this.pdfUrl,
  });

  Careplan.fromJson(Map<String, dynamic> json) {
  
    pdfUrl = json['pdf_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   
    data['pdf_url'] = this.pdfUrl;
    return data;
  }
}