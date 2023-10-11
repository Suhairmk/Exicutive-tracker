import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/Screens/Dashboard.dart';
import 'package:tracker/Screens/targetList.dart';
import 'package:tracker/Screens/pending.dart';
import 'package:tracker/Screens/visitedScreen.dart';
import 'package:tracker/controller/drawer.dart';
import 'package:tracker/provider/provider.dart';

class HomeController extends StatefulWidget {
  const HomeController({Key? key, required this.index}) : super(key: key);
  final index;
  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int _currentIndex = 0; // Index for the selected tab
  final List<Widget> _children = [
    TargetList(),
    PendingScreen(),
    VisitedScreen(),
  ]; // List of screens

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    _currentIndex = widget.index;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
            return false;
          },
          child: IndexedStack(
            index: _currentIndex,
            children: _children,
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Targets',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pending),
                label: 'Pending',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Visited',
              ),
            ],
            backgroundColor:
                Colors.cyan[400], // Change this to the desired color
            selectedItemColor: Color.fromARGB(250, 18, 17, 17),
            unselectedItemColor: const Color.fromARGB(203, 255, 255, 255),
          ),
        ));
  }
}
