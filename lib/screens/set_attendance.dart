import 'package:attendmate/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetAttendance extends StatefulWidget {
  final String employeeEmail;
  final List<String> employees;

  SetAttendance({required this.employeeEmail, required this.employees});

  @override
  _SetAttendanceState createState() => _SetAttendanceState();
}

class _SetAttendanceState extends State<SetAttendance> {
  String _employeeName = '';
  String _employeeId = '';
  String? _selectedAttendanceStatus;

  final List<String> _attendanceOptions = ['Present', 'Halfday', 'Absent'];

  @override
  void initState() {
    super.initState();
    _getEmployeeDetails();
  }

  Future<void> _getEmployeeDetails() async {
    final employeeEmail = widget.employeeEmail;
    final employeeInfo = widget.employees.firstWhere(
      (employee) => employee.contains(employeeEmail),
      orElse: () => '',
    );

    if (employeeInfo.isNotEmpty) {
      final parts = employeeInfo.split(' - ');
      final name = parts[0];
      final email = parts[1];
      
      final prefs = await SharedPreferences.getInstance();
      final employeeId = prefs.getString('employeeId_$email') ?? 'N/A';

      setState(() {
        _employeeName = name;
        _employeeId = employeeId;
      });
    }
  }

  void _markAttendance() async {
  if (_selectedAttendanceStatus == null) {
    Fluttertoast.showToast(
      msg: "Please select attendance status",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Row(
        children: [
          Icon(Icons.help_outline, color: Colors.blue),
          SizedBox(width: MediaQuery.of(context).size.height * 0.01),
          Text(
            'Confirm Attendance', 
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to mark attendance for $_employeeName?',
        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'No',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(
              msg: "Attendance marked successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Login()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Yes', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Set Attendance',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.withOpacity(0.1), Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.height * 0.025,
                MediaQuery.of(context).size.height * 0.0,
                MediaQuery.of(context).size.height * 0.025,
                MediaQuery.of(context).size.height * 0.025,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.blue.withOpacity(0.1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person, color: Colors.blue, size: 28),
                              SizedBox(width: 8),
                              Text(
                                'Employee Details',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height * 0.028,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                          TextField(
                            readOnly: true,
                            controller: TextEditingController(text: _employeeName),
                            decoration: InputDecoration(
                              labelText: 'Employee Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.badge, color: Colors.blue),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                          TextField(
                            readOnly: true,
                            controller: TextEditingController(text: _employeeId),
                            decoration: InputDecoration(
                              labelText: 'Employee ID',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.credit_card, color: Colors.blue),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                          DropdownButtonFormField<String>(
                            value: _selectedAttendanceStatus,
                            decoration: InputDecoration(
                              labelText: 'Attendance Status',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.how_to_reg, color: Colors.blue),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: _attendanceOptions.map((String status) {
                              Color itemColor;
                              IconData itemIcon;
                              
                              switch (status) {
                                case 'Present':
                                  itemColor = Colors.green;
                                  itemIcon = Icons.check_circle;
                                  break;
                                case 'Halfday':
                                  itemColor = Colors.orange;
                                  itemIcon = Icons.timelapse;
                                  break;
                                case 'Absent':
                                  itemColor = Colors.red;
                                  itemIcon = Icons.cancel;
                                  break;
                                default:
                                  itemColor = Colors.black;
                                  itemIcon = Icons.circle;
                              }

                              return DropdownMenuItem<String>(
                                value: status,
                                child: Row(
                                  children: [
                                    Icon(itemIcon, color: itemColor, size: 20),
                                    SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                                    Text(status, style: TextStyle(color: itemColor)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedAttendanceStatus = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade800],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _markAttendance,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Colors.white),
                          SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                          Text(
                            'Mark Attendance',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height * 0.025,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  }