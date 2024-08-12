import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'calendar_model.dart';
import 'task_manager.dart';
import 'calendar_month.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFC7E0FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: Consumer<CalendarModel>(
                  builder: (context, model, child) {
                    return Text(
                      DateFormat.yMMMM('ko_KR').format(model.currentDate),
                      style: TextStyle(color: Colors.black),
                    );
                  },
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Expanded(
                flex: 6,
                child: Consumer<CalendarModel>(
                  builder: (context, model, child) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: PageView.builder(
                            controller: PageController(initialPage: model.currentPageIndex),
                            onPageChanged: (pageIndex) {
                              model.updateCurrentDateByPageIndex(pageIndex);
                            },
                            itemBuilder: (context, index) {
                              DateTime date = DateTime(
                                model.currentDate.year,
                                model.currentDate.month + (index - model.currentPageIndex),
                                1,
                              );
                              return CalendarMonth(date: date);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 7,
                child: Consumer<CalendarModel>(
                  builder: (context, model, child) {
                    return TaskManager(
                      selectedDate: model.selectedDate,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
