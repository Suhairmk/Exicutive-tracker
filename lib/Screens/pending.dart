import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/Screens/Dashboard.dart';
import 'package:tracker/Screens/result.dart';
import 'package:tracker/model/model.dart';

import 'package:tracker/provider/provider.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<AppProvider>(context, listen: false);
      //call pendingList api
      provider.getPendingist();
    });
  }

  Future<void> showPendingTargetDetails(
      BuildContext context, phone, name, time, date, location, id) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
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
              Text('Details'),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image(
                  image: AssetImage(
                    'assets/images/iconClose.png',
                  ),
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Container(
            width: width - 80,
            height: 280,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [Text('Location: ' + location)],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Contact: ' + phone),
                      IconButton(
                          onPressed: () {
                            provider.makePhoneCall(phone);
                          },
                          icon: Icon(
                            Icons.phone,
                            color: Colors.blue,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [Text('Time: ' + time)],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [Text('Date: ' + date)],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    width: 200,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.cyan)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                        destId: id,
                                      )));
                        },
                        child: Text('Visit')),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    provider.pendingList
        .sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
    final groupedTargets = <String, List<Pending>>{};
    for (final target in provider.pendingList) {
      final dateKey = target.scheduledDate
          .toString(); // Convert date to string for grouping
      groupedTargets[dateKey] = [...(groupedTargets[dateKey] ?? []), target];
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Pending',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop:() async {
           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()));
            return false;
          }, 
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: groupedTargets.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dateKey = groupedTargets.keys.toList()[index];
                    final targets = groupedTargets[dateKey]!;
      
                    return Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10, left: 25, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(height: 2),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  dateKey,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(height: 2),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: targets.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final target = targets[index];
      
                                  return InkWell(
                                    onTap: () {
                                      showPendingTargetDetails(
                                          context,
                                          target.contactNumber,
                                          target.name,
                                          target.scheduledTime,
                                          target.scheduledDate,
                                          target.location,
                                          target.destinationId);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text(target.name)),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.cyan),
                                          ),
                                          onPressed: () {
                                            // Add the logic for the "Visit" button
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResultScreen(
                                                          destId: target
                                                              .destinationId,
                                                        )));
                                          },
                                          child: Text('Visit'),
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
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
