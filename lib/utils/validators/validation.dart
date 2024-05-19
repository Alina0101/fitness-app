class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите имя';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите Email';
    }
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) return 'Неверный формат Email';
    return null;
  }

  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Требуется указать пароль';
    }

    if (value.length < 6) {
      return 'Необходимо минимум 6 символов';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Добавьте минимум одну латинскую строчную букву';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Добавьте минимум одну латинскую заглавную букву';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Добавьтеs минимум одну цифру';
    }

    return null;
  }


  static String? validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    return null;
  }
}
