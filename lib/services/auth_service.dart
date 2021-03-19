import 'dart:async';
import 'dart:convert';
import 'package:beacon_app/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends BaseService {
  static const BASE_URI = "http://foodaurdiscount.com/api/";
  static Map<String, dynamic> _authDetails;
  static const String authNamespace = "auth";
  // ignore: missing_return
  static Future<http.Response> makeAuthenticatedRequest(String url,
      {String method = 'POST',
      body,
      mergeDefaultHeader = true,
      Map<String, String> extraHeaders}) async {
    try {
      Map<String, dynamic> auth = await getSavedAuth();
      extraHeaders ??= {};
      var sentHeaders = mergeDefaultHeader
          ? {
              ...BaseService.headers,
              ...extraHeaders,
              "Authorization": "Bearer ${auth['token']}"
            }
          : extraHeaders;

      switch (method) {
        case 'POST':
          body ??= {};
          return http.post(Uri.parse(url), headers: sentHeaders, body: body);
          break;

        case 'GET':
          return http.get(Uri.parse(url), headers: sentHeaders);
          break;

        case 'PUT':
          return http.put(Uri.parse(url), headers: sentHeaders, body: body);
          break;

        case 'DELETE':
          return http.delete(Uri.parse(url), headers: sentHeaders);
        default:
          return http.post(Uri.parse(url), headers: sentHeaders, body: body);
      }
    } catch (err) {
      print(err);
    }
  }

  static Future<Map<String, dynamic>> getSavedAuth() async {
    if (AuthService._authDetails != null) {
      return _authDetails;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> auth = prefs.getString(authNamespace) != null
        ? json.decode(prefs.getString(authNamespace))
        : null;

    AuthService._authDetails = auth;
    return auth;
  }

  static Future<bool> authenticate(String displayName, String email,
      String password, String photoUrl) async {
    List name = [];
    name = displayName.split(" ");
    String firstName = name[0];
    String lastName = "";
    for (int i = 1; i < name.length; i++) {
      lastName = lastName + name[i];
    }
    var payload = json.encode({
      'name': firstName,
      'lastName': lastName,
      'email': email,
      'password': password
    });
    print('$payload');
    http.Response response = await BaseService.makeUnauthenticatedRequest(
        BaseService.BASE_URI + 'appsignin',
        body: payload);

    Map<String, dynamic> responseMap = json.decode(response.body);

    String token = responseMap['token'];
    String id = responseMap['user']['_id'].toString();
    String role = responseMap['user']['role'].toString();
    String status = responseMap['user']['isBlocked'].toString();

    bool success = token != null;
    if (success)
      _saveToken(token, email, id, role, status, photoUrl, firstName);
    return success;
  }

  static _saveToken(String token, String email, String id, String role,
      String status, String photoUrl, String firstName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        authNamespace,
        json.encode({
          "token": token,
          "email": email,
          "id": id,
          "role": role,
          "status": status,
          "photoUrl": photoUrl,
          "firstName": firstName
        }));
  }

  static clearAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _authDetails = null;
  }
}
