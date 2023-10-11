import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tracker/Screens/Dashboard.dart';
import 'package:tracker/Screens/preview.dart';
import 'package:tracker/controller/addTarget.dart';
import 'package:tracker/Screens/result.dart';
import 'package:tracker/controller/targetDetails.dart';
import 'package:tracker/provider/provider.dart';

class TargetList extends StatefulWidget {
  const TargetList({Key? key}) : super(key: key);

  @override
  State<TargetList> createState() => _TargetListState();
}

class _TargetListState extends State<TargetList> {
  DateTime _selectedDate = DateTime.now(); // Initialize with the current date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        final provider = Provider.of<AppProvider>(context, listen: false);
        provider.destination.clear();
        provider.getTargetList(_selectedDate);
      });
    }
  }

//to show the addTarget window
  Future<void> showAddTargetWindow(
      BuildContext context, content, imagecolor, headding) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          contentPadding: EdgeInsets.all(15),
          insetPadding: EdgeInsets.all(10),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(headding),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image(
                  image: AssetImage(
                    'assets/images/iconClose.png',
                  ),
                  color: imagecolor,
                ),
              ),
            ],
          ),
          content: content,
          // AddTarget(),
        );
      },
    );
  }

  @override
  void initState() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.getTargetList(_selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(
      context,
    );
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Targets',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
          return false;
        },
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                    ),
                    onPressed: () =>
                        _selectDate(context), // Trigger date picker
                  ),
                  // Display selected date
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Text(
                      "${_selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 15,
                      color: Colors.black,
                    ),
                    onPressed: () =>
                        _selectDate(context), // Trigger date picker
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: width - 360,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showAddTargetWindow(
                          context, AddTarget(), null, 'Add Destination');
                    },
                    child: Text('Add Target'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.cyan, elevation: 4),
                  ),
                ],
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: provider.destination.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        showAddTargetWindow(
                            context,
                            TargetDeailsView(
                              index: index,
                            ),
                            Colors.green,
                            'Details');
                      },
                      child: Card(
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
                                    provider.destination[index].name,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    provider.destination[index].scheduledTime,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: provider.destination[index]
                                                    .status ==
                                                1
                                            ? Colors.green
                                            : Colors.black),
                                  ),
                                ],
                              ),
                              provider.destination[index].status == 1
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        right: 10,
                                        bottom: 10,
                                        top: 10,
                                      ),
                                      child: OutlinedButton(
  onPressed: () {
    // Handle the button press here
    provider.getpreviewData(
        context,
        provider.destination[index]
            .destinationId);
  },
  style: OutlinedButton.styleFrom(
    primary: Colors.cyan, // Text color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6), // Border radius
    ),
    side: BorderSide(color: Colors.cyan), // Outline color
  ),
  child: Text(
    'Details',
    style: TextStyle(
      fontSize: 16,
      color: Colors.cyan, // Text color
    ),
  ),
))

                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        right: 10,
                                        bottom: 10,
                                        top: 10,
                                      ),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResultScreen(
                                                          destId: provider
                                                              .destination[
                                                                  index]
                                                              .destinationId,
                                                        )));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Colors.cyan, // Background color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      6), // Border radius
                                            ),
                                          ),
                                          child: Text('   Visit   ')),
                                    )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Add other widgets and content below
            ],
          ),
        ),
      ),
    );
  }
}
