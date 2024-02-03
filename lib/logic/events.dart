import 'package:queue/entities/export.dart';

sealed class QueueEvent {}

// --- user authentication
class FindUserEvent extends QueueEvent {}

class UserLogOutEvent extends QueueEvent {}

class UserAuthenticatedEvent extends QueueEvent {}

class NoUserEvent extends QueueEvent {
  String? errorMessage;
  NoUserEvent([this.errorMessage]);
}

// --- main screen ---

class CreateRegEvent extends QueueEvent {
  final String lessonName;

  CreateRegEvent(this.lessonName);
}

class DeleteRegEvent extends QueueEvent {
  final String lessonName;

  DeleteRegEvent(this.lessonName);
}

class ToggleUpdateEvent extends QueueEvent {}

// --- upload from link
class ShowQRCodeEvent extends QueueEvent {
  final String lessonName;
  final DateTime time;

  ShowQRCodeEvent(this.lessonName, this.time);
}

class UploadFromLinkEvent extends QueueEvent {
  final String link;

  UploadFromLinkEvent(this.link);
}

// --- invite

class ReceivedInviteEvent extends QueueEvent {
  final String tableID;
  ReceivedInviteEvent(this.tableID);
}

class RegisterInvitedUserEvent extends QueueEvent {
  final String infoTableID;
  final String studentName;

  RegisterInvitedUserEvent(this.infoTableID, this.studentName);
}

// --- group creation

class CreateGroupIntentionEvent extends QueueEvent {}

class RegisterGroupEvent extends QueueEvent {
  final String firstName;
  final String lastName;
  final String groupName;
  final List<LessonSettingEntity> lessons;
  final List<StudentEntity> students;

  RegisterGroupEvent(this.firstName, this.lastName, this.groupName, this.lessons, this.students);
}

class LoginUsingGoogleEvent extends QueueEvent {}

// --- admin view
class NavigateToAdminSettingEvent extends QueueEvent {
  final int index;
  NavigateToAdminSettingEvent(this.index);
}
