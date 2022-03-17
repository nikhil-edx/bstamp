import 'dart:async';
import 'package:bStamp/bottom_Navigation/elctronic_signature.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bottom_Navigation/account_file.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'bottom_Navigation/add_stamp.dart';
import 'bottom_Navigation/browser_details.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'edexa_login.dart';
import 'package:flutter/foundation.dart';

import 'search_page.dart';

// ignore: camel_case_types, must_be_immutable
class TabBarScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  int selectedPage;

  var data;
  // ignore: prefer_typing_uninitialized_variables
  final status;
  TabBarScreen(
      {Key key,
      @required this.data,
      @required this.status,
      @required this.selectedPage})
      : super(key: key);

  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

// ignore: camel_case_types
class _TabBarScreenState extends State<TabBarScreen> {
  TabController tabController;
  ConnectivityResult _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _login();

    // ignore: unnecessary_new

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      _connectionStatus = result;
    } on PlatformException catch (e) {
      //   print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  String token;
  _login() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('token');
    });

    if (widget.status != null && widget.status == "wLogin") {
    } else {
      checkIsLogin();
    }
  }

  checkIsLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    if (token != null && token != '') {
      // ignore: avoid_print
      //  print(token);
    } else {
      // ignore: avoid_print
      //  print("something went wrong");

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(), //edexaLogin() // LoginPage(),
          ));
    }
  }

  _networkerror() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 300,
          child: Image.asset("assets/Images/Network.png",
              height: 20, color: const Color(0xffff073d83) // Colors.grey,
              ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

//var a=MediaQuery.of(context).size.width / 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 1100, //MediaQuery.of(context).size.width / 1.5,
          child: Padding(
            // width: MediaQuery.of(context).size.width / 1.5,
            // height: MediaQuery.of(context).size.height / 1.5,
            padding: const EdgeInsets.only(right: 0, left: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100,
                  child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                      //  indicatorPadding: EdgeInsets.all(5),
                      // initialIndex:selectedPage,
                      controller: tabController,

                      indicator: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Color(0xFFDADCE0) //Colors.grey[200]
                          ),
                      tabs: [
                        Tab(
                          height: 65,
                        
                          iconMargin:
                              const EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/Images/stamp.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Add Stamp",
                                style: TextStyle(
                                    color: Color(0xFF868686),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Tab(
                          height: 65,
                          iconMargin:
                              const EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset("assets/Images/signature.png"),
                              const SizedBox(
                                width: 9,
                              ),
                              const Text(
                                "Electronic Signature",
                                style: TextStyle(
                                    color: Color(0xFF868686),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Tab(
                          height: 65,
                          // icon: Image.asset("assets/Images/browse.png"),
                          // text: "Browse",

                          child: Container(
                            height: 200,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/Images/browse.png"),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Browse",
                                  style: TextStyle(
                                    color: Color(0xFF868686),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          height: 65,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/Images/setting.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "My Account",
                                style: TextStyle(
                                    color: Color(0xFF868686),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Tab(
                          height: 65,
                          // iconMargin: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/Images/addstamp.png"),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "My Plan",
                                style: TextStyle(
                                    color: Color(0xFF868686),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Divider(),
                Container(
                  height: 2,
                  color: Color(0xFFDADCE0),
                  child: Container(),
                ),
                //  ),
                //  const Divider(),

                //  create widgets for each tab bar here
                _connectionStatus != ConnectivityResult.none
                    ? Flexible(
                        child: TabBarView(
                        children: [
                          const Addstamp(),
                          const Electronic_Signature(),
                          const DataTableExample(),
                          const Account(),
                          Center(
                              child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text:
                                    ' To know about the plans please view the ',
                                style: //GoogleFonts.portLligatSans(
                                    const TextStyle(
                                        fontSize: 18, color: Colors.grey
                                        //Color(0xffe46b10),
                                        ),
                                children: [
                                  TextSpan(
                                    text: ' web version',
                                    style: const TextStyle(
                                        // fontWeight: FontWeight.w900,
                                        color: Color(0xffff073D83),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'https://bstamp.edexa.com/account');
                                      },
                                  ),
                                ]),
                          )),
                        ],
                      ))
                    : Expanded(
                        child: TabBarView(
                          children: [
                            _networkerror(),
                            _networkerror(),
                            _networkerror(),
                            _networkerror(),
                            _networkerror(),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
