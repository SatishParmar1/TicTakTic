import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ConstantMethods {
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static Future<Map<String, dynamic>> isLogin()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool islogin = prefs.getBool("isLoggedIn")??false;
    int user_id = prefs.getInt("user_type_id")??0;
    bool subscription_active = prefs.getBool("transporter_subscription_active")??false;

    return{
      "islogin": islogin,
      "user_id":user_id,
      "subscription_active":subscription_active
    };
  }
  static Future<String> getcookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cookies = prefs.getString("accesstoken")??'';
    return cookies;
  }

  static String formatString(String input) {
    if (input.isEmpty) return input;

    // 1. Replace underscores with spaces
    String spaced = input.replaceAll('_', ' ');

    // 2. Capitalize the first letter and join with the rest of the string
    return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
  }

  static dynamic formatPrice(dynamic value) {
    if (value == null) return null;

    double? number;

    if (value is int) return value;

    if (value is double) {
      number = value;
    } else if (value is String) {
      number = double.tryParse(value);
    }

    if (number == null) return value;

    // If decimal part is zero → return int
    if (number % 1 == 0) {
      return number.toInt();
    }

    return number;
  }


}

class GreaterThanZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Allow empty (so user can delete)
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final value = double.tryParse(newValue.text);

    // Block invalid numbers or zero / negative
    if (value == null || value <= 0) {
      return oldValue;
    }

    return newValue;
  }
}





String playStoreLink =
    "https://play.google.com/store/apps/details?id=com.bhairavasoft.regrip.facility";

String mechanical_send = "vehicle_mech_defects";
String other_send = "other_vehicle_details";
String review_send = "completed";
