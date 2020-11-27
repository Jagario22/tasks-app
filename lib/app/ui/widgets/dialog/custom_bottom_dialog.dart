import 'package:flutter/material.dart';

class CustomBottomDialog extends StatelessWidget {
  final String message;

  const CustomBottomDialog({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.0,
      color: Color(0xFF727C8E).withOpacity(.5),
      type: MaterialType.canvas,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.symmetric(horizontal: 16,
                      vertical: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(6)
                      ),
                      color: Color(0xff36B37E)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff58FCB4)),
                        child: Icon(
                          Icons.done,
                          size: 15,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.white,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text("OK",
                          style: TextStyle(
                              color: Color(
                                0xff58FCB4,
                              ),
                              fontSize: 12))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

}