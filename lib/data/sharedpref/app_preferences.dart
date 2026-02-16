import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../main.dart';

class AppPreferences {
  //------------------------------------------------------------- Preference Constants ------------------------------------------------------------

  // Constants for Preference-Value's data-type
  static const String PREF_TYPE_BOOL = "BOOL";
  static const String PREF_TYPE_INTEGER = "INTEGER";
  static const String PREF_TYPE_DOUBLE = "DOUBLE";
  static const String PREF_TYPE_STRING = "STRING";

  // Constants for Preference-Name
  static const String PREF_IS_LOGGED_IN = "IS_LOGGED_IN";
  static const String PREF_TOKEN = "APP_TOKEN";
  static const String PREF_API_KEY = "APP_API_KEY";
  static const String PREF_USER_NAME = "APP_USER_NAME";
  static const String PREF_USER_ID = "APP_USER_ID";
  static const String PREF_TP_ENTITY_ID = "TP_ENTITY_ID";
  static const String PREF_USER_ROLE_ID = "APP_USER_ROLE_ID";
  static const String PREF_REGRIP_PARTNER = "APP_IS_REGRIP_PARTNER";
  static const String PREF_STORE_AVAILABLE = "APP_IS_STORE_AVAILABLE";
  static const String PREF_MULTI_ROLE = "APP_IS_MULTI_ROLE";
  static const String PREF_PHONE = "PREF_PHONE";
  static const String PREF_EMAIL = "PREF_EMAIL";
  static const String PREF_LOCALE_NAME = "APP_LOCALE_NAME";
  static const String FREELANCE_ID = "FREELANCE_ID";
  // static const String PREF_BUSINESS_ID = "APP_BUSINESS_ID";
  // static const String PREF_BUSINESS_NAME = "APP_BUSINESS_NAME";
  // static const String PREF_LOCALE_NAME = "APP_LOCALE_NAME";
  // static const String PREF_REVIEW = "PREF_REVIEW";

  //-------------------------------------------------------------------- Variables -------------------------------------------------------------------
  // Future variable to check SharedPreference Instance is ready
  // This is actually a hack. As constructor is not allowed to have 'async' we cant 'await' for future value
  // SharedPreference.getInstance() returns Future<SharedPreference> object and we want to assign its value to our private _preference variable
  // In case if we don't 'await' for SharedPreference.getInstance() method, and in mean time if we access preferences using _preference variable we will get
  // NullPointerException for _preference variable, as it isn't yet initialized.
  // We need to 'await' _isPreferenceReady value for only once when preferences are first time requested in application lifecycle because in further
  // future requests, preference instance is already ready as we are using Singleton-Instance.
  Future? _isPreferenceInstanceReady;

  // Private variable for SharedPreferences
  SharedPreferences? _preferences;

  //-------------------------------------------------------------------- Singleton ----------------------------------------------------------------------
  // Final static instance of class initialized by private constructor
  static final AppPreferences _instance = AppPreferences._internal();
  // Factory Constructor
  factory AppPreferences() => _instance;

  /// AppPreference Private Internal Constructor -> AppPreference
  /// @param->_
  /// @usage-> Initialize SharedPreference object and notify when operation is complete to future variable.
  AppPreferences._internal() {
    _isPreferenceInstanceReady = SharedPreferences.getInstance()
        .then((preferences) => _preferences = preferences);
  }

  //------------------------------------------------------- Getter Methods -----------------------------------------------------------
  // GETTER for isPreferenceReady future
  Future? get isPreferenceReady => _isPreferenceInstanceReady;

  //--------------------------------------------------- Public Preference Methods -------------------------------------------------------------

  void setLoggedIn({required bool isLoggedIn}) => _setPreference(
      prefName: PREF_IS_LOGGED_IN,
      prefValue: isLoggedIn,
      prefType: PREF_TYPE_BOOL);

