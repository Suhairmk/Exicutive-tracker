import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/Screens/result.dart';
import 'package:tracker/provider/provider.dart';

class TargetDeailsView extends StatefulWidget {
  const TargetDeailsView({super.key, required this.index});
  final index;
  @override
  State<TargetDeailsView> createState() => _TargetDeailsViewState();
}

class _TargetDeailsViewState extends State<TargetDeailsView> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(
      context,
    );
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final index = widget.index;
    return Container(
      width: width - 80,
      height: 280,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                provider.destination[index].name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Text('Location: ' + provider.destination[index].location)
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Contact: ' + provider.destination[index].contactNumber),
                IconButton(
                    onPressed: () {
                      provider.makePhoneCall(
                          provider.destination[index].contactNumber);
                    },
                    icon: Icon(
                      Icons.phone,
                      color: Colors.blue,
                    )),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text('Time: ' + provider.destination[index].scheduledTime)
              ],
            ),
            SizedBox(
              height: 35,
            ),
            provider.destination[index].status == 0
                ? Container(
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
                                        destId: provider
                                            .destination[index].destinationId,
                                      )));
                        },
                        child: Text('Visit')),
                  )
                : Text(
                    'Visited',
                    style: TextStyle(
                        color: Colors.cyan, fontWeight: FontWeight.bold),
                  )
          ],
        ),
      ),
    );
  }
}
