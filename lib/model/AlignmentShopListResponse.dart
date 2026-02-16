/*
class AlignmentShopListResponse {
  AlignmentShopListResponse({
    this.error,
    this.message,
    this.data,
  });

  AlignmentShopListResponse.fromJson(dynamic json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ShopList.fromJson(v));
      });
    }
  }
  bool? error;
  String? message;
  List<ShopList>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ShopList {
  ShopList({
    this.id,
    this.shopName,
    this.addedByUserId,
    this.isActive,
    this.datetimeCreated,
  });

  ShopList.fromJson(dynamic json) {
    id = json['id'];
    shopName = json['shop_name'];
    addedByUserId = json['added_by_user_id'];
    isActive = json['is_active'];
    datetimeCreated = json['datetime_created'];
  }
  int? id;
  String? shopName;
  int? addedByUserId;
  int? isActive;
  String? datetimeCreated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['shop_name'] = shopName;
    map['added_by_user_id'] = addedByUserId;
    map['is_active'] = isActive;
    map['datetime_created'] = datetimeCreated;
    return map;
  }
}
*/
