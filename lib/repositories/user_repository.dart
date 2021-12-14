import 'dart:convert';
import 'dart:collection';
import 'package:estoque_frontend/models/user_model.dart';
import 'package:estoque_frontend/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class UserRepository extends ChangeNotifier {
  List<User> _usuarios = [];
  UserRepository() {}
  fetchUser(String? token) async {
    if (token != null) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8080/getUsers'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'token': token}),
      );
      if (response.statusCode == 200) {
        if (response.body == "This user is not Admin") {
          throw "error de autenticacao";
        }
        final json = jsonDecode(response.body);
        _usuarios.clear();
        for (var item in json) {
          _usuarios.add(User(
              name: item[0],
              userType: item[2],
              email: item[3],
              isAdmin: (item[4] == 1 ? true : false)));
        }
        notifyListeners();
      } else {
        throw "erro ao contactar o servidor";
      }
    } else {
      throw "erro ao buscar usuarios";
    }
  }

  // get listUsers => _usuarios;
  UnmodifiableListView<User> get listUsers => UnmodifiableListView(_usuarios);
}
