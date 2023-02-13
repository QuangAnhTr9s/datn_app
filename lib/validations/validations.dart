class Validations{
  static bool isValidEmail(String? email){
    return email != null && email.length > 10 && email.substring(email.length-10).contains("@gmail.com");
  }
  static bool isValidPassword(String? password){
    return password != null && password.length > 7;
  }
  static bool isValidSecondPassword(String? secondPassword, String? password){
    return password == secondPassword;
  }
}