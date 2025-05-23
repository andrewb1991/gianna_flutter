import './piatti.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static String get baseUrl => "http://192.168.1.68:3000/piatti";
  Future<List<Piatto>> fetchItems() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Piatto.fromMap(json)).toList();
    } else {
      throw Exception("Errore durante il recupero dei dati");
    }
  }

  Future<List<Piatto>> fetchSmartphones() async {
    final response = await http.get(Uri.parse('$baseUrl/smartphone'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Piatto.fromMap(json)).toList();
    } else {
      throw Exception("Errore durante il recupero degli smartphone");
    }
  }

Future<void> deleteProduct(String id) async {
  final response = await http.delete(Uri.parse('https://localhost:3000/piatti/$id'));

    if (response.statusCode != 200) {
      throw Exception('Errore durante l\'eliminazione del prodotto');
    }
  }
}
