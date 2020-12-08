import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/priority.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'package:task_manager/app/ui/widgets/itemview/custom_list_tile.dart';
import 'package:task_manager/app/ui/widgets/itemview/item_selection_view.dart';

class PrioritySelectionPage extends StatefulWidget {
  final Task task;

  const PrioritySelectionPage({@required this.task});

  @override
  _PrioritySelectionPageState createState() => _PrioritySelectionPageState();
}

class _PrioritySelectionPageState extends State<PrioritySelectionPage> {
  bool _selectedNone;

  @override
  void initState() {
    _selectedNone = widget.task.priority == null ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildTitleRow(),
            _buildNoneItem(),
            _buildPriorities(),
          ],
        ));
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_rounded)),
        SizedBox(width: 25),
        Text(AppStrings.priority,
            style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildNoneItem() {
    return CustomListTle(
      onTap: () {
        setState(() {
          widget.task.priority = null;
          _selectedNone = true;
        });
      },
      title: Text(AppStrings.noneItem),
      selectedTrailing: Icon(Icons.check),
      selectedColor: Theme.of(context).hoverColor,
      selected: _selectedNone,
      selectedTitle: Text(
        AppStrings.noneItem,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorDark),
      ),
    );
  }

  Widget _buildPriorities() {
    List<EPriority> priorities = EPriority.values;
    return Expanded(
        child: ListView.builder(
      itemCount: priorities.length,
      itemBuilder: (_, index) => _buildPriorityItem(
        priorities[index],
      ),
    ));
  }

  Widget _buildPriorityItem(EPriority priority) {
    return ItemSelection(
        onTap: () {
          setState(() {
            widget.task.priority = priority;
            _selectedNone = false;
          });
          Navigator.of(context).pop();
        },
        title: EPriorityUtil.fromEnumToString(priority),
        selected: widget.task.priority == null
            ? false
            : widget.task.priority == priority);
  }

/*Widget _buildPriorityItem(EPriority priority) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: CustomListTle(
        onTap: () {
          setState(() {
            widget.task.priority = priority;
            _selectedNone = false;
          });
        },
        selectedTitle: Text(EPriorityUtil.fromEnumToString(priority),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark)),
        title: Text(EPriorityUtil.fromEnumToString(priority)),
        selected: widget.task.priority == null
            ? false
            : widget.task.priority == priority,
        selectedColor: Theme.of(context).hoverColor,
        selectedTrailing: Icon(Icons.check),
      ),
    );
  }*/
}
