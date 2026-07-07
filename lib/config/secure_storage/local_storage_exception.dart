class LocalStorageException implements Exception {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  LocalStorageException(this.message, {this.error, this.stackTrace});

  @override
  String toString() => 'LocalStorageException: $message';
}
