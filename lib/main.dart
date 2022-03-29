// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bStamp/bottom_Navigation/appbar.dart';
import 'backend.dart';
import 'tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'login_screen.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  


  HttpOverrides.global = new MyHttpOverrides();
  runApp(MaterialApp(
          debugShowCheckedModeBanner: false, home: Main() //SearchPage(),
          )
      //   TabBarDemo(
      //   selectedPage: 0,
      //   status: null,
      // )

      );
}

class TabBarDemo extends StatefulWidget {
  int selectedPage;
  final status;

  TabBarDemo({Key key, @required this.status, @required this.selectedPage})
      : super(key: key);

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  var color = Colors.black, color1 = Colors.black;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  _connectivity();
    _getUserInfo();

    _login();
  }

  _login() {
    if (widget.status != null && widget.status == "wLogin") {
      updateAlbum();
    } else {
      checkIsLogin();
    }
  }

  _connectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {}
  }

  var username, email, profilePicture, name;

  String token;
  checkIsLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    if (token != null && token != '') {
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => edexaLogin() // LoginPage(),
              ));
    }
  }

  _getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      email = preferences.getString(
        'email',
      );
      name = preferences.getString(
        'name',
      );
      profilePicture = preferences.getString(
        'profilePicture',
      );
    });
  }

  var data, clientId, secretID;

  Future updateAlbum() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    clientId = preferences.getString('clientId');
    secretID = preferences.getString('secretId');

    var url = Uri.parse("https://${Backend.baseurl}/authenticate");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json",
        "client-id": "$clientId",
        "secret-key": "$secretID",
      },

      // ignore: missing_return
    ).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          // ignore: unused_local_variable
          var jsonResponse = json.decode(response.body);
          data = jsonResponse['data'];

          preferences.setString('email', jsonResponse['data']['email']);
          preferences.setString('username', jsonResponse['data']['username']);
          preferences.setString('token', jsonResponse['data']['token']);
          _getUserInfo();
        });
      } else {
        var errorMsg = json.decode(response.body);

        _dialog(2,
            "please enter Client id and secret id ,please click here to get them");
      }
    });
  }

  _dialog(type, desc) {
    return AwesomeDialog(
      useRootNavigator: false,
      context: context,
      dialogType: type == 2 ? DialogType.ERROR : DialogType.SUCCES,
      borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
      width: 380,
      buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: "User authentication failed",
      desc: desc,
      btnCancelColor: Colors.blueGrey,
      btnOkColor: Colors.blueGrey,
      //  btnCancelOnPress: () {},
      btnOkOnPress: () {
        launch("https://portal.io-world.com/apis/api-detail/api-explorer/38");
      },
    )..show();
  }

  void _showAlert(
    BuildContext context,
  ) {
    _getStampList();
    showGeneralDialog(
        useRootNavigator: false,
        barrierDismissible: false,
        context: context,
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return SizedBox(
            height: 400,
            width: 300,
            child: Material(
              type: MaterialType.transparency,
              child: WillPopScope(
                onWillPop: () async => false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, right: 10, left: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffff073D83), width: 1),
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                                bottom: Radius.circular(10)),
                            color: Colors.white),
                        width: 300, // MediaQuery.of(context).size.width / 4,
                        height: 410, //MediaQuery.of(context).size.height / 3,
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 0.5,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text:
                                          'This account is managed by edeXa .',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: ' Learn more',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF073D83),
                                              // Color(0xffe46b10),
                                              fontSize: 12),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launch("https://edexa.com/en/"
                                                  // 'https://edexa.com/en/terms-and-conditions/'
                                                  );
                                            },
                                        ),
                                      ]),
                                )
                                //  const Text(
                                //     "This account is managed by edeXa . Learn more")
                                ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                height: 100,
                                width: 100,
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundImage: NetworkImage(
                                    profilePicture,
                                  ), //AssetImage('assets/Images/images.jpg'),
                                )),
                            Center(
                                child: Text(
                              name,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(child: Text(email)),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width / 0.8,
                              child: ElevatedButton(
                                onPressed: () {
                                  launch(
                                      'https://accounts.io-world.com/profile');
                                },
                                child: Text(
                                    "       Manage your edeXa account      "),
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(2),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Color(0xffff073D83))),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width / 0.8,
                              child: OutlinedButton(
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => Dialog(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        child: SizedBox(
                                          width: 50,
                                          child: Wrap(
                                            children: [
                                              Wrap(
                                                children: [
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Color(
                                                                0xffff073D83), // Colors.red,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons
                                                            .error_outline_sharp,
                                                        color: Colors.white,
                                                        size: 40,
                                                      ),
                                                    ),
                                                  ),
                                                  //  const Divider(),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0),
                                                child: Wrap(
                                                  children: const [
                                                    Center(
                                                        child: Text(
                                                            'Are you sure ?')),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    OutlinedButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'Cancel'),
                                                        child: const Text(
                                                            'cancel')),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    OutlinedButton(
                                                      onPressed: () async {
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        prefs.remove('token');
                                                        prefs
                                                            .remove('secretId');
                                                        prefs
                                                            .remove('secretId');
                                                        prefs
                                                            .remove("viewType");
                                                        //  Navigator.pushNamed(context, "/");
                                                        // Navigator.of(context)
                                                        //     .maybePop();
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Main(),
                                                              //  ValidatePage(),
                                                              // SearchPage(), //edexaLogin()
                                                              //LoginPage(),
                                                            ));
                                                      },
                                                      child: const Text(
                                                        'Logout',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(("Logout"))),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width / 0.8,
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop();
                                  },
                                  child: Text(("Cancel"))),
                            ),
                            const Divider(),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: 'Privacy Policy ',
                                  style: //GoogleFonts.portLligatSans(
                                      const TextStyle(
                                          fontSize: 14, color: Colors.grey
                                          //Color(0xffe46b10),
                                          ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch(
                                          'https://edexa.com/en/privacy-policy/');
                                    },
                                  children: [
                                    const TextSpan(
                                      text: ' - ',
                                      style: TextStyle(
                                          // fontWeight: FontWeight.w900,
                                          //color: Color(0xFF073D83),
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          // color: Color(0xFF073D83),
                                          // Color(0xffe46b10),
                                          fontSize: 14),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launch(
                                              'https://edexa.com/en/terms-and-conditions/');
                                        },
                                    ),
                                  ]),
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

  _getStampList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');

    var url = Uri.parse("https://${Backend.baseurl}/user-profile");

    var response = await http.get(
      url,
      headers: <String, String>{
        //  HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: token
      },
    );
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = jsonDecode(response.body);
        // ignore: avoid_print

        preferences.setString('email', jsonResponse['data']['email']);
        preferences.setString('username', jsonResponse['data']['username']);
        preferences.setString(
            'name',
            jsonResponse['data']['first_name'] +
                jsonResponse['data']['last_name']);
        preferences.setString(
            'profilePicture', jsonResponse['data']['profilePic']);
        preferences.setString(
            "viewType", jsonResponse['data']['viewType'].toString());
        preferences.setString(
            "watermark", jsonResponse['data']['watermark'].toString());
        _getUserInfo();
      });
    } else {
      var jsonResponse = jsonDecode(response.body);

      // ignore: avoid_print

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) => DefaultTabController(
            initialIndex: widget.selectedPage,
            length: 5,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: TabBarScreen(
                selectedPage: 0,
                data: data,
                status: widget.status,
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                child: Container(
                  child: ListTile(
                      leading: const Text(
                        "edeXa - bStamp ©2022",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: '  Privacy  ',
                            style:
                                const TextStyle(fontSize: 14, color: Colors.grey
                                    //Color(0xffe46b10),
                                    ),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                launch('https://edexa.com/en/privacy-policy/');
                              },
                            children: [
                              TextSpan(
                                text: '  Terms ',
                                style: const TextStyle(
                                    // fontWeight: FontWeight.w900,
                                    color: Colors.grey, //Color(0xffff073D83),
                                    fontSize: 14),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(
                                        'https://edexa.com/en/terms-and-conditions/');
                                  },
                              ),
                              //temporary hide about dialog
                              // TextSpan(
                              //     text: '  About  ',
                              //     style: const TextStyle(
                              //         fontWeight: FontWeight.w400,
                              //         color:
                              //             Colors.grey, // Color(0xffff073D83),
                              //         // Color(0xffe46b10),
                              //         fontSize: 14),
                              //     recognizer: TapGestureRecognizer()
                              //       ..onTap = () {
                              //
                              //         // showAboutDialog(context);
                              //       }),
                            ]),
                      )),
                ),
              ),
            ),
          ),
        ));
  }

  showAboutDialog(BuildContext context) {
    Dialog alert = Dialog(
        // Color(0xFF40000000).withOpacity(0.1),
        child: Scrollbar(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: 520,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);

                      // Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.cancel))
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 25.0, left: 25.0, bottom: 10),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ListTile(
                          dense: true,
                          leading: Image.asset(
                            "assets/Images/bstamp_logo.png",
                            filterQuality: FilterQuality.medium,
                          ),
                          title: const Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: Text(
                              "bStamp Desktop Application",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            color: Color(0xFF073D83),
                          ),
                          title: Text(
                            "bStamp Desktop Application  is up to date",
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                              "Version 93.0.4577.82 (Official Build) (64-bit)",
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: ListTile(
                          dense: true,
                          title: Text("Get help with bStamp Desktop",
                              style: TextStyle(fontSize: 15)),
                          trailing: Icon(Icons.ios_share_outlined),
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: ListTile(
                          dense: true,
                          title: Text("Report an issue",
                              style: TextStyle(fontSize: 15)),
                          trailing: Icon(Icons.ios_share_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 0),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 20, top: 20),
                    child: Wrap(
                      children: [
                        const ListTile(
                          dense: true,
                          title: Text("edeXa bStamp",
                              style: TextStyle(fontSize: 15)),
                        ),
                        const Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, bottom: 10),
                          child: Text(
                              "Copyright 2022 edeXa . All rights reserved.",
                              style: TextStyle(fontSize: 15)),
                        ),
                        const ListTile(
                          dense: true,
                          title: Text(
                              "bStamp Desktop  is made possible by the Chromium open source project and other open source software.",
                              style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10),
                          child: RichText(
                            text: TextSpan(
                              text: 'Terms of service ',
                              style: const TextStyle(
                                  // fontWeight: FontWeight.w900,
                                  color: Color(0xffff073D83),
                                  fontSize: 15),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
    showDialog(
      barrierDismissible: false,
      // barrierColor: Colors.grey[300].withOpacity(0.1), // Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
