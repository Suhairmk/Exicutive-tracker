import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/provider/provider.dart';
import 'package:flutter/services.dart';

class AddTarget extends StatefulWidget {
  const AddTarget({super.key});

  @override
  State<AddTarget> createState() => _AddTargetState();
}

class _AddTargetState extends State<AddTarget> {
  TextEditingController targetName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController phone = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;

          selectedTime = pickedTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width - 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          // Add your custom widgets here

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  Select Date and Time',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 150,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.black26,
                          width:  1.5), // Half of the height to create curved edges
                      // Change the color as needed
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          _selectDateAndTime(context);
                        },
                        child: Text(
                          "${selectedDate.toLocal()},".split(' ')[0] +
                              ', ' +
                              '${selectedTime.format(context)}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 8),
          TextFormField(
            controller: targetName,
            decoration: InputDecoration(
                labelText: 'Target name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: location,
            decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),

          SizedBox(
            height: 25,
          ),

          Container(
            height: 35,
            width: MediaQuery.of(context).size.width - 100,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.cyan),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Customize the border radius
                  ),
                ),
              ),
              child: Text(
                'Add',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                provider.addTargetData(targetName.text, location.text,
                    phone.text, context, selectedDate, selectedTime);
                //targetName.clear();
                //location.clear();
                //phone.clear();
              },
            ),
          )
        ],
      ),
    );
  }
}
