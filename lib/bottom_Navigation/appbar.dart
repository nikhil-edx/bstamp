import 'dart:convert';
import 'dart:io';
import 'package:bStamp/Validate_page.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:bStamp/search_page.dart';
import 'package:fragment_navigate/navigate-control.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend.dart';
import '../login_screen.dart';
import '../main.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Main(),
    );
  }
}

final String a = 'a';
final String b = 'b';
final String c = 'c';
final String d = 'd';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var color1 = Colors.black, color = Colors.black, color2 = Colors.black;
  @override
  void initState() {
    super.initState();
    checkIsLogin();
_getStampList();
  
  Future.delayed(const Duration(seconds:2),(){
  _getStampList();
});
  }

  var token, email, name, username, profilePicture;
  checkIsLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // preferences.clear();
    token = preferences.getString('token');

    if (token != null && token != '') {
     //  _getStampList();
      setState(() {
        token = token;
  profilePicture = preferences.getString(
        'profilePicture',
      );
           email = preferences.getString(
        'email',
      );
      name = preferences.getString(
        'name',
      );
      username = preferences.getString(
        'username',
      );
    
      });

     // _getUserInfo();
    } else {}
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
      username = preferences.getString(
        'username',
      );
      profilePicture = preferences.getString(
        'profilePicture',
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
     
  preferences.setString(
            'profilePicture', jsonResponse['data']['profilePic']);
        preferences.setString('email', jsonResponse['data']['email']);
        preferences.setString('username', jsonResponse['data']['username']);
        preferences.setString(
            'name',
            jsonResponse['data']['first_name'] +
                " " +
                jsonResponse['data']['last_name']);
      
        preferences.setString(
            "viewType", jsonResponse['data']['viewType'].toString());
        preferences.setString(
            "watermark", jsonResponse['data']['watermark'].toString());
        preferences.setString(
            "align", jsonResponse['data']['align'].toString());
        _getUserInfo();
      });
    } else {
      var jsonResponse = jsonDecode(response.body);

      // ignore: avoid_print

    }
  }

  static final FragNavigate _fragNav =
      FragNavigate(firstKey: a, drawerContext: null, screens: <Posit>[
    Posit(
        key: a, title: 'Title A', icon: Icons.settings, fragment: SearchPage()),
    Posit(
        key: b,
        title: 'Title B',
        drawerTitle: 'Diff in B',
        icon: Icons.settings,
        fragment: TabBarDemo(
          selectedPage: 0,
        )),
    Posit(
        key: c,
        title: 'Title C',
        icon: Icons.settings,
        fragment: Container(
          color: Colors.blueAccent,
        )),
    Posit(
        key: d, title: 'Title D', icon: Icons.settings, fragment: Text('qqqq')),
  ], actionsList: [
    ActionPosit(keys: [
      a,
      b,
      c
    ], actions: [
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _fragNav.action('teste');
          })
    ])
  ], bottomList: [
    BottomPosit(
        keys: [a, b, c],
        length: 2,
        child: TabBar(
          indicatorColor: Colors.white,
          tabs: <Widget>[Text('a'), Text('b')],
        ))
  ]);

  @override
  Widget build(BuildContext context) {
    _fragNav.setDrawerContext = context;

    return StreamBuilder<FullPosit>(
        stream: _fragNav.outStreamFragment,
        builder: (con, s) {
          if (s.data != null) {
            return DefaultTabController(
                length: s.data.bottom?.length ?? 1,
                child: Scaffold(
             //  key: UniqueKey(),
                    //   key: _fragNav.drawerKey,
                    appBar: AppBar(
                      backgroundColor: Color(0xF8F8F8),
                      // leading:
                      title: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          'assets/Images/bStamp_new.png',
                          height: 35,
                          // cacheHeight: 30,
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                      elevation: 0,

                      actions: [
                        token != null && token != ''
                            ? Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Center(
                                  // padding: const EdgeInsets.only(right: 20.0, top: 20),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      InkWell(
                                        hoverColor: Colors.transparent,
                                        onTap: () {
                                          launch("https://bstamp.edexa.com/");
                                        },
                                        child: MouseRegion(
                                          onEnter: (e) {
                                            setState(() {
                                              color = Color(0xffff073D83);
                                            });
                                          },
                                          onExit: (e) {
                                            setState(() {
                                              color = Colors
                                                  .black; // Color(0xffff073D83);
                                            });
                                          },
                                          child: Text(
                                            "Home",
                                            style: TextStyle(
                                                color: color,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),

                                      InkWell(
                                        hoverColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.of(context).maybePop();
                                          _fragNav.putPosit(key: a);
                                        },
                                        child: MouseRegion(
                                          onEnter: (e) {
                                            setState(() {
                                              color2 = Color(0xffff073D83);
                                            });
                                          },
                                          onExit: (e) {
                                            setState(() {
                                              color2 = Colors
                                                  .black; // Color(0xffff073D83);
                                            });
                                          },
                                          child: Text(
                                            "Validate",
                                            style: TextStyle(
                                                color: s.data.title == "Title A"
                                                    ? Color(0xffff073D83)
                                                    : color2,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),

                                      InkWell(
                                        hoverColor: Colors.transparent,
                                        child: MouseRegion(
                                          onEnter: (e) {
                                            setState(() {
                                              color1 = Color(0xffff073D83);
                                            });
                                          },
                                          onExit: (e) {
                                            setState(() {
                                              color1 = Colors
                                                  .black; // Color(0xffff073D83);
                                            });
                                          },
                                          child: Text(
                                            "My Account",
                                            style: TextStyle(
                                                color: s.data.title == "Title B"
                                                    ? Color(0xffff073D83)
                                                    : color1,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        onTap: () {
                                          color1 = Color(0xffff073D83);
                                          color2 = Colors.black;
                                          _fragNav.putPosit(key: b);
                                        },
                                      ),
                                      // ),

                                      const SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _getStampList();
                                          setState(() {
                                            _showAlert(context);
                                          });
                                        },
                                        child: profilePicture == null
                                            ? const CircularProgressIndicator()
                                            : CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                  profilePicture,
                                                ),
                                                // AssetImage(
                                                //     'assets/Images/images.jpg'),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                edexaLogin() // LoginPage(),
                                            ));
                                  },
                                  child: Text("Login"),
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(2),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Color(0xffff073D83))),
                                ),
                              )
                      ],
                    ),
                    // AppBar(
                    //   title: Text(s.data.title ?? 'NULL'),
                    //   actions: s.data?.actions,
                    //   bottom: s.data?.bottom?.child,
                    // ),
                    //drawer: CustomDrawer(fragNav: _fragNav),
                    body: ScreenNavigate(
                        child: s.data.fragment, control: _fragNav)));
          }

          return Container();
        });
  }

  void _showAlert(
    BuildContext context,
  ) {
    showDialog(
        // useRootNavigator: false,
        // barrierDismissible: false,
        context: context,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: 200,
              width: 300,

              child: Padding(
                padding: const EdgeInsets.only(top: 50, right: 10, left: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey, //Color(0xffff073D83),
                              width: 1),
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                              bottom: Radius.circular(10)),
                          color: Colors.white),
                      width: 300, //MediaQuery.of(context).size.width / 4,
                      height: 330, //MediaQuery.of(context).size.height / 3,
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 0.5,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Color(
                                        0xFFFFe8f0fe), // Colors.blue[100],
                                    borderRadius: BorderRadius.circular(5)),
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
//'https://edexa.com/en/terms-and-conditions/'
                                                  );
                                            },
                                        ),
                                      ]),
                                )),
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
                          const SizedBox(
                            height: 5,
                          ),
                          Wrap(
                            children: [
                              Center(
                                  child: Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                              child: Text(
                            email,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          )),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width / 0.8,
                              child: ElevatedButton(
                                onPressed: () {
                                  launch('https://accounts.edexa.com/profile');
                                },
                                child: const Text(
                                    "       Manage your edeXa account      "),
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(2),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Color(0xffff073D83))),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: SizedBox(
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
                                                            'Cancel')),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    OutlinedButton(
                                                      onPressed: () async {
                                                        Navigator.pop(
                                                            context, 'Cancel');
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
                                                        // Navigator.pop(
                                                        //     context, 'Cancel');
                                                        //  Navigator.pushNamed(context, "/");
                                                        Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Main() //SearchPage(), //edexaLogin()
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
                          ),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          // const Divider(),

                          // Padding(
                          //   padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          //   child: SizedBox(
                          //     height: 30,
                          //     width: MediaQuery.of(context).size.width / 0.8,
                          //     child: OutlinedButton(
                          //         onPressed: () {
                          //           Navigator.of(
                          //             context,
                          //           ).pop();
                          //         },
                          //         child: Text(("Cancel"))),
                          //   ),
                          // ),

                          const Divider(),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'Privacy Policy ',
                                style: //GoogleFonts.portLligatSans(
                                    const TextStyle(
                                        fontSize: 12, color: Colors.grey
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
                                        fontSize: 12),
                                  ),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        // color: Color(0xFF073D83),
                                        // Color(0xffe46b10),
                                        fontSize: 12),
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
              //  ),
              //  ),
            );
          });
        });
  }
}
