import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/app/ui/pages/tasks_page.dart';
import 'package:task_manager/util/task_page_mode.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: _buildHeader(context),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          ListTile(
            leading: Icon(Icons.category_outlined),
            title: Text("Categories"),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Today'),
            onTap: () => {Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (_) => TasksPage(pageMode: EMode.TODAY_TASKS),
              ),
            )},
          ),
          ListTile(
            leading: Icon(Icons.skip_next),
            title: Text('Tomorrow'),
            onTap: () => {Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (_) => TasksPage(pageMode: EMode.TOMORROW_TASKS),
              ),
            )},
          ),
          ListTile(
            leading: Icon(Icons.next_week_outlined),
            title: Text('The next week'),
            onTap: () => {Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (_) => TasksPage(pageMode: EMode.THE_NEXT_WEEK_TASKS),
              ),
            )},
          ),
          ListTile(
            leading: Icon(Icons.next_plan),
            title: Text("Planned"),
            onTap: () => {Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (_) => TasksPage(pageMode: EMode.PLANNED),
              ),
            )},
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Gone'),
            onTap: () => {Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (_) => TasksPage(pageMode: EMode.GONE),
              ),
            )},
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_day),
            title: Text('All tasks'),
            onTap: () => {Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (_) => TasksPage(pageMode: EMode.ALL_TASKS),
              ),
            )},
          ),

        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          DateFormat("EEEE").format(DateTime.now()),
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        Text(
          DateFormat("dd MMMM").format(DateTime.now()),
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ],
    );
  }
}
