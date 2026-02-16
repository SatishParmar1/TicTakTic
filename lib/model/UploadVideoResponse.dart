class UploadVideoResponse {
  bool? success;
  String? message;
  String? videoUrl;
  Data? data;

  UploadVideoResponse({this.success, this.message, this.videoUrl, this.data});

  UploadVideoResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    videoUrl = json['video_url'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['video_url'] = videoUrl;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? videoUrl;
  int? duration;
  int? fileSize;

  Data({this.videoUrl, this.duration, this.fileSize});

  Data.fromJson(Map<String, dynamic> json) {
    videoUrl = json['video_url'];
    duration = json['duration'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video_url'] = videoUrl;
    data['duration'] = duration;
    data['file_size'] = fileSize;
    return data;
  }
}