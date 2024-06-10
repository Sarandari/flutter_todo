import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService{
  // Хэрэглэгчийн даалгаварыг серверээс ID-тайгаар устгах
  static Future<bool> deleteById(String id) async {
     final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final responce = await http.delete(uri);
    return responce.statusCode == 200;
  }

  // Хэрэглэгчийн даалгаваруудыг серверээс татах
  static Future<List?> fetchTodos() async {
     final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final responce = await http.get(uri);
    if (responce.statusCode == 200) {
      final json = jsonDecode(responce.body) as Map;
      final result = json['items'] as List;
      return result;
    } else{
      return null;
    }
  }

  // Хэрэглэгчийн даалгаврыг серверээс засах
  static Future<bool> updateTodo(String id, Map body) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }

  // Шинэ хэрэглэгчийн даалгаварыг серверээс нэмэх
  static Future<bool> addTodo(Map body) async {
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 201;
  }
}