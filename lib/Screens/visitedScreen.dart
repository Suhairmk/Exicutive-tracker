import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tracker/Screens/Dashboard.dart';
import 'package:tracker/provider/provider.dart';

class VisitedScreen extends StatefulWidget {
  const VisitedScreen({Key? key});

  @override
  State<VisitedScreen> createState() => _VisitedScreenState();
}

class _VisitedScreenState extends State<VisitedScreen> {
  late DateTime _selectedDate;
  late DateTime _today;
  bool _showCalendar = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _today = DateTime.now();
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.destination.clear();
    provider.getTargetList(_selectedDate);
  }

  void _toggleCalendar() {
    setState(() {
      _showCalendar = !_showCalendar;
    });
  }

  void _decreaseDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.destination.clear();
      provider.getTargetList(_selectedDate);
    });
  }

  void _increaseDate() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.destination.clear();
      provider.getTargetList(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Visited',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: () async {
          // Handle the back button press as needed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
          return false;
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Left button
                ElevatedButton(
                  onPressed: _decreaseDate,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Background color
                  ),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black, // Arrow color
                  ),
                ),
                // Display the selected date
                GestureDetector(
                  onTap: _toggleCalendar,
                  child: Text(
                    _selectedDate.toString().substring(0, 10),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Right button (conditionally displayed)
//if (!_selectedDate.isAtSameMomentAs(_today))
                _selectedDate != _today
                    ? ElevatedButton(
                        onPressed: _increaseDate,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, // Background color
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black, // Arrow color
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 20),
            if (_showCalendar)
              // Calendar widget (conditionally displayed)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showCalendar = false;
                  });
                },
                child: Container(
                  height: 600,
                  color: Colors.transparent, // Transparent background
                  child: TableCalendar(
                    calendarFormat: CalendarFormat.month,
                    focusedDay: _selectedDate,
                    firstDay: DateTime(2023, 1, 1), // Define your first day
                    lastDay: DateTime(2023, 12, 31), // Define your last day
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                        _showCalendar = false;
                        provider.destination.clear();
                        provider.getTargetList(_selectedDate);
                      });
                    },
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.destination.isEmpty ||
                        provider.destination.every((item) => item.status != 1)
                    ? 1 // If no data or all items have status != 1, display 1 item.
                    : provider.destination
                        .where((item) => item.status == 1)
                        .length,
                itemBuilder: (BuildContext context, int index) {
                  if (provider.destination.isEmpty ||
                      provider.destination.every((item) => item.status != 1)) {
                    return Center(
                      child: Text(
                        'Not Visited',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    );
                  }

                  // Filter the list to only include items with status == 1.
                  final filteredList = provider.destination
                      .where((item) => item.status == 1)
                      .toList();

                  // Display items from the filtered list.
                  final item = filteredList[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 25,
                        right: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                item.scheduledTime,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: item.status == 1
                                      ? Colors.green
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                right: 20,
                                bottom: 10,
                                top: 10,
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  // Handle the button press here
                                  provider.getpreviewData(
                                      context, item.destinationId);
                                },
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.cyan, // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        6), // Border radius
                                  ),
                                  side: BorderSide(
                                      color: Colors.cyan), // Outline color
                                ),
                                child: Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.cyan, // Text color
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
