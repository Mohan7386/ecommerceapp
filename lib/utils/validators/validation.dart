class Validator{
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    if (value.length < 3) {
      return "Enter valid name";
    }
    return null;
  }

  static String? validateEmail (String? value){
    if(value == null || value.isEmpty){
      return "email is Required";
    }
    // Email Validation
    final emailRegExp = RegExp( r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$');
    if(!emailRegExp.hasMatch(value)){
      return "Invalid Email";
    }
    return null;
  }

  static String? validatePhone (String? value){
    if(value == null || value.isEmpty){
      return "Phone Number is Required";
    }
    // Email Validation
    final phoneRegExp = RegExp( r'^\d{10}$');
    if(!phoneRegExp.hasMatch(value)){
      return "Invalid Phone Number";
    }
    return null;
  }

  static String? validatePassword (String? value){
    if(value == null || value.isEmpty){
      return "Password is Required";
    }
    // check for password Length
    if(value.length < 6){
      return "Password must contain at least 6 characters";
    }
    //check for Uppercase letters
    if(!value.contains(RegExp(r'[A-Z]'))){
      return "Password must contain at least upper Case";
    }
    //check for Numbers
    if(!value.contains(RegExp(r'[0-9]'))) {
      return "Password must contain at least one number";
    }

    //check for special characters
    if(!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
      return "Password must contain at least Special character";
    }
    return null;
  }

}