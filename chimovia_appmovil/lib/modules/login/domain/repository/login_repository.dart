abstract class LoginRepository {
  Future<String> login(String email, String password);
}