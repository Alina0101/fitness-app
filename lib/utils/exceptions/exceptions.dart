class Exceptions implements Exception {

  final String message;

  const Exceptions([this.message = 'Произошла непредвиденная ошибка. Пожалуйста, попробуйте снова.']);

  factory Exceptions.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const Exceptions('Этот адрес электронной почты уже зарегистрирован. Пожалуйста, используйте другой адрес электронной почты.');
      case 'invalid-email':
        return const Exceptions('Указанный адрес электронной почты недействителен. Пожалуйста, введите действительный адрес электронной почты.');
      case 'weak-password':
        return const Exceptions('Пароль слишком слабый. Пожалуйста, выберите более надежный пароль.');
      case 'user-disabled':
        return const Exceptions('Эта учетная запись пользователя отключена. Пожалуйста, свяжитесь с службой поддержки для получения помощи.');
      case 'user-not-found':
        return const Exceptions('Недействительные учетные данные для входа. Пользователь не найден.');
      case 'wrong-password':
        return const Exceptions('Неправильный пароль. Пожалуйста, проверьте свой пароль и попробуйте снова.');
      case 'INVALID_LOGIN_CREDENTIALS':
        return const Exceptions('Недопустимые учетные данные для входа. Пожалуйста, перепроверьте ваши данные.');
      case 'too-many-requests':
        return const Exceptions('Слишком много запросов. Пожалуйста, попробуйте позже.');
      case 'invalid-argument':
        return const Exceptions('Недопустимый аргумент, предоставленный для метода аутентификации.');
      case 'invalid-password':
        return const Exceptions('Неправильный пароль. Пожалуйста, попробуйте снова.');
      case 'operation-not-allowed':
        return const Exceptions('Провайдер входа отключен для вашего проекта Firebase.');
      case 'session-cookie-expired':
        return const Exceptions('Сессионный cookie Firebase истек. Пожалуйста, войдите снова.');
      case 'uid-already-exists':
        return const Exceptions('Указанный идентификатор пользователя уже используется другим пользователем.');
      case 'sign_in_failed':
        return const Exceptions('Вход не удался. Пожалуйста, попробуйте снова.');
      case 'internal-error':
        return const Exceptions('Внутренняя ошибка. Пожалуйста, попробуйте снова позже.');
      case 'quota-exceeded':
        return const Exceptions('Превышен лимит. Пожалуйста, попробуйте позже.');
      default:
        return const Exceptions();
    }
  }
}
