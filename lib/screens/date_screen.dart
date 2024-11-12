import 'package:attendmate/screens/emp_list.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateScreen extends StatefulWidget {
  DateScreen({super.key});

  @override
  State<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now();
  
  
  bool _isDateSelectable(DateTime day) {
    DateTime now = DateTime.now();
    
    DateTime dateToCheck = DateTime(day.year, day.month, day.day);
    DateTime currentDate = DateTime(now.year, now.month, now.day);
    
    return dateToCheck.isAtSameMomentAs(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Attendance Date',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade50],
            stops: [0.0, 0.3],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today, 
                                     color: Colors.blue.shade700),
                                SizedBox(width: MediaQuery.of(context).size.height * 0.02),
                                Text(
                                  "Today's Attendance",
                                  style: TextStyle(
                                    fontSize:  MediaQuery.of(context).size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TableCalendar(
                            firstDay: DateTime.now().subtract(Duration(days: 365)),
                            lastDay: DateTime.now().add(Duration(days: 365)),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) => _selectedDate != null && 
                                day.year == _selectedDate!.year && 
                                day.month == _selectedDate!.month && 
                                day.day == _selectedDate!.day,
                            enabledDayPredicate: _isDateSelectable,
                            onDaySelected: (selectedDay, focusedDay) {
                              if (_isDateSelectable(selectedDay)) {
                                setState(() {
                                  _selectedDate = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                              }
                            },
                            calendarStyle: CalendarStyle(
                              outsideDaysVisible: false,
                              disabledTextStyle: TextStyle(
                                color: Colors.grey.shade300,
                                decoration: TextDecoration.lineThrough,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                shape: BoxShape.circle,
                              ),
                              markersMaxCount: 1,
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.height * 0.02),
                          Text(
                            _selectedDate != null 
                                ? 'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                : 'Please select today\'s date',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height * 0.022,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                onPressed: _selectedDate != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmpList()),
                        );
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue to Employee List',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.022,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.08),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}