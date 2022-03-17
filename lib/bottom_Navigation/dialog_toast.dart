import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dailog_toast {
  Future<Null> showAlertDialog(BuildContext context) async {
    return await showDialog<Null>(
        barrierColor: Colors.transparent.withOpacity(0.2),
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(
                    //semanticsLabel: "Loading...",
                    ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              )),
            ],
          );
        });
  }

  void showSuccess(BuildContext context, String message,
      {bool shouldDismiss = true}) {
    Timer.run(() => showAlert(
        context,
        message,
        // Colors.blue,
        const Color(0xFFE2F8FF),
        CupertinoIcons.check_mark_circled_solid,
        const Color(0xffff073D83),
        //Color.fromRGBO(91, 180, 107, 1),
        shouldDismiss));
  }

  void showError(BuildContext context, String message,
      {bool shouldDismiss = true}) {
    Timer.run(() => showAlert(context, message, const Color(0xFFFDE2E1),
        Icons.error_outline, Colors.red, shouldDismiss));
  }

  showAlert(BuildContext context, String message, Color color, IconData icon,
      Color iconColor, bool shouldDismiss) {
    showGeneralDialog(
        barrierColor: Colors.transparent,
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          if (shouldDismiss) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context, rootNavigator: true).pop();
            });
          }
          return Container(
            height: 100,
            width: 200,
            child: Material(
              // color: Color.fromARGB(252, 177, 176, 176).withOpacity(1.0),
              type: MaterialType.transparency,
              child: WillPopScope(
                onWillPop: () async => false,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 100, right: 50, left: 50),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: iconColor, width: 1),
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                                bottom: Radius.circular(10)),
                            color: Colors.white),
                        width: MediaQuery.of(context).size.width / 7,
                        height: MediaQuery.of(context).size.height / 15,
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              icon,
                              size: 30,
                              color: iconColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                message,
                                style: const TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
