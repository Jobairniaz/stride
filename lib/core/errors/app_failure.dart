/// Typed application failures. Plugin/platform exceptions are converted to
/// these at adapter boundaries so the UI can show honest, specific messages.
sealed class AppFailure implements Exception {
  const AppFailure(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

class InvalidWorkoutPlanFailure extends AppFailure {
  const InvalidWorkoutPlanFailure(super.message);
}

class PersistenceFailure extends AppFailure {
  const PersistenceFailure(super.message, {super.cause});
}

class SpeechUnavailableFailure extends AppFailure {
  const SpeechUnavailableFailure(super.message, {super.cause});
}

class NotificationFailure extends AppFailure {
  const NotificationFailure(super.message, {super.cause});
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}
