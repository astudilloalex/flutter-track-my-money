abstract class Failure {
  const Failure({
    this.message,
    this.failureEnum,
  }) : assert(message != null || failureEnum != null);

  final String? message;
  final FailureEnum? failureEnum;

  String get code => message ?? failureEnum!.code;
}

class FirebaseFailure extends Failure {
  const FirebaseFailure({super.message, super.failureEnum});
}

class SQLiteFailure extends Failure {
  const SQLiteFailure({super.message, super.failureEnum});
}

class ServiceFailure extends Failure {
  const ServiceFailure({super.message, super.failureEnum});
}

enum FailureEnum implements Comparable<FailureEnum> {
  anUnknownErrorOcurred(code: 'an-unknown-error-ocurred'),
  attendanceAlreadyRegistered(code: 'attendance-already-registered'),
  failedToCreateUser(code: 'failed-to-create-user'),
  maximumNumberMembersReached(code: 'maximum-number-members-reached'),
  theCategoryAlreadyExists(code: 'the-categoy-already-exists'),
  theGoalAlreadyExists(code: 'the-goal-already-exists'),
  theGoalLimitHasBeenReached(code: 'the-goal-limit-has-been-reached'),
  theMemberDoesNotExist(code: 'the-member-does-not-exist'),
  thereAlreadyMemberWithThatID(code: 'there-is-already-a-member-with-that-id'),
  thereIsNoCompanySelected(code: 'there-is-no-company-selected'),
  theSessionHasBeenClosed(code: 'the-session-has-been-closed'),
  userAlreadyExists(code: 'user-already-exists'),
  userNotFound(code: 'user-not-found');

  const FailureEnum({
    required this.code,
  });

  final String code;

  @override
  int compareTo(FailureEnum other) {
    return code.compareTo(other.code);
  }
}
