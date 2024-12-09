import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.1.18:5000';  // Replace with your backend URL

// Function for registering a new user (Sign Up)
Future<bool> register(String name, String email, String password) async {
  final url = Uri.parse('$baseUrl/user/register');  // Registration endpoint

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'name': name,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 201) {
    // Successfully registered
    return true;
  } else {
    // Error during registration
    throw false;
  }
}
// Function for logging in an existing user (Sign In)
Future<Map<String, dynamic>> login(String email, String password) async {
  final url = Uri.parse('$baseUrl/user/login');  // Login endpoint

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    // Successfully logged in, return the response data
    return json.decode(response.body);
  } else {
    // Error during login
    throw Exception('Failed to log in: ${response.body}');
  }
}
