import 'dart:convert';

import 'package:beacon_app/models/User.dart';
import 'package:beacon_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UserService extends AuthService {
  static Future<User> getUser() async {
    var auth = await AuthService.getSavedAuth();
    http.Response response = await AuthService.makeAuthenticatedRequest(
        'users_validated/me/${auth['id']}',
        method: 'GET');
        if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      User user = User.fromJson(responseMap['data']);
      return user;
    } else {
      print("Debug GET User");
    }
  }
}
