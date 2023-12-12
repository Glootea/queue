import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:queue/entities/lesson.dart';
import 'package:queue/extension.dart';

class DatedLessonTile extends TimeChooser {
  final Animation<double> animation;
  final List<DatedLessonSettingEntity> datedLessons;
  final int outerCount;

  const DatedLessonTile(this.animation, this.datedLessons, this.outerCount,
      {required super.innerCount, required super.onDeleteButtonPressed, required super.onTimeChanged, super.key});

  @override
  State<DatedLessonTile> createState() => _DatedLessonTileTileState();
}

class _DatedLessonTileTileState extends State<DatedLessonTile> {
  DateTime? lastSelectedDate;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      key: ValueKey(widget.datedLessons[widget.innerCount]),
      sizeFactor: widget.animation,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Создание времени занятий в отдельные дни"),
                      content: StatefulBuilder(
                        builder: (context, newSetState) => Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .7,
                            height: 200,
                            child: Scrollbar(
                              child: GridView.builder(
                                  primary: true,
                                  shrinkWrap: true,
                                  itemCount: widget.datedLessons[widget.innerCount].date.length + 1,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width * .7 ~/ 120),
                                  itemBuilder: (context, count) {
                                    if (count == widget.datedLessons[widget.innerCount].date.length) {
                                      return SizedBox(
                                        height: 48,
                                        width: 64,
                                        child: Center(
                                          child: OutlinedButton(
                                              onPressed: () async {
                                                final result = await showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime.now(),
                                                    initialDate: lastSelectedDate,
                                                    lastDate: DateTime.now().add(const Duration(days: 365)));
                                                lastSelectedDate = result;
                                                if (result != null) {
                                                  setState(() {
                                                    widget.datedLessons[widget.innerCount].date.add(result);
                                                  });
                                                  newSetState(() {});
                                                }
                                              },
                                              child: const Text('+')),
                                        ),
                                      );
                                    } else {
                                      return SizedBox(
                                          height: 48,
                                          width: 64,
                                          child: Stack(children: [
                                            Center(
                                              child: OutlinedButton(
                                                onPressed: () async {
                                                  final result = await showDatePicker(
                                                      context: context,
                                                      firstDate: DateTime.now(),
                                                      initialDate: lastSelectedDate,
                                                      lastDate: DateTime.now().add(const Duration(days: 365)));
                                                  lastSelectedDate = result;
                                                  if (result != null) {
                                                    setState(() {
                                                      widget.datedLessons[widget.innerCount].date[count] = result;
                                                    });
                                                    newSetState(() {});
                                                  }
                                                },
                                                child: Text(
                                                  DateFormat('dd.MM').format(widget.datedLessons[widget.innerCount].date[count]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        widget.datedLessons[widget.innerCount].date.removeAt(count);
                                                      });
                                                      newSetState(() {});
                                                    },
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.close_outlined,
                                                        color: Theme.of(context).colorScheme.error,
                                                      ),
                                                    )),
                                              ),
                                            )
                                          ]));
                                    }
                                  }),
                            ),
                          ),
                          const Gap(16),
                          const Gap(16),
                          SizedBox(
                            height: 96,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Начало',
                                      style: Theme.of(context).textTheme.headlineMedium,
                                    ),
                                    const Gap(16),
                                    OutlinedButton(
                                      onPressed: () async {
                                        widget.datedLessons[widget.innerCount] = widget.datedLessons[widget.innerCount].copyWith(
                                            startTime: await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay(
                                                    hour: widget.datedLessons[widget.innerCount].startTime.hour,
                                                    minute: widget.datedLessons[widget.innerCount].startTime.minute)));
                                        setState(() {});
                                        newSetState(() {});
                                      },
                                      child: Text(widget.datedLessons[widget.innerCount].startTime.toShortString()),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Конец',
                                      style: Theme.of(context).textTheme.headlineMedium,
                                    ),
                                    const Gap(16),
                                    OutlinedButton(
                                      onPressed: () async {
                                        widget.datedLessons[widget.innerCount] = widget.datedLessons[widget.innerCount].copyWith(
                                            endTime: await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay(
                                                    hour: widget.datedLessons[widget.innerCount].endTime.hour,
                                                    minute: widget.datedLessons[widget.innerCount].endTime.minute)));
                                        setState(() {});
                                        newSetState(() {});
                                      },
                                      child: Text(widget.datedLessons[widget.innerCount].endTime.toShortString()),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ]),
                      ),
                      actions: [TextButton(onPressed: () => context.pop(), child: const Text('OK'))],
                    )),
            child: ColoredBox(
              color: Colors.transparent,
              child: Row(
                children: [
                  const Text('  •   '),
                  Expanded(
                    child: Text(
                      '${widget.datedLessons[widget.innerCount].date.map((e) => DateFormat('dd.MM').format(e))}'.replaceAll('(', '').replaceAll(')', ''),
                      overflow: TextOverflow.ellipsis,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                      ': ${widget.datedLessons[widget.innerCount].startTime.toShortString()} - ${widget.datedLessons[widget.innerCount].endTime.toShortString()}'),
                  TextButton(
                      onPressed: () => widget.onDeleteButtonPressed((context.findRenderObject() as RenderBox).size.height),
                      child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error))
                ],
              ),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}