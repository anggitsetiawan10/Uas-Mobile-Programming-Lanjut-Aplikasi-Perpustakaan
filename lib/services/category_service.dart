import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../constans/api.dart';

class CategoryService {
  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$baseUrl/categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil kategori');
    }
  }
}
