import 'dart:developer';
import 'dart:math' as math;
import 'package:gsheets/gsheets.dart';
import 'package:queue/data/database/local_database.dart';
import 'package:queue/entities/lesson.dart';
import 'package:queue/entities/rec.dart';
import 'package:queue/extension.dart';
import 'package:queue/secret/table_credentials.dart';

const String _infoSheetName = 'info';
const String _namesSheetName = 'names';
const String _lessonsSheetName = 'lessons';
const String _lessonTimesSheetName = 'lessonTimes';

class OnlineDataBase {
  final _gsheets = GSheets(CREDENTIALS);
  Spreadsheet? _spreadsheet;
  Worksheet? _infoSheet;
  Worksheet? _namesSheet;
  Worksheet? _lessonsSheet;
  Worksheet? _lessonTimesSheet;
  final String _infoTableID;
  Map<String, String> _mapLessonNameToId;
  OnlineDataBase._(this._infoTableID, this._mapLessonNameToId);
  static OnlineDataBase? _instance;

  static Future<OnlineDataBase> instance(String tableID, Map<String, String> map) async {
    if (_instance != null) {
      return _instance!;
    }
    _instance = OnlineDataBase._(tableID, map);
    final spreadsheet = await _instance!._gsheets.spreadsheet(tableID);
    if (spreadsheet.sheets.map((e) => e.title).toSet().containsAll(["info", "names", "lessons", "lessonTimes"])) {
      return _instance!;
    }
    final insertNames = spreadsheet.addWorksheet(_namesSheetName);
    final insertLessons = spreadsheet.addWorksheet(_lessonsSheetName);
    final insertLessonTimes = spreadsheet.addWorksheet(_lessonTimesSheetName);
    final insertInfo = spreadsheet.addWorksheet(_infoSheetName);
    final result = await Future.wait([insertInfo, insertNames, insertLessons, insertLessonTimes]);
    final _ = await spreadsheet.deleteWorksheet(spreadsheet.worksheetByTitle("Лист1") ?? (await spreadsheet.addWorksheet("Лист1")));
    final fillInfo1 = result[0].values.insertRow(1, ["Ключи", "Значения"]);
    final fillInfo2 = result[0].values.insertColumn(
        1,
        [
          "Группа",
          "Староста",
          "Админы",
        ],
        fromRow: 2);
    final fillNames = result[1].values.insertRow(1, ["Имя/Фамилия"]);
    final fillLessons =
        result[2].values.insertRow(1, ["id", "Название", "id таблицы", "Учитывать количество сданных работ", "Автоочистка", "Последняя очистка"]);
    final fillLessonTimes = result[3].values.insertRow(1, ["id", "Даты", "Дни недели", "Время начала", "Время окончания"]);
    await Future.wait([fillNames, fillLessonTimes, fillLessons, fillInfo1, fillInfo2]);
    return _instance!;
  }

  // final TABLEID = ''; //TODO: get ss id
  Future<List<RecEntity>> getData() async {
    final result = <RecEntity>[];
    // try { TODO: rewrite
    //   _spreadsheet ??= await _gsheets.spreadsheet(_infoTableID);
    //   _queueSheet ??= _spreadsheet!.worksheetByTitle(_queueSheetName) ?? await _spreadsheet!.addWorksheet(_queueSheetName);
    //   final allColumns = await _queueSheet!.cells.allColumns();
    //   _nameColumn ??= (allColumns[0]).sublist(1).map((e) => e.value).where((element) => element.isNotEmpty).toList();
    //   _subjectRow ??= (allColumns.sublist(1).map((e) => e.first)).map((e) => e.value).where((element) => element.isNotEmpty).toList();
    //   // final columnCount = sheet.columnCount;
    //   for (int i = 0; i < _subjectRow!.length; i++) {
    //     result.addAll((allColumns[i + 1].sublist(1))
    //         .where((element) => element.value.isNotEmpty)
    //         .map((e) => RecEntity(_nameColumn![e.row - 2], DateTime.parse(e.value), _subjectRow![i]))
    //         .toList());
    //   }
    // } catch (e) {
    //   log("Failed to load database");
    //   rethrow;
    // }

    return result;
  }

  Future<bool> createRec(String lessonName, String userName, DateTime time) async {
    // try { TODO: rewrite
    //   _spreadsheet ??= await _gsheets.spreadsheet(_infoTableID);
    //   _queueSheet ??= _spreadsheet!.worksheetByTitle(_queueSheetName) ?? await _spreadsheet!.addWorksheet(_queueSheetName);
    //   _nameColumn ??= (await _queueSheet!.cells.column(1)).map((e) => e.value).where((element) => element.isNotEmpty).toList();
    //   _subjectRow ??= (await _queueSheet!.cells.row(1)).map((e) => e.value).where((element) => element.isNotEmpty).toList();
    //   int row = _nameColumn!.indexOf(userName) + 2;
    //   int column = _subjectRow!.indexOf(lessonName) + 2;
    //   return await (await _queueSheet!.cells.cell(row: row, column: column)).post(time);
    // } catch (e) {
    //   log(e.toString());
    //   return false;
    // }
    return false;
  }

