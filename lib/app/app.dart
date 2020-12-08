import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/app/api/api_client.dart';
import 'package:task_manager/app/resources/page_routes.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'package:task_manager/app/resources/theme/colors/light_colors.dart';
import 'package:task_manager/app/ui/pages/categories_page.dart';
import 'package:task_manager/app/ui/pages/tasks_page.dart';
import 'package:task_manager/util/task_page_mode.dart';

import 'blocks/categories_page_block.dart';
import 'blocks/task_block.dart';

class App extends StatelessWidget {
  void _restrictRotation() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: LightColors.kLightYellow,
      // navigation bar color
      statusBarColor: Color(0xffffb969), // status bar color
    ));
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
            (i) => CategoriesPageBlock(i.getDependency<ApiClient>()),
            singleton: false,
          ),
        ],
        dependencies: [
          Dependency((i) => ApiClient(), singleton: true),
        ],
        child: MaterialApp(
          title: AppStrings.appName,
          theme: ThemeData(
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: LightColors.kDarkBlue,
                    displayColor: LightColors.kDarkBlue,
                    fontFamily: 'Poppins',
                  ),
              iconTheme: IconThemeData(color: LightColors.kDarkBlue),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              backgroundColor: LightColors.kLightYellow,
              primaryColor: LightColors.kDarkYellow,
              selectedRowColor: Colors.yellow.shade100,
              unselectedWidgetColor: Colors.brown,
              primarySwatch: Colors.brown),
          home: TasksPage(pageMode: EMode.TODAY),
          routes: {
            PageRoutes.today: (context) => TasksPage(pageMode: EMode.TODAY),
            PageRoutes.tomorrow: (context) =>
                TasksPage(pageMode: EMode.TOMORROW),
            PageRoutes.nextWeek: (context) =>
                TasksPage(pageMode: EMode.NEXT_WEEK),
            PageRoutes.planned: (context) => TasksPage(pageMode: EMode.PLANNED),
            PageRoutes.gone: (context) => TasksPage(pageMode: EMode.GONE),
            PageRoutes.allTasks: (context) =>
                TasksPage(pageMode: EMode.ALL_TASKS),
            PageRoutes.categories: (context) => CategoryPage(),
          },
        ));
  }
}
