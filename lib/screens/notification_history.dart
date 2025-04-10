import 'package:flutter/material.dart';

class NotificationHistoryPage extends StatelessWidget {
  final List<String> history;
  final List<bool> readStatus;
  final VoidCallback onMarkAllRead;

  const NotificationHistoryPage({
    Key? key,
    required this.history,
    required this.readStatus,
    required this.onMarkAllRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📜 Notification History"),
        actions: [
          TextButton.icon(
            onPressed: onMarkAllRead,
            icon: Icon(Icons.done_all, color: Colors.white),
            label: Text("Mark All Read", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: history.isEmpty
          ? Center(child: Text("No notifications received yet."))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  color: readStatus[index] ? Colors.grey[200] : Colors.white,
                  child: ListTile(
                    leading: Icon(
                      readStatus[index]
                          ? Icons.mark_email_read
                          : Icons.mark_email_unread,
                      color:
                          readStatus[index] ? Colors.green : Colors.redAccent,
                    ),
                    title: Text(
                      history[index],
                      style: TextStyle(
                        fontWeight: readStatus[index]
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: readStatus[index] ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
