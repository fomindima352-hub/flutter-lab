import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dto/project_dto.dart';

abstract class IProjectRepository {
  Future<List<ProjectDto>> searchProjects(String category);
  Future<List<ProjectDto>> getAllProjects();
}

class ProjectRepository implements IProjectRepository {
  // Для эмулятора Android используем 10.0.2.2
  final String baseUrl = 'http://10.0.2.2:3001/api';
  String? _token;

  // Метод для получения токена
  Future<void> _authenticate() async {
    if (_token != null) return; // Если токен уже есть, не логинимся повторно

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'login': 'admin', 'password': 'admin123'}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['accessToken']; // Предполагаем, что токен лежит здесь
    } else {
      throw Exception('Ошибка авторизации');
    }
  }

  // Вспомогательный метод для GET-запросов с токеном
  Future<http.Response> _get(String url) async {
    await _authenticate();
    return http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $_token'},
    );
  }

  @override
  Future<List<ProjectDto>> searchProjects(String category) async {
    // Если поиск пустой, запрашиваем все проекты
    if (category.trim().isEmpty) {
      return getAllProjects();
    }

    final response = await _get('$baseUrl/project/filter/by-category?category=$category');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ProjectDto.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка сервера при поиске: ${response.statusCode}');
    }
  }

  @override
  Future<List<ProjectDto>> getAllProjects() async {
    // Используем пагинацию (берем первые 20 проектов)
    final response = await _get('$baseUrl/project?page=0&size=20');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final List<dynamic> content = jsonMap['content'] as List<dynamic>;
      return content.map((json) => ProjectDto.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка сервера при загрузке списка: ${response.statusCode}');
    }
  }
}