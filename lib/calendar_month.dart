import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar_model.dart';

class CalendarMonth extends StatelessWidget {
  final DateTime date;

  CalendarMonth({required this.date});

  List<TableRow> _buildCalendar(BuildContext context) {
    final model = Provider.of<CalendarModel>(context);
    List<TableRow> calendarRows = [];
    List<String> weekdays = ['일', '월', '화', '수', '목', '금', '토'];

    calendarRows.add(
      TableRow(
        children: weekdays.map((day) {
          return Container(
            padding: const EdgeInsets.all(2.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                day,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );

    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    int startDayOfWeek = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = List.generate(startDayOfWeek, (_) => Container());

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime dayDate = DateTime(date.year, date.month, day);
      bool isSelected = model.isSelectedDate(dayDate);
      bool isInDragRange = model.isInDragRange(dayDate);
      bool isToday = model.isToday(dayDate);
      bool isHoliday = model.isHoliday(dayDate);
      Color textColor = isHoliday ? Colors.red : (dayDate.weekday % 7 == 0) ? Colors.red : Colors.black;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            model.setSelectedDate(dayDate);
          },
          onLongPressStart: (_) => model.setDragStartDate(dayDate),
          onLongPressMoveUpdate: (details) => _handleLongPressMoveUpdate(details, context, dayWidgets, startDayOfWeek, model),
          onLongPressEnd: (_) => model.resetDragDates(),
          child: _buildDayContainer(day, isSelected, isInDragRange, isToday, model.isBlinking, textColor),
        ),
      );
    }

    for (int i = 0; i < dayWidgets.length; i += 7) {
      calendarRows.add(
        TableRow(
          children: List.generate(7, (index) {
            return i + index < dayWidgets.length ? dayWidgets[i + index] : Container();
          }),
        ),
      );
    }

    return calendarRows;
  }

  void _handleLongPressMoveUpdate(LongPressMoveUpdateDetails details, BuildContext context, List<Widget> dayWidgets, int startDayOfWeek, CalendarModel model) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);
    int columnIndex = localPosition.dx ~/ (box.size.width / 7);
    int rowIndex = localPosition.dy ~/ (box.size.height / 6);
    int index = rowIndex * 7 + columnIndex;
    if (index >= 0 && index < dayWidgets.length) {
      DateTime endDate = DateTime(date.year, date.month, index - startDayOfWeek + 1);
      model.setDragEndDate(endDate);
    }
  }

  Widget _buildDayContainer(int day, bool isSelected, bool isInDragRange, bool isToday, bool isBlinking, Color textColor) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: isBlinking ? 100 : 200),
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: isSelected || isInDragRange ? Colors.blue.withOpacity(0.2) : Colors.transparent,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isToday)
              Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              day.toString(),
              style: TextStyle(
                color: isToday ? Colors.white : textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(color: Colors.grey, width: 0.3),
        children: _buildCalendar(context),
      ),
    );
  }
}
