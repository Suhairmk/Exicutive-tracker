import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/provider/provider.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.visitId});
  final visitId;
  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool isEditing = false;
  TextEditingController textController = TextEditingController();

  String savedText = 'your text';
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    final provider = Provider.of<AppProvider>(context, listen: false);
    savedText = provider.preview!['remarks'];
    textController.text = savedText;
    //  });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final provider = Provider.of<AppProvider>(context);
    int visitId = widget.visitId;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Preview',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 120,
                            width: 150,
                            color: Colors.black12,
                            child: Image.network(
                              provider.preview!['meter_img'],
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text('Meter Image')
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 120,
                            width: 150,
                            color: Colors.black12,
                            child: Image.network(
                              provider.preview!['dest_img'],
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text('Target Image')
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(isEditing ? null : Icons.edit),
                        onPressed: () {
                          setState(() {
                            if (isEditing == false) {
                              // Save the edited text
                              savedText = textController.text;
                            }
                            isEditing = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isEditing
                            ? Container(
                                height: height - 450,
                                width: width - 20,
                                color: Colors.cyan[50],
                                child: TextField(
                                  controller: textController,
                                  keyboardType: TextInputType.text,
                                  // initialValue: savedText,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                      labelText: 'Enter here',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                ),
                              )
                            : Container(
                                height: height - 450,
                                width: width - 20,
                                color: Colors.cyan[50],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(savedText),
                                )),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    if (isEditing)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Save the edited text
                            savedText = textController.text;
                            isEditing = false;
                            provider.updateRemarks(savedText, visitId, context);
                          });
                        },
                        child: Text("Submit"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.cyan,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
