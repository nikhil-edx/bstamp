
  // void showSuccess(BuildContext context, String message,
  //     {bool shouldDismiss = true}) {
  //   Timer.run(() => _showAlert(
  //       context,
  //       message,
  //       // Colors.blue,
  //       const Color(0xFFE2F8FF),
  //       CupertinoIcons.check_mark_circled_solid,
  //       const Color(0xffff073D83),
  //       //Color.fromRGBO(91, 180, 107, 1),
  //       shouldDismiss));
  // }

  // void showInfo(BuildContext context, String message,
  //     {bool shouldDismiss = true}) {
  //   Timer.run(() => _showAlert(context, message, Color(0xFFE7EDFB),
  //       Icons.info_outline, Color.fromRGBO(54, 105, 214, 1), shouldDismiss));
  // }

  // void showError(BuildContext context, String message,
  //     {bool shouldDismiss = true}) {
  //   Timer.run(() => _showAlert(context, message, const Color(0xFFFDE2E1),
  //       Icons.error_outline, Colors.red, shouldDismiss));
  // }

  // void _showAlert(BuildContext context, String message, Color color,
  //     IconData icon, Color iconColor, bool shouldDismiss) {
  //   showGeneralDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       barrierLabel:
  //           MaterialLocalizations.of(context).modalBarrierDismissLabel,
  //       transitionDuration: const Duration(milliseconds: 200),
  //       pageBuilder: (BuildContext buildContext, Animation animation,
  //           Animation secondaryAnimation) {
  //         if (shouldDismiss) {
  //           Future.delayed(const Duration(seconds: 2), () {
  //             Navigator.of(context, rootNavigator: true).pop();
  //           });
  //         }
  //         return Material(
  //           type: MaterialType.transparency,
  //           child: WillPopScope(
  //             onWillPop: () async => false,
  //             child: Padding(
  //               padding:
  //                   const EdgeInsets.only(bottom: 100, right: 50, left: 50),
  //               child: Align(
  //                 alignment: Alignment.bottomLeft,
  //                 child: Container(
  //                     decoration: BoxDecoration(
  //                         border: Border.all(color: iconColor, width: 1),
  //                         shape: BoxShape.rectangle,
  //                         borderRadius: const BorderRadius.vertical(
  //                             top: Radius.circular(10),
  //                             bottom: Radius.circular(10)),
  //                         color: Colors.white),
  //                     width: MediaQuery.of(context).size.width / 5,
  //                     height: MediaQuery.of(context).size.height / 10,
  //                     padding: const EdgeInsets.all(5),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         Icon(
  //                           icon,
  //                           size: 30,
  //                           color: iconColor,
  //                         ),
  //                         const SizedBox(
  //                           width: 5,
  //                         ),
  //                         Flexible(
  //                           child: Text(
  //                             message,
  //                             style: const TextStyle(
  //                                 decoration: TextDecoration.none,
  //                                 color: Colors.black),
  //                           ),
  //                         )
  //                       ],
  //                     )),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }