class SubmissionException implements Exception {
  final String message;

  const SubmissionException(this.message);

  @override
  String toString() => message;
}
