import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) {
            FontWeight fontWeight = index % 2 == 0 ? FontWeight.bold : null;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text("B"),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text("bla bla",
                      style: TextStyle(
                          color: Colors.black, fontWeight: fontWeight)),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text("3 apr",
                      style: TextStyle(
                          color: Colors.black, fontWeight: fontWeight))
                ],
              ),
              subtitle: Text(
                "Bla bla bla bla bla bla bla bla bla bla bla",
                style: TextStyle(color: Colors.black, fontWeight: fontWeight),
              ),
            );
          }),
    );
  }
}
