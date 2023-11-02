class ImageModel {
  String? imageId;
  String? imageData;

  ImageModel({this.imageId, this.imageData});

  ImageModel.fromJson(Map<String, dynamic> json) {
    imageId = json['imageId'];
    imageData = json['imageData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageId'] = imageId;
    data['imageData'] = imageData;
    return data;
  }
}
