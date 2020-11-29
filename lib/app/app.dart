import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/app/api/api_client.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'package:task_manager/app/ui/pages/tasks_page.dart';

import 'blocks/edit_page_block.dart';
import 'blocks/task_block.dart';

class App extends StatelessWidget {
  void _restrictRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _restrictRotation();
    return BlocProvider(
        blocs: [
          Bloc(
            (i) => TaskPageBlock(i.getDependency<ApiClient>()),
            singleton: false,
          ),
          Bloc(
            (i) => EditPageBlock(i.getDependency<ApiClient>()),
            singleton: false,
          ),
        ],
        dependencies: [
          Dependency((i) => ApiClient(), singleton: true),
        ],
        child: MaterialApp(
          title: AppStrings.appName,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            backgroundColor: Colors.blueGrey.shade50,
            selectedRowColor: Colors.yellow.shade100,
            unselectedWidgetColor: Colors.teal,
            primaryColorDark: Colors.teal.shade800,
            highlightColor: Colors.teal.shade100
          ),
          home: TasksPage(),
        ));
  }
}
