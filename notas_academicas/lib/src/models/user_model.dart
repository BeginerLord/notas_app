class SignupRequest {
  final String username;
  final String dni;
  final String email;
  final String password;
  final String phone;
  final List<String> roleListName;

  SignupRequest({
    required this.username,
    required this.dni,
    required this.email,
    required this.password,
    required this.phone,
    required this.roleListName,
  });

  // Método para convertir el modelo a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'dni': dni,
      'email': email,
      'password': password,
      'phone': phone,
      'roleRequest': {
        'roleListName': roleListName,
      },
    };
  }
}