import 'package:flutter/material.dart';
import 'package:miniapp_2/ui/hauptseite/hauptseite_drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../../logik/globals.dart';
import 'einzelne seiten/infoseite_termin.dart';

class Miniplan extends StatefulWidget {
  const Miniplan({super.key});

  @override
  _MiniplanState createState() => _MiniplanState();
}

class _MiniplanState extends State<Miniplan> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<DateTime, List<Map<String, dynamic>>> convertToEventMap(
    List<dynamic> termine,
  ) {
    final Map<DateTime, List<Map<String, dynamic>>> eventMap = {};
    for (var termin in termine) {
      final start = DateTime.parse(termin['Start']);
      final dateOnly = DateTime.utc(start.year, start.month, start.day);
      if (eventMap[dateOnly] == null) {
        eventMap[dateOnly] = [termin];
      } else {
        eventMap[dateOnly]!.add(termin);
      }
    }
    return eventMap;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final globals = context.watch<Globals>();

    final termine = globals.get("termine") as List<dynamic>;
    final Map<DateTime, List<Map<String, dynamic>>> events = convertToEventMap(
      termine,
    );
    List<Map<String, dynamic>> getEventsForDay(DateTime day) {
      return events[DateTime.utc(day.year, day.month, day.day)] ?? [];
    }

    return Scaffold(
      appBar: AppBar(title: Text('Miniplan')),
      drawer: drawer(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF23272F) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDark ? Colors.black54 : Colors.grey.withOpacity(0.25),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: TableCalendar(
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  locale: "de_DE",
                  rowHeight: 80,
                  daysOfWeekHeight: 32,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: getEventsForDay,
                  calendarStyle: CalendarStyle(
                    defaultDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    weekendDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.15),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.25),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    markersAlignment: Alignment.bottomLeft,
                    markerDecoration:
                        BoxDecoration(), // du nutzt eigenen Marker
                    defaultTextStyle: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    weekendTextStyle: TextStyle(
                      color: isDark ? Colors.grey[400]! : Colors.grey[700]!,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                    weekdayStyle: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final borderColor =
                          isDark ? Colors.white10 : Colors.black12;
                      bool isLastColumn = day.weekday == DateTime.sunday;
                      bool isFirstColumn = day.weekday == DateTime.monday;
                      bool isOutsideMonth = day.month != focusedDay.month;

                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: borderColor, width: 1),
                            bottom: BorderSide(color: borderColor, width: 1),
                            left:
                                isFirstColumn
                                    ? BorderSide.none
                                    : BorderSide(color: borderColor, width: 1),
                            right:
                                isLastColumn
                                    ? BorderSide.none
                                    : BorderSide(color: borderColor, width: 1),
                          ),
                          color: Colors.transparent,
                        ),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(
                          left: 4,
                          top: 3,
                          right: 2,
                          bottom: 2,
                        ),
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color:
                                isDark
                                    ? (isOutsideMonth
                                        ? Colors.grey[600]
                                        : Colors.white)
                                    : (isOutsideMonth
                                        ? Colors.grey[400]
                                        : Colors.black),
                          ),
                        ),
                      );
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      final borderColor =
                          isDark ? Colors.white10 : Colors.black12;
                      bool isLastColumn = day.weekday == DateTime.sunday;
                      bool isFirstColumn = day.weekday == DateTime.monday;

                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right:
                                isLastColumn
                                    ? BorderSide.none
                                    : BorderSide(color: borderColor, width: 1),
                            bottom: BorderSide(color: borderColor, width: 1),
                            top: BorderSide(color: borderColor, width: 1),
                            left:
                                isFirstColumn
                                    ? BorderSide.none
                                    : BorderSide(color: borderColor, width: 1),
                          ),
                          color: Colors.transparent,
                        ),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(
                          left: 4,
                          top: 3,
                          right: 2,
                          bottom: 2,
                        ),
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isDark ? Colors.grey[600] : Colors.grey[400],
                          ),
                        ),
                      );
                    },

                    todayBuilder: (context, day, focusedDay) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? Colors.white24 : Colors.black12,
                            width: 1,
                          ),
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.zero,
                        ),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(
                          left: 4,
                          top: 3,
                          right: 2,
                          bottom: 2,
                        ),
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? Colors.white24 : Colors.black12,
                            width: 1,
                          ),
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.25),
                          borderRadius: BorderRadius.zero,
                        ),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(
                          left: 4,
                          top: 3,
                          right: 2,
                          bottom: 2,
                        ),
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(events.length, (index) {
                            final colorList = [
                              isDark
                                  ? Colors.teal.shade400
                                  : Colors.teal.shade600,
                              isDark
                                  ? Colors.purple.shade400
                                  : Colors.purple.shade600,
                              isDark
                                  ? Colors.orange.shade400
                                  : Colors.orange.shade600,
                              isDark
                                  ? Colors.blue.shade400
                                  : Colors.blue.shade600,
                            ];
                            final Map<String, dynamic> eventMap =
                                events[index] as Map<String, dynamic>;
                            return Container(
                              margin: EdgeInsets.only(
                                top: index == 0 ? 18 : 0,
                                left: 2,
                                right: 2,
                                bottom: 2,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorList[index % colorList.length],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Transform.scale(
                                scale: 1.15,
                                child: Text(
                                  eventMap["Name"] ?? "Unbekannt",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (_calendarFormat == CalendarFormat.month) {
                setState(() {
                  _calendarFormat = CalendarFormat.week;
                });
              } else {
                setState(() {
                  _calendarFormat = CalendarFormat.month;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Center(
                child: Container(
                  width: 42,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16),
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    getEventsForDay(_selectedDay!).map((termin) {
                      return Card(
                        color: isDark ? Color(0xFF292d32) : Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        InfoSeiteTermin(termin: termin),
                              ),
                            );
                          },
                          title: Text(
                            termin['Name'] ?? 'Unbenannt',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          leading: Icon(
                            Icons.event,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
