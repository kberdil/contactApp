class UploadImageResponse {
  String? imageUrl;

  UploadImageResponse({this.imageUrl});
  factory UploadImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageResponse(
      imageUrl: json['imageUrl'],
    );
  }
}
