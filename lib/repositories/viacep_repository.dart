import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meuappcep/models/viacep_model.dart';

class ViacepRepository {
  
  Future<ViacepModel> consultarCep(String cep) async {
    var response = await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return ViacepModel.fromJson(json);
    }
    return ViacepModel(); 
  }
}