  Future<void> setPhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('PREF_PHONE', phoneNumber);
  }

  // void setPhoneNumber({required String phoneNumber}) => _setPreference(
  //     prefName: PREF_PHONE, prefValue: phoneNumber, prefType: PREF_TYPE_STRING);

  Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('PREF_EMAIL', email);
  }

  Future<void> setFreelanceId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('FREELANCE_ID', id);
  }
  Future<String?> getFreelanceId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? a = prefs.getString(FREELANCE_ID);
    return a;
  }

  // void setEmail({required String email}) => _setPreference(
  //     prefName: PREF_EMAIL, prefValue: email, prefType: PREF_TYPE_STRING);

  Future<bool> getLoggedIn() async =>
      await _getPreference(prefName: PREF_IS_LOGGED_IN) ?? false;

  Future<String> getPhoneNumber() async =>
      await _getPreference(prefName: PREF_PHONE);

  void setLocale({required String localName}) => _setPreference(
      prefName: PREF_LOCALE_NAME,
      prefValue: localName,
      prefType: PREF_TYPE_STRING);

  Future<String> getLocale() async {
    String localName = "en";
    bool checkValue = _preferences?.containsKey(PREF_LOCALE_NAME) ?? false;
    if (checkValue) {
      localName = await _getPreference(prefName: PREF_LOCALE_NAME);
    }
    return localName;
  }

  // void setReviewDone({required bool review}) => _setPreference(
  // prefName: PREF_REVIEW, prefValue: review, prefType: PREF_TYPE_BOOL);

  // Future<bool?> getReviewDone() async {
  //   bool review= false;
  //   bool checkValue = _preferences?.containsKey(PREF_REVIEW) ?? false;
  //   if (checkValue) {
  //     review = await _getPreference(prefName: PREF_REVIEW);
  //   }
  //   return review;
  // }

  // void setPhoneNumber({required String phone}) => _setPreference(
  //     prefName: PREF_PHONE, prefValue: phone, prefType: PREF_TYPE_STRING);

  // Future<String?> getPhoneNumber() async {
  //   String phone = "";
  //   bool checkValue = _preferences?.containsKey(PREF_PHONE) ?? false;
  //   if (checkValue) {
  //     phone = await _getPreference(prefName: PREF_PHONE);
  //   }
  //   return phone;
  // }

