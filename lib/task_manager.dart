import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // DottedBorder 패키지 import
import 'package:intl/intl.dart';
import 'calendar_model.dart';

class TaskManager extends StatefulWidget {
  final DateTime selectedDate;
  final CalendarModel model;

  TaskManager({required this.selectedDate, required this.model});

  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  List<String> _tasks = []; // 할 일 목록을 저장할 리스트
  List<bool> _selectedTasks = []; // 선택된 할 일을 추적하는 리스트
  List<bool> _completedTasks = []; // 완료된 할 일을 추적하는 리스트

  void _addTask(String task) {
    setState(() {
      _tasks.add(task);
      _selectedTasks.add(false);
      _completedTasks.add(false);
    });
  }

  void _editTask(int index, String newTask) {
    setState(() {
      _tasks[index] = newTask;
    });
  }

  void _removeSelectedTasks() {
    setState(() {
      for (int i = _tasks.length - 1; i >= 0; i--) {
        if (_selectedTasks[i]) {
          _tasks.removeAt(i);
          _selectedTasks.removeAt(i);
          _completedTasks.removeAt(i);
        }
      }
    });
  }

  void _completeSelectedTasks() {
    setState(() {
      for (int i = 0; i < _tasks.length; i++) {
        if (_selectedTasks[i]) {
          _completedTasks[i] = !_completedTasks[i];
          _selectedTasks[i] = false;
        }
      }
    });
  }

  Future<void> _showTaskInputDialog({int? index}) async {
    String initialText = index != null ? _tasks[index] : '';
    TextEditingController controller = TextEditingController(text: initialText);

    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: '할일 입력',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(controller.text);
                  },
                  child: Text('확인'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      if (index != null) {
        _editTask(index, result);
      } else {
        _addTask(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // 가로로 화면을 꽉 채우도록 설정
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent, // 배경을 투명하게 설정하여 그라데이션이 그대로 보이도록 함
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${widget.selectedDate.day}', // 선택한 날의 숫자만 표시
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8), // 숫자와 텍스트 사이에 간격 추가
                  Text(
                    'Upcoming Event', // 오른쪽에 "Upcoming Event" 텍스트 추가
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.check_circle),
                    onPressed: _completeSelectedTasks,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: _removeSelectedTasks,
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 10.0,
                        height: 40.0, // 고정된 높이 설정
                        decoration: BoxDecoration(
                          color: Colors.blue, // 파란색 바
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40.0, // 고정된 높이 설정
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 2), // 그림자가 적용될 위치
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _selectedTasks[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _selectedTasks[index] = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  _tasks[index],
                                  style: TextStyle(
                                    decoration: _completedTasks[index]
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );

              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0), // 위에 약간의 간격 추가
            child: Row(
              children: [
                Expanded(
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12.0),
                    dashPattern: [6, 3], // 점선 패턴 설정 (길이 6, 간격 3)
                    color: Colors.grey, // 점선 색상
                    strokeWidth: 1, // 점선 두께
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        side: BorderSide.none,
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      onPressed: () => _showTaskInputDialog(),
                      child: Center(
                        child: Text(
                          '+ 일정 추가',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
