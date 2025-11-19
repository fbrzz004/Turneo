class UserSession {
  // 1. Creamos la instancia estática (Singleton)
  static final UserSession _instance = UserSession._internal();

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  // 2. Variables para guardar los datos del usuario actual
  int? id;
  String nombre = '';
  String correo = '';
  String rol = ''; // 'Gerente' o el rol del empleado (Mesero, etc.)
  bool esGerente = false;

  // 3. Método para iniciar sesión (Guardar datos)
  void login(int uId, String uNombre, String uCorreo, String uRol, bool uEsGerente) {
    id = uId;
    nombre = uNombre;
    correo = uCorreo;
    rol = uRol;
    esGerente = uEsGerente;
  }

  // 4. Método para cerrar sesión (Borrar datos)
  void logout() {
    id = null;
    nombre = '';
    correo = '';
    rol = '';
    esGerente = false;
  }
}