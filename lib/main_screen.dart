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
              SizedBox(height: 16.0), // AppBar와 달력 사이의 간격
              Center(
                child: Container(
                  width: 380, // 고정된 너비
                  height: 300, // 고정된 높이
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Align(
                    alignment: Alignment.center, // 중앙에 배치
                    child: Consumer<CalendarModel>(
                      builder: (context, model, child) {
                        return ClipRRect(
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
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
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
