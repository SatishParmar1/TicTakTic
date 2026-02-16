/*
import 'dart:developer';

import 'package:flutter/material.dart';

import '../data/remote/network/ApiEndPoints.dart';
import '../data/remote/network/BaseApiService.dart';
import '../data/remote/network/NetworkApiService.dart';

class AddFitterRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<bool?> addFitter(
      String formData, BuildContext context, bool isMechanic) async {
    try {
      dynamic response = await _apiService.postResponseString(
          isMechanic ? ApiEndPoints().MECHANIC_ADD : ApiEndPoints().FITTER_ADD,
          formData);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'])));

      // log("Log: ${}");
      if (response['error'] == true) {
        // DialogUtils.showErrorPopup(context, response['message']);
        return false;
      }
      return true;
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      // final messageMatch = RegExp('"message":"(.*?)"').firstMatch(e.toString());
      // final message = messageMatch!.group(1);
      // DialogUtils.showErrorPopup(context, message!);
    }
  }
}
*/
