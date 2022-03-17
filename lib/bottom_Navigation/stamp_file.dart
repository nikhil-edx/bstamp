// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class StampClass extends StatefulWidget {
  const StampClass({Key key}) : super(key: key);

  @override
  _StampClassState createState() => _StampClassState();
}

class _StampClassState extends State<StampClass> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Stamp your document",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    // ignore: use_full_hex_values_for_flutter_colors
                    color: Color(0xffff005397))),
            const SizedBox(
              height: 20,
            ),
            const Text(
                "You are out of stamp , Please add more in order to Continue",
                style: TextStyle(
                    fontSize: 12,
                    // fontWeight: FontWeight.w900,
                    // ignore: use_full_hex_values_for_flutter_colors
                    color: Color(0xffff005397))),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // ignore: use_full_hex_values_for_flutter_colors
                primary: const Color(0xffff073D83),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              onPressed: () {
                setState(() {
                  //_openFileExplorer();
                });
              },
              child: const Text("Add Stamp"),
            )
          ],
        ),
      ),
    );
  }
}