  Future<bool> deleteRec(String lessonName, String userName) async {
    // try { TODO: rewrite
    //   _spreadsheet ??= await _gsheets.spreadsheet(_infoTableID);
    //   _queueSheet ??= _spreadsheet!.worksheetByTitle(_queueSheetName) ?? await _spreadsheet!.addWorksheet(_queueSheetName);
    //   _nameColumn ??= (await _queueSheet!.cells.column(1)).map((e) => e.value).where((element) => element.isNotEmpty).toList();
    //   _subjectRow ??= (await _queueSheet!.cells.row(1)).map((e) => e.value).where((element) => element.isNotEmpty).toList();
    //   int row = _nameColumn!.indexOf(userName) + 2;
    //   int column = _subjectRow!.indexOf(lessonName) + 2;
    //   return await (await _queueSheet!.cells.cell(row: row, column: column)).post(null);
    // } catch (e) {
    //   log(e.toString());
    //   return false;
    // }
    return false;
  }

  Future<bool> uploadFromQuery(String query) async {
    // try { TODO: rewrite
    //   List<String> params = query.split("&&&").map((e) => e.trim()).toList();
    //   String lessonName = params[1];
    //   String userName = params[2];
    //   DateTime time = DateTime.parse(params[3]);
    //   _spreadsheet ??= await _gsheets.spreadsheet(_infoTableID);
    //   _queueSheet ??= _spreadsheet!.worksheetByTitle(_queueSheetName) ?? await _spreadsheet!.addWorksheet(_queueSheetName);
    //   _nameColumn ??= (await _queueSheet!.cells.column(1)).map((e) => e.value).where((element) => element.isNotEmpty).toList();
    //   _subjectRow ??= (await _queueSheet!.cells.row(1)).map((e) => e.value).where((element) => element.isNotEmpty).toList();
    //   int row = _nameColumn!.indexOf(userName) + 2;
    //   int column = _subjectRow!.indexOf(lessonName) + 2;
    //   final result = await (await _queueSheet!.cells.cell(row: row, column: column)).post(time);
    //   return result;
    // } catch (e) {
    //   log(e.toString());
    //   return false;
    // }
    return false;
  }

  Future<Map<String, String>?> recExist(String query) async {
    // List<String> params = query.split("&&&").map((e) => e.trim()).toList(); // TODO: rewrite
    // String lessonName = params[1];
    // String userName = params[2];
    // DateTime time = DateTime.parse(params[3]);
    // _spreadsheet ??= await _gsheets.spreadsheet(_infoTableID);
    // _queueSheet ??= _spreadsheet!.worksheetByTitle(_queueSheetName) ?? await _spreadsheet!.addWorksheet(_queueSheetName);
    // _nameColumn ??= (await _queueSheet!.cells.column(1)).map((e) => e.value).where((element) => element.isNotEmpty).toList();
    // _subjectRow ??= (await _queueSheet!.cells.row(1)).map((e) => e.value).where((element) => element.isNotEmpty).toList();
    // int row = _nameColumn!.indexOf(userName) + 2;
    // int column = _subjectRow!.indexOf(lessonName) + 2;
    // final r = (await _queueSheet!.cells.cell(row: row, column: column)).value;
    // final result = r == time.toString();
    // if (result) {
    //   final queue = (([...(await _queueSheet!.cells.column(column, fromRow: 2))].where((element) => element.value.isNotEmpty).toList()
    //     ..sort((a, b) => DateTime.parse(a.value).compareTo(DateTime.parse(b.value)))));
    //   final position = queue.indexWhere((element) => element.value == r) + 1;
    //   return {'name': userName, 'position': position.toString(), 'last': _nameColumn![queue[math.max(position - 2, 0)].row - 2]};
    // } else {
    //   return null;
    // }
    return null;
  }

