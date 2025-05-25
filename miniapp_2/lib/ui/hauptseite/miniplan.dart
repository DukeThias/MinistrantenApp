import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../../logik/globals.dart';

class Miniplan extends StatefulWidget {
  @override
  _MiniplanState createState() => _MiniplanState();
}

class _MiniplanState extends State<Miniplan> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<String>> convertToEventMap(List<dynamic> termine) {
    final Map<DateTime, List<String>> eventMap = {};

    for (var termin in termine) {
      final start = DateTime.parse(termin['Start']);
      final dateOnly = DateTime.utc(start.year, start.month, start.day);
      final name = termin['Name'] ?? 'Unbenanntes Event';

      if (eventMap[dateOnly] == null) {
        eventMap[dateOnly] = [name];
      } else {
        eventMap[dateOnly]!.add(name);
      }
    }

    return eventMap;
  }

  @override
  Widget build(BuildContext context) {
    final globals = context.watch<Globals>();

    final termine = globals.get("termine") as List<dynamic>;
    final Map<DateTime, List<String>> _events = convertToEventMap(termine);

    List<String> _getEventsForDay(DateTime day) {
      return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
    }

    return Scaffold(
      appBar: AppBar(title: Text('Miniplan')),
      body: ListView(
        children: [
          TableCalendar(
            locale: "de_DE",
            rowHeight: 80, // moderate Rechtecke

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
            eventLoader: _getEventsForDay,
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
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero,
              ),
              markersAlignment: Alignment.bottomLeft,
              markerDecoration: BoxDecoration(), // du nutzt eigenen Marker
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.grey[400]),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.grey[400]),
              weekdayStyle: TextStyle(color: Colors.white),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24, width: 1),
                    color: Colors.transparent,
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
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24, width: 1),
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24, width: 1),
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return SizedBox();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(events.length, (index) {
                    final colorList = [
                      Colors.teal.shade400,
                      Colors.purple.shade400,
                      Colors.orange.shade400,
                      Colors.blue.shade400,
                    ];
                    return Container(
                      margin: EdgeInsets.only(
                        top: index == 0 ? 18 : 2,
                      ), // Abstand nach oben, bei erstem mehr
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorList[index % colorList.length],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        events[index].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _getEventsForDay(_selectedDay!).map((event) {
                      return Card(
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            event,
                            style: TextStyle(color: Colors.white),
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
