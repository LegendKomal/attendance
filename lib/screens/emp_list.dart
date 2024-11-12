import 'package:attendance/screens/set_attendance.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpList extends StatefulWidget {
   EmpList({super.key});

  @override
  State<EmpList> createState() => _EmpListState();
}

class _EmpListState extends State<EmpList> {
  List<String> _employees = [];
  List<String> _filteredEmployees = [];
  final _searchController = TextEditingController();
  bool _isSearchFocused = false;
  final _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
    _filteredEmployees = _employees;
  }

  Future<void> _loadEmployees() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final empList = prefs.getStringList('empList') ?? [];
    
    
    await Future.delayed( Duration(milliseconds: 800));
    
    setState(() {
      _employees = empList;
      _filteredEmployees = empList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Employee Directory',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: MediaQuery.of(context).size.height * 0.025,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _isLoading
                ? Container(
                    margin: EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.02),
                    width: MediaQuery.of(context).size.height * 0.05,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.refresh_rounded,
                        color: Theme.of(context).primaryColor),
                    onPressed: _loadEmployees,
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.02, 
            MediaQuery.of(context).size.height * 0.01, 
            MediaQuery.of(context).size.height * 0.02, 
            MediaQuery.of(context).size.height * 0.02),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _isSearchFocused ? Colors.white : Colors.grey[50],
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.02),
                border: Border.all(
                  color: _isSearchFocused
                      ? Theme.of(context).primaryColor
                      : Colors.grey[200]!,
                  width: 2,
                ),
                boxShadow: _isSearchFocused
                    ? [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  setState(() => _isSearchFocused = hasFocus);
                },
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding:  EdgeInsets.all(MediaQuery.of(context).size.height * 0.016),
                      child: Icon(
                        Icons.search_rounded,
                        color: _isSearchFocused
                            ? Theme.of(context).primaryColor
                            : Colors.grey[400],
                        size: MediaQuery.of(context).size.height * 0.035,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterEmployees,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search employees...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.018),
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        child: IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterEmployees('');
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.02,
                          height: MediaQuery.of(context).size.height * 0.02,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          'Loading employees...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : _filteredEmployees.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_off_rounded,
                              size: MediaQuery.of(context).size.height * 0.035,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            Text(
                              'No employees found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: MediaQuery.of(context).size.height * 0.022,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.016),
                            Text(
                              'Try adjusting your search',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: MediaQuery.of(context).size.height * 0.022,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                        itemCount: _filteredEmployees.length,
                        itemBuilder: (context, index) {
                          final employee = _filteredEmployees[index];
                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeOutQuad,
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'employee_$employee',
                              child: Material(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.02),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.02),
                                    onTap: () => _navigateToAttendancePage(employee),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.height * 0.02, 
                                          vertical: MediaQuery.of(context).size.height * 0.02),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.height * 0.07,
                                            height: MediaQuery.of(context).size.height * 0.07,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                employee[0].toUpperCase(),
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: MediaQuery.of(context).size.height * 0.025,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: MediaQuery.of(context).size.height * 0.02),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  employee,
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.height * 0.02,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                                                Text(
                                                  'Tap to mark attendance',
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.height * 0.015,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: MediaQuery.of(context).size.height * 0.025,
                                            color: Colors.grey[400],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _filterEmployees(String query) {
    setState(() {
      _filteredEmployees = _employees.where((employee) {
        return employee.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _navigateToAttendancePage(String employeeEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetAttendance(
          employeeEmail: employeeEmail,
          employees: _employees,
        ),
      ),
    );
  }
}