  Future<bool> fillStudents(List<StudentsCompanion> list) async {
    // TODO: sort by alphabet, but remember to fill head(now index = 0, won't be later)
    _spreadsheet = await _gsheets.spreadsheet(_infoTableID);
    List<Future> tasks = List.filled(2, Future.value(null), growable: false);
    _namesSheet = _spreadsheet!.worksheetByTitle(_namesSheetName);
    _infoSheet = _spreadsheet!.worksheetByTitle(_infoSheetName);
    if (_namesSheet == null || _infoSheet == null) {
      tasks[0] = _namesSheet == null ? _spreadsheet!.addWorksheet(_namesSheetName) : Future.value(null);
      tasks[1] = _infoSheet == null ? _spreadsheet!.addWorksheet(_infoSheetName) : Future.value(null);
      final result = await Future.wait(tasks);
      _namesSheet = result[0];
      _infoSheet = result[1];
    }
    final result = await _namesSheet?.cells.column(1);
    if (_namesSheet == null || result == null) {
      throw Exception("Failed to load data for student insert");
    }
    List<String>? column = result.map((e) => e.value).toList();
    List<int> adminId = [];
    int i = 0;
    for (int j = 0; j < list.length; j++) {
      while (i + j < column.length && column[i + j].isNotEmpty) {
        i++;
      }
      if (list[j].isAdmin.value ?? false) {
        adminId.add(i + j);
      }
      if (i + j >= column.length) {
        column.add(list[j].name.value);
      } else {
        column[i + j] = list[j].name.value;
      }
    }

    tasks[0] = _namesSheet?.values.insertColumn(1, column) ?? Future(() => null);
    tasks[1] = _infoSheet?.values.insertValueByKeys(adminId.join(', '), columnKey: "Значения", rowKey: "Админы") ?? Future(() => null);
    // TODO: fill class head
    await Future.wait(tasks);
    return true;
  }

  Future<bool> fillLessons(List<LessonSettingEntity> list, List<String> ids) async {
    // TODO: get new reference when starting new interaction with google sheet
    _spreadsheet = await _gsheets.spreadsheet(_infoTableID);
    _lessonsSheet = _spreadsheet!.worksheetByTitle(_lessonsSheetName);
    _lessonTimesSheet = _spreadsheet!.worksheetByTitle(_lessonTimesSheetName);
    List<Future> tasks = [];
    if (_lessonsSheet == null || _lessonTimesSheet == null) {
      tasks.add(_lessonsSheet == null ? _spreadsheet!.addWorksheet(_lessonsSheetName) : Future.value(null));
      tasks.add(_lessonTimesSheet == null ? _spreadsheet!.addWorksheet(_lessonTimesSheetName) : Future.value(null));
      final result = await Future.wait(tasks);
      _lessonsSheet = result[0];
      _lessonTimesSheet = result[1];
      tasks = [];
    }
    final lessonTable = await _lessonsSheet?.cells.allColumns();
    final lessonTimesTable = await _lessonTimesSheet?.cells.allColumns();
    int lessonIndex = 1;
    int lessonTimesIndex = 1;
    for (int i = 0; i < list.length; i++) {
      final lesson = list[i];
      if ((lessonIndex >= (lessonTable?[0].length ?? 0))) {
        lessonIndex++;
      } else {
        while ((lessonIndex < (lessonTable?[0].length ?? 0)) && (lessonTable?[0][lessonIndex].value.isNotEmpty ?? false)) {
          lessonIndex++;
        }
      }
      tasks.add(_lessonsSheet?.values.insertRow(lessonIndex, [lessonIndex, lesson.name, ids[i], 'нет', 'нет', 'нет']) ?? Future.value(null));
      final length = lesson.useWeekly ? (lesson.weeklyLessons?.length ?? 0) : (lesson.datedLessons?.length ?? 0);
      for (int j = 0; j < length; j++) {
        if ((lessonTimesIndex >= (lessonTimesTable?[0].length ?? 0))) {
          lessonTimesIndex++;
        } else {
          while ((lessonTimesIndex < (lessonTimesTable?[0].length ?? 0)) && (lessonTimesTable?[0][lessonTimesIndex].value.isNotEmpty ?? false)) {
            lessonTimesIndex++;
          }
        }
        if (lesson.useWeekly) {
          final weeklyLesson = lesson.weeklyLessons![j];
          tasks.add(_lessonTimesSheet?.values.insertRow(lessonTimesIndex,
                  [lessonIndex, '-', weeklyLesson.weekdays.join(', '), weeklyLesson.startTime.toShortString(), weeklyLesson.endTime.toShortString()]) ??
              Future.value(null));
        } else {
          final datedLesson = lesson.datedLessons![j];
          tasks.add(_lessonTimesSheet?.values.insertRow(lessonTimesIndex,
                  [lessonIndex, datedLesson.date.join(', '), '-', datedLesson.startTime.toShortString(), datedLesson.endTime.toShortString()]) ??
              Future.value(null));
        }
      }
    }

    await Future.wait(tasks);
    return true;
  }
}
