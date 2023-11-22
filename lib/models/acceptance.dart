class Acceptance {
  String? acceptanceId;
  bool? status;
  int? rating;
  String? feedback;
  String? constructionContractId;
  String? imageFile;

  Acceptance({
    this.acceptanceId,
    this.status,
    this.rating,
    this.feedback,
    this.constructionContractId,
    this.imageFile,
  });

  Acceptance.fromJson(Map<String, dynamic> json) {
    acceptanceId = json['acceptanceId'];
    status = json['status'];
    rating = json['rating'];
    feedback = json['feedback'];
    constructionContractId = json['constructionContractId'];
    imageFile = json['imageFile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['acceptanceId'] = acceptanceId;
    data['status'] = status;
    data['rating'] = rating;
    data['feedback'] = feedback;
    data['constructionContractId'] = constructionContractId;
    data['imageFile'] = imageFile;
    return data;
  }
}
