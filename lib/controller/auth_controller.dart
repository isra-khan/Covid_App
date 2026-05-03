import 'package:covidapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();

  Rxn<User> user = Rxn<User>();
  RxBool isLoading = false.obs;
  RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    user.value = _service.currentUser;
    _service.authStateStream.listen((u) => user.value = u);
  }

  Future<bool> signIn(String email, String password) async {
    isLoading.value = true;
    error.value = null;
    try {
      await _service.signIn(email, password);
      return true;
    } on AuthException catch (e) {
      error.value = e.message;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    isLoading.value = true;
    error.value = null;
    try {
      await _service.signUp(email, password);
      return true;
    } on AuthException catch (e) {
      error.value = e.message;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
  }

  Future<bool> sendPasswordReset(String email) async {
    error.value = null;
    try {
      await _service.sendPasswordReset(email);
      return true;
    } on AuthException catch (e) {
      error.value = e.message;
      return false;
    }
  }
}
