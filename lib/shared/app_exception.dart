class AppException implements Exception {
  final String title;

  AppException({required this.title});

  @override
  String toString() {
    return title;
  }

  static AppException from(dynamic exception) {
    if (exception is AppException) return exception;
    return UnknownException();
  }
}

class PostsFetchError extends AppException {
  PostsFetchError() : super(title: "Erreur de récupération");
}

class PostsCreateError extends AppException {
  PostsCreateError() : super(title: "Erreur de création");
}

class PostsUpdateError extends AppException {
  PostsUpdateError() : super(title: "Erreur de mise à jour");
}

class PostsNotFoundError extends AppException {
  PostsNotFoundError() : super(title: "Post introuvable");
}

class PostsInvalidError extends AppException {
  PostsInvalidError() : super(title: "Post invalide");
}

class UnknownException extends AppException {
  UnknownException() : super(title: "Erreur inconnue");
}