/*
  Future<void> setUserLoginType(UserLoginType loginType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('USER_LOGIN_TYPE', loginType.toString());
  }

  static Future<UserLoginType?> getUserLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTypeString = prefs.getString('USER_LOGIN_TYPE');
    return loginTypeString != null
        ? UserLoginType.values.firstWhere(
            (type) => type.toString() == loginTypeString,
            orElse: () => UserLoginType.demo,
          )
        : null;
  }
*/

  void setAppToken({required String appToken}) => _setPreference(
      prefName: PREF_TOKEN, prefValue: appToken, prefType: PREF_TYPE_STRING);

  Future<String?> getAppToken() async {
    String token = "";
    bool checkValue = _preferences?.containsKey(PREF_TOKEN) ?? false;
    if (checkValue) {
      token = await _getPreference(prefName: PREF_TOKEN);
    }
    return token;
  }

  Future<void> setApiKey(String appApiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('APP_API_KEY', appApiKey);
  }

  // void setApiKey({required String appApiKey}) => _setPreference(
  //     prefName: PREF_API_KEY, prefValue: appApiKey, prefType: PREF_TYPE_STRING);

  Future<void> setUserName(String appUserName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('APP_USER_NAME', appUserName);
  }

  // void setUserName({required String appUserName}) => _setPreference(
  //     prefName: PREF_USER_NAME,
  //     prefValue: appUserName,
  //     prefType: PREF_TYPE_STRING);

  Future<void> setUserId(int appUserId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('APP_USER_ID', appUserId);
  }
  Future<void> setTpEntityId(int tpEntityId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('TP_ENTITY_ID', tpEntityId);
  }
  // Future<int?> getTpEntityId() async {
  //   int? tpEntityId = 0;
  //   bool checkValue = _preferences?.containsKey(PREF_TP_ENTITY_ID) ?? false;
  //   if (checkValue) {
  //     tpEntityId = await _getPreference(prefName: PREF_TP_ENTITY_ID);
  //   }
  //   return tpEntityId;
  // }
  // void setUserId({required int appUserId}) => _setPreference(
  //     prefName: PREF_USER_ID,
  //     prefValue: appUserId,
  //     prefType: PREF_TYPE_INTEGER);

  Future<void> setUserRoleId(int appUserRoleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('APP_USER_ROLE_ID', appUserRoleId);
  }

  // void setUserRoleId({required int appUserRoleId}) => _setPreference(
  //     prefName: PREF_USER_ROLE_ID,
  //     prefValue: appUserRoleId,
  //     prefType: PREF_TYPE_INTEGER);

  Future<void> setIsRegripPartner(int appIsRegripPartner) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('APP_IS_REGRIP_PARTNER', appIsRegripPartner);
  }

  Future<void> setIsStoreAvailable(int appIsStoreAvailable) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('APP_IS_STORE_AVAILABLE', appIsStoreAvailable);
  }


  // void setIsRegripPartner({required int appIsRegripPartner}) => _setPreference(
  //     prefName: PREF_REGRIP_PARTNER,
  //     prefValue: appIsRegripPartner,
  //     prefType: PREF_TYPE_INTEGER);

  Future<void> setIsMultiRole(int appIsMultiRole) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('APP_IS_MULTI_ROLE', appIsMultiRole);
  }

  // void setIsMultiRole({required int appIsMultiRole}) => _setPreference(
  //     prefName: PREF_MULTI_ROLE,
  //     prefValue: appIsMultiRole,
  //     prefType: PREF_TYPE_INTEGER);

  Future<String?> getApiKey() async {
    String api_key = "";
    bool checkValue = _preferences?.containsKey(PREF_API_KEY) ?? false;
    if (checkValue) {
      api_key = await _getPreference(prefName: PREF_API_KEY);
    }
    return api_key;
  }

  Future<String?> getUserName() async {
    String user_name = "";
    bool checkValue = _preferences?.containsKey(PREF_USER_NAME) ?? false;
    if (checkValue) {
      user_name = await _getPreference(prefName: PREF_USER_NAME);
    }
    return user_name;
  }

  Future<int?> getUserId() async {
    int? user_id = 0;
    bool checkValue = _preferences?.containsKey(PREF_USER_ID) ?? false;
    if (checkValue) {
      user_id = await _getPreference(prefName: PREF_USER_ID);
    }
    return user_id;
  }

  Future<int?> getIsRegripPartner() async {
    int is_regrip_partner = 0;
    bool checkValue = _preferences?.containsKey(PREF_REGRIP_PARTNER) ?? false;
    if (checkValue) {
      is_regrip_partner = await _getPreference(prefName: PREF_REGRIP_PARTNER);
    }
    return is_regrip_partner;
  }

  Future<int?> getIsStoreAvailable() async {
    int is_store_available = 0;
    bool checkValue = _preferences?.containsKey(PREF_STORE_AVAILABLE) ?? false;
    if (checkValue) {
      is_store_available = await _getPreference(prefName: PREF_STORE_AVAILABLE);
    }
    return is_store_available;
  }

  // void setBussinessId({required String bussinessId}) => _setPreference(
  //     prefName: PREF_BUSINESS_ID,
  //     prefValue: bussinessId,
  //     prefType: PREF_TYPE_STRING);

  // Future<String?> getBussinessId() async {
  //   String token = "";
  //   bool checkValue = _preferences?.containsKey(PREF_BUSINESS_ID) ?? false;
  //   if (checkValue) {
  //     token = await _getPreference(prefName: PREF_BUSINESS_ID);
  //   }
  //   return token;
  // }

  // void setBussinessName({required String bussinessName}) => _setPreference(
  //     prefName: PREF_BUSINESS_NAME,
  //     prefValue: bussinessName,
  //     prefType: PREF_TYPE_STRING);

  // Future<String> getBussinessName() async {
  //   String bussinessName = "";
  //   bool checkValue = _preferences?.containsKey(PREF_BUSINESS_NAME) ?? false;
  //   if (checkValue) {
  //     bussinessName = await _getPreference(prefName: PREF_BUSINESS_NAME);
  //   }
  //   return bussinessName;
  // }

  // void setLocale({required String localName}) => _setPreference(
  //     prefName: PREF_LOCALE_NAME,
  //     prefValue: localName,
  //     prefType: PREF_TYPE_STRING);

  // Future<String> getLocale() async {
  //   String localName = "id";
  //   bool checkValue = _preferences?.containsKey(PREF_LOCALE_NAME) ?? false;
  //   if (checkValue) {
  //     localName = await _getPreference(prefName: PREF_LOCALE_NAME);
  //   }
  //   return localName;
  // }

  //--------------------------------------------------- Private Preference Methods ----------------------------------------------------
  /// Set Preference Method -> void
  /// @param -> @required prefName -> String
  ///        -> @required prefValue -> dynamic
  ///        -> @required prefType -> String
  /// @usage -> This is a generalized method to set preferences with required Preference-Name(Key) with Preference-Value(Value) and Preference-Value's data-type.
  void _setPreference(
      {required String prefName,
      @required dynamic prefValue,
      required String prefType}) {
    // Make switch for Preference Type i.e. Preference-Value's data-type
    switch (prefType) {
      // prefType is bool
      case PREF_TYPE_BOOL:
        {
          _preferences?.setBool(prefName, prefValue);
          break;
        }
      // prefType is int
      case PREF_TYPE_INTEGER:
        {
          _preferences?.setInt(prefName, prefValue);
          break;
        }
      // prefType is double
      case PREF_TYPE_DOUBLE:
        {
          _preferences?.setDouble(prefName, prefValue);
          break;
        }
      // prefType is String
      case PREF_TYPE_STRING:
        {
          _preferences?.setString(prefName, prefValue);
          break;
        }
    }
  }

  Future<bool> clearPreference() async {
    await _preferences?.clear();
    return true;
  }

  /// Get Preference Method -> Future<dynamic>
  /// @param -> @required prefName -> String
  /// @usage -> Returns Preference-Value for given Preference-Name
  Future<dynamic> _getPreference({@required prefName}) async =>
      _preferences?.get(prefName);
}
