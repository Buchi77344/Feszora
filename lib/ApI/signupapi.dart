import 'dart:convert';
import 'package:feszora/ApI/apiconfig.dart';
import 'package:http/http.dart' as http;

class SignupApi{
  static Future<Map<String, dynamic>> signup({
    required String fullname,
    required String email,
    required String  password,

  }) async{
    final url = Uri.parse("${ApiConfig.baseUrl}/signup/");
    final response = await http.post(
      url,
      headers: {"context-type":"application/json"},
      body:jsonEncode({
        "fullname":fullname,
        "email":email,
        "password":password,
      })

    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return {
       "sucess": true,
       "data": (response.body),
      };
    } else {
      return {
        "suceess":false,
        "error":  (response.body)
      };
    }
  }
}