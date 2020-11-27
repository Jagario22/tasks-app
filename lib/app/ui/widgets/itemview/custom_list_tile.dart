import 'package:flutter/material.dart';

class CustomListTle extends StatelessWidget {
  final bool selected;
  final Function onTap;
  final Widget title;
  final Color selectedColor;
  final Icon selectedIcon;
  final Widget selectedTitle;

  const CustomListTle({
    Key key,
    this.selected,
    this.onTap,
    this.title,
    this.selectedColor,
    this.selectedIcon,
    this.selectedTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selected ? _buildSelectedListTile(context) : buildListTile(context);
  }

  Widget _buildSelectedListTile(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      title: selectedTitle == null ? title : selectedTitle,
      selected: true,
      selectedTileColor: selectedColor,
      trailing: selectedIcon,
    );
  }

  Widget buildListTile(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      title: title,
      selected: false,
    );
  }
}
