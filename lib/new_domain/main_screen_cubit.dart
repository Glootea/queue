import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:queue/data/database/new_database_service.dart';
import 'package:queue/entities/src/new_lesson.dart';
import 'package:queue/entities/src/new_queue_record.dart';
import 'package:queue/new_domain/user_cubit.dart';
part 'main_screen_cubit.freezed.dart';

class MainScreenCubit extends Cubit<MainScreenState?> {
  final NewDatabaseService _databaseService;
  final UserCubit _userCubit;
  final GoRouter _router;
  MainScreenCubit({required NewDatabaseService databaseService, required UserCubit userCubit, required GoRouter router})
      : _databaseService = databaseService,
        _router = router,
        _userCubit = userCubit,
        super(null) {
    _userCubitSubscription = _userCubit.stream.listen((state) {
      if (state == null) _router.push('/login');
    });
  }

  late final StreamSubscription _userCubitSubscription;

  Future<void> init() async {
    final todayLessons = await _databaseService.todayLessons();
    final onlineTableIDs = todayLessons.map((e) => e.onlineTableID).toList();
    final queueRecordList = await _databaseService.getQueueRecords(onlineTableIDs);
    emit(MainScreenState(newLessonList: todayLessons, recList: queueRecordList));
  }

  Future<void> addNewQueueRecord({required int index}) async {
    final lesson = state!.newLessonList[index];
    var queueRec = _getNewQueueRecord(lesson);
    state!.recList[lesson.name]!.add(queueRec);
    emit(state);
    final uploaded = await _databaseService.addNewQueueRecord(queueRec, _userCubit.rowNumber);
    if (uploaded) {
      _setLastQueueRecordToUploaded(queueRec, lesson.name);
      emit(state);
    }
  }

  NewQueueRecord _getNewQueueRecord(NewLesson lesson) => NewQueueRecord(
        localSubjectID: lesson.localID,
        onlineTableID: lesson.onlineTableID,
        studentRowNumber: _userCubit.rowNumber,
        time: DateTime.now(),
        workCount: _getWorkCount(lesson.name),
        status: NewQueueRecordStatus.shouldBeUploaded,
      );

  int? _getWorkCount(String lessonName) {
    return state!.recList[lessonName]
        ?.firstWhere((queueRec) => queueRec.studentRowNumber == _userCubit.rowNumber)
        .workCount;
  }

  void _setLastQueueRecordToUploaded(NewQueueRecord queueRec, String lessonName) {
    queueRec = queueRec.copyWith(status: NewQueueRecordStatus.uploaded);
    state!.recList[lessonName]!.removeLast();
    state!.recList[lessonName]!.add(queueRec);
  }

  Future<void> deleteQueueRecord({required NewQueueRecord queueRecord}) async {
    final lessons = state!.newLessonList.where((element) => element.localID == queueRecord.localSubjectID);
    lessons.map((lesson) => state!.recList[lesson.name]!.remove(queueRecord));
    emit(state);
    await _databaseService.deleteQueueRecord(queueRecord);
  }

  @override
  Future<void> close() {
    _userCubitSubscription.cancel();
    return super.close();
  }
}

@freezed
class MainScreenState with _$MainScreenState {
  const factory MainScreenState({
    required List<NewLesson> newLessonList,
    required Map<String, List<NewQueueRecord>> recList,
    DialogData? dialogData,
  }) = _MainScreenState;
}

abstract class DialogData {
  String title;
  String message;
  DialogData({required this.title, required this.message});
}

class ErrorDialogData extends DialogData {
  ErrorDialogData({
    required String title,
    required String message,
  }) : super(title: title, message: message);
}

class RequestWorkCountDialogData extends DialogData {
  final int workCount;
  RequestWorkCountDialogData({
    required String title,
    required String message,
    required this.workCount,
  }) : super(title: title, message: message);
}