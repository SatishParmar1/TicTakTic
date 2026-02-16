/*
class AllocateTyreResponse {
  List<AllocateTyres>? allocateTyres;
  int? totalTyres;

  AllocateTyreResponse({this.allocateTyres, this.totalTyres});

  AllocateTyreResponse.fromJson(Map<String, dynamic> json) {
    totalTyres = json['total_tyres'];
    if (json['data'] != null) {
      allocateTyres = <AllocateTyres>[];
      json['data'].forEach((v) {
        allocateTyres!.add(new AllocateTyres.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allocateTyres != null) {
      data['data'] = this.allocateTyres!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllocateTyres {
  int? id;
  bool? checkBox;
  String? serialNo;
  int? tpEntityId;
  String? imageUrl;
  int? tyreKm;
  String? snImageUrl;
  int? vehicleId;
  String? vehicleNo;
  int? brandId;
  dynamic stdNsd;
  dynamic nsd1;
  dynamic nsd2;
  dynamic nsd3;
  dynamic avgNsd;
  String? brandName;
  String? modelName;
  int? modelId;
  String? tyreSize;
  bool? isTyrePurchaseLoading;
  String? tyreCondition;
  String? constructionType;
  String? productCategory;
  String? currentStatus;
  String? ongoingStatus;
  String? logoImageUrl;
  String? position;
  String? statusColorCode;
  String? statusTextColorCode;
  String? defectDescription;
  List<Defects>? defects;

  AllocateTyres(
      {this.id,
      this.checkBox,
      this.serialNo,
      this.tpEntityId,
        this.avgNsd,
        this.nsd1,
        this.nsd2,
        this.nsd3,
      this.imageUrl,
      this.snImageUrl,
      this.vehicleId,
        this.tyreKm,
      this.brandId,
        this.stdNsd,
        this.vehicleNo,
      this.brandName,
        this.modelName,
      this.modelId,
      this.defectDescription,
      this.tyreSize,
      this.tyreCondition,
      this.constructionType,
      this.position,
      this.productCategory,
      this.currentStatus,
      this.ongoingStatus,
      this.logoImageUrl,
      this.statusColorCode,
      this.statusTextColorCode});

  AllocateTyres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    modelName = json['model_name'];
    serialNo = json['serial_no'];
    constructionType = json['construction_type'];
    tpEntityId = json['tp_entity_id'];
    imageUrl = json['image_url'];
    tyreKm = json['tyre_km'];
    snImageUrl = json['sn_image_url'];
    position = json['position'];
    vehicleNo = json['vehicle_no'];
    vehicleId = json['vehicle_id'];
    modelId = json['model_id'];
    tyreSize = json['tyre_size'];
    tyreCondition = json['tyre_condition'];
    productCategory = json['product_category'];
    defectDescription = json['defect_description'];
    currentStatus = json['current_status'];
    ongoingStatus = json['ongoing_status'];
    stdNsd = json['std_nsd'];
    avgNsd = json['avg_nsd'];
    nsd1 = json['nsd1'];
    nsd2 = json['nsd2'];
    nsd3 = json['nsd3'];
    logoImageUrl = json['logo_image_url'];
    statusColorCode = json['status_color_code'];
    statusTextColorCode = json['status_text_color_code'];
    if (json['tyre_defect_details'] != null) {
      defects = <Defects>[];
      json['tyre_defect_details'].forEach((v) {
        defects!.add(new Defects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand_id'] = this.brandId;
    data['brand_name'] = this.brandName;
    data['model_name'] = this.modelName;
    data['model_id'] = this.modelId;
    data['tyre_km'] = this.tyreKm;
    data['construction_type'] = this.constructionType;
    data['serial_no'] = this.serialNo;
    data['tp_entity_id'] = this.tpEntityId;
    data['defect_description'] = this.defectDescription;
    data['image_url'] = this.imageUrl;
    data['sn_image_url'] = this.snImageUrl;
    data['vehicle_id'] = this.vehicleId;
    data['tyre_size'] = this.tyreSize;
    data['tyre_condition'] = this.tyreCondition;
    data['product_category'] = this.productCategory;
    data['current_status'] = this.currentStatus;
    data['ongoing_status'] = this.ongoingStatus;
    data['logo_image_url'] = this.logoImageUrl;
    data['status_color_code'] = this.statusColorCode;
    data['status_text_color_code'] = this.statusTextColorCode;
    if (this.defects != null) {
      data['tyre_defect_details'] =
          this.defects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Defects {
  int? defectId;
  String? imageUrl;
  String? videoUrl;
  String? defectType;
  String? defectTypeName;
  String? constructionType;

  Defects(
      {this.defectId,
      this.imageUrl,
      this.videoUrl,
      this.defectType,
      this.defectTypeName,
      this.constructionType});

  Defects.fromJson(Map<String, dynamic> json) {
    defectId = json['defect_id'];
    imageUrl = json['image_url'];
    videoUrl = json['video_url'];
    defectType = json['defect_type'];
    constructionType = json['construction_type'];
    defectTypeName = json['defect_type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['defect_id'] = this.defectId;
    data['image_url'] = this.imageUrl;
    data['video_url'] = this.videoUrl;
    data['defect_type'] = this.defectType;
    data['construction_type'] = this.constructionType;
    data['defect_type_name'] = this.defectTypeName;
    return data;
  }
}
*/
