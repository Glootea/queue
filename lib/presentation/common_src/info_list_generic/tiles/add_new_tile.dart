import 'package:flutter/material.dart';
import 'package:queue/entities/export.dart';
import 'package:queue/data/database/sources/local_database/local_database.dart';

class AddNewTile<E> extends StatelessWidget {
  final Animation<double> animation;
  final GlobalKey<AnimatedListState> _listKey;
  final List list;
  final bool? weeklySelected;
  const AddNewTile(this.animation, this._listKey, this.list, {this.weeklySelected, super.key});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
        parent: animation,
      ),
      child: Column(
        children: [
          // (list.isNotEmpty) ? const Divider() : Container(),
          InkWell(
            onTap: () {
              _onAddButtonPressed();
            },
            child: ListTile(
              // Create new student field
              leading: const Icon(
                Icons.add_outlined,
                color: Colors.white,
              ),
              title: Text(
                  "Добавить ${switch (E) {
                    StudentEntity => 'студента',
                    LessonEntity => 'занятие',
                    WeeklyLessonEntity => 'время, которое повторяется каждую неделю',
                    DatedLessonEntity => 'время, которое повторяется в определенные дни',
                    _ => 'вариант, который никто не увидит'
                  }}",
                  style: (E == LessonEntity || E == Student)
                      ? Theme.of(context).textTheme.titleMedium
                      : Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddButtonPressed() {
    _listKey.currentState?.insertItem(
      list.length,
      duration: const Duration(milliseconds: 500),
    );
    switch (E) {
      case StudentEntity:
        list.add(const StudentEntity('', -1) as E);
      case LessonEntity:
        // ignore: prefer_const_literals_to_create_immutables to prevent error of not being able to change
        list.add(LessonEntity('', [], false, false) as E); //TODO: check if unable to change
      case WeeklyLessonEntity:
        list.add(const WeeklyLessonEntity(TimeOfDay(hour: 0, minute: 0), TimeOfDay(hour: 0, minute: 0), [1]) as E);
      case DatedLessonEntity:
        final date = DateTime.now();
        list.add(
            DatedLessonEntity(const TimeOfDay(hour: 0, minute: 0), const TimeOfDay(hour: 0, minute: 0), [date]) as E);
    }
  }
}