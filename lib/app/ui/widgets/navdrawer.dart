import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/app/resources/page_routes.dart';
import 'package:task_manager/app/ui/pages/categories_page.dart';
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
            onTap: () => {
              Navigator.pushReplacementNamed(context, PageRoutes.categories),
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Today'),
            onTap: () => {
              Navigator.pushReplacementNamed(context, PageRoutes.today),
            },
          ),
          ListTile(
            leading: Icon(Icons.skip_next),
            title: Text('Tomorrow'),
            onTap: () => {
              Navigator.pushReplacementNamed(context, PageRoutes.tomorrow),
            },
          ),
          ListTile(
            leading: Icon(Icons.next_week_outlined),
            title: Text('The next week'),
            onTap: () => {
              Navigator.pushReplacementNamed(context, PageRoutes.nextWeek),
            },
          ),
          ListTile(
            leading: Icon(Icons.next_plan),
            title: Text("Planned"),
            onTap: () => {
              Navigator.pushReplacementNamed(context, PageRoutes.planned),
            },
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Gone'),
            onTap: () => {
              Navigator.pushReplacementNamed(context, PageRoutes.gone),
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_day),
            title: Text('All tasks'),
            onTap: () => {
              Navigator.pushReplacementNamed(context, PageRoutes.allTasks),
            },
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
