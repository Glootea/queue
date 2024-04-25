import 'package:flutter/material.dart';
import 'package:queue/entities/export.dart';
import 'package:queue/presentation/common_src/info_list_generic/tiles/add_new_tile.dart';
import 'package:queue/presentation/common_src/info_list_generic/tiles/lesson_tile/dated_tile.dart';
import 'package:queue/presentation/common_src/info_list_generic/tiles/lesson_tile/lesson_tile.dart';
import 'package:queue/presentation/common_src/info_list_generic/tiles/lesson_tile/weekly_tile.dart';
import 'package:queue/presentation/common_src/info_list_generic/tiles/student_tile.dart';

class InfoList<E> extends StatelessWidget {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<E> list;
  final int? outerCount;
  final bool weeklySelected;

  InfoList(
    this.list, {
    this.outerCount,
    this.weeklySelected = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        physics: const NeverScrollableScrollPhysics(),
        key: _listKey,
        shrinkWrap: true,
        initialItemCount: list.length + 1,
        itemBuilder: (context, count, animation) {
          if (count == list.length) {
            if (E == LessonTime) {
              return weeklySelected
                  ? AddNewTile<WeeklyLessonEntity>(animation, _listKey, list, weeklySelected: weeklySelected)
                  : AddNewTile<DatedLessonEntity>(animation, _listKey, list, weeklySelected: weeklySelected);
            }
            return AddNewTile<E>(animation, _listKey, list);
          } else {
            switch (E) {
              case StudentEntity:
                return StudentInfoTile(animation, list as List<StudentEntity>, count,
                    (double height) => _onDeleteButtonPressed(count, height));
              case LessonEntity:
                return LessonInfoTile(animation, list as List<LessonEntity>, count,
                    (double height) => _onDeleteButtonPressed(count, height));
              case LessonTime:
                assert(outerCount != null);
                if (list[count].runtimeType == WeeklyLessonEntity) {
                  return WeeklyLessonTile(animation, list as List<LessonTime>, outerCount ?? 0,
                      innerCount: count,
                      onDeleteButtonPressed: (double height) => _onDeleteButtonPressed(count, height),
                      onTimeChanged: (startTime, endTime) =>
                          _onTimeChanged<WeeklyLessonEntity>(count, startTime, endTime));
                } else {
                  return DatedLessonTile(animation, list as List<LessonTime>, outerCount ?? 0,
                      innerCount: count,
                      onDeleteButtonPressed: (double height) => _onDeleteButtonPressed(count, height),
                      onTimeChanged: (startTime, endTime) =>
                          _onTimeChanged<DatedLessonEntity>(count, startTime, endTime));
                }
              default:
                throw UnimplementedError("Unimplemented info for tile creation");
            }
          }
        });
  }

  void _onDeleteButtonPressed(int count, double height) {
    list.removeAt(count);
    _listKey.currentState?.removeItem(count, (context, animation) => _DeletedTile(height, animation),
        duration: Duration(milliseconds: height.toInt() * 4));
  }

  void _onTimeChanged<T extends LessonTime>(int count, TimeOfDay startTime, TimeOfDay endTime) {
    list[count] = (list[count] as T).copyWith(startTime: startTime, endTime: endTime) as E;
  }
}

class _DeletedTile extends StatelessWidget {
  final double height;
  final Animation<double> animation;
  const _DeletedTile(this.height, this.animation);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: CurvedAnimation(
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
          parent: animation,
        ),
        child: SizedBox(
          height: height,
          child: Center(
            child: Icon(Icons.delete_forever_outlined, color: Theme.of(context).colorScheme.error),
          ),
        ));
  }
}