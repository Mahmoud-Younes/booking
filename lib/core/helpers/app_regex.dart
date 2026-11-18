/// Validation regexes shared by the auth forms.
class AppRegex {
  AppRegex._();

  static bool isEmailValid(String email) =>
      RegExp(r'^[\w.+\-]+@[\w\-]+\.[\w.\-]+$').hasMatch(email);

  static bool isPasswordValid(String password) => hasMinLength(password, 6);

  static bool hasMinLength(String text, int minLength) =>
      text.length >= minLength;
}
