import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constans/api.dart';
import '../models/loan_model.dart';
import 'auth_service.dart';

class LoanService {
  Future<bool> createLoan(Loan loan) async {
    final token = await AuthService().getToken();

    print("🟣 Token: $token");
    print("📦 Payload dikirim: ${jsonEncode(loan.toJson())}");

    final response = await http.post(
      Uri.parse('$baseUrl/loans'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loan.toJson()),
    );

    print("📥 Status code: ${response.statusCode}");
    print("📥 Response body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  Future<List<Loan>> fetchUserLoans() async {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/loans'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((e) => Loan.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat loans');
    }
  }
}

