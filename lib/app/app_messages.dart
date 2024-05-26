import 'package:flutter/material.dart';
import 'package:puftel/main.dart';

typedef void OnYesClick();

class AppMessages {

  static quickNotify(BuildContext context, String content){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)),
    );
  }

  static notifyYesNo(BuildContext context, String title, String content,
      OnYesClick onYes
      ) {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text(content),
              ],
            ),
          ),
          actions: [
            new TextButton(
              child: new Text(MyApp.local.yes),
              onPressed: () {
                Navigator.of(context).pop();
                onYes.call();
              },
            ),
            new TextButton(
              child: new Text(MyApp.local.no),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static notify(BuildContext context, String title, String content) {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text(content),
              ],
            ),
          ),
          actions: [
            new TextButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}