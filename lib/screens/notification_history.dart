import 'package:flutter/material.dart';

class NotificationHistoryPage extends StatelessWidget {
  final List<String> history;

  const NotificationHistoryPage({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📜 Notification History")),
      body: history.isEmpty
          ? Center(child: Text("No notifications received yet."))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text(history[index]),
                  ),
                );
              },
            ),
    );
  }
}
