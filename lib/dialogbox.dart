import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, {required result}) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    alignment: Alignment.center,
    content: Text(result!,
        textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
    actionsAlignment: MainAxisAlignment.spaceAround,
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
