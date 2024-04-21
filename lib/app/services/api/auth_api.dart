import 'package:http/http.dart' as http;
import 'package:nasari_test/app/services/api/config.dart';
import 'dart:convert';
import 'package:nasari_test/app/services/api/responses/login_response.dart';

class AuthApi {
  static Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(Uri.parse(Apis.login),
        body: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed login');
    }
  }
}
