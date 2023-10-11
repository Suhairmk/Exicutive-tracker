import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/Screens/account.dart';

import 'package:tracker/Screens/changepassowrd.dart';
import 'package:tracker/provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  final Function() onLogoutPressed;
  final name;
  CustomDrawer({required this.onLogoutPressed, required this.name});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
 

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    String name = widget.name;
    return Container(
      width: 250,
      child: Drawer(
        shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 244, 245, 246),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Account()));
                },
                child: DrawerHeader(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black12,
                        backgroundImage: provider.imagedata != null
                            ? NetworkImage(provider.imagedata!)
                            : null,
                        radius: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          name.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(217, 0, 187, 212),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                onTap: () {
                  // Handle Home navigation
                },
              ),
              ListTile(
                leading: Icon(Icons.note),
                title: Text('About'),
                onTap: () {
                  // Handle Home navigation
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                onTap: () {
                  // Handle Home navigation
                },
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: widget.onLogoutPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
