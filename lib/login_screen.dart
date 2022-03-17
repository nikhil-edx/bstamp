import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bStamp/bottom_Navigation/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'backend.dart';
import 'bottom_Navigation/stampeddocument.dart';
import 'main.dart';
import 'search_page.dart';

// ignore: camel_case_types
class edexaLogin extends StatefulWidget {
  const edexaLogin({Key key}) : super(key: key);

  @override
  edexaLoginState createState() => edexaLoginState();
}

// ignore: camel_case_types
class edexaLoginState extends State<edexaLogin> {
  //final _formKey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var myData;
  bool val = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final searchbar = TextEditingController();

  void httpJob(AnimationController controller) async {
    controller.forward();
    // print("delay start");
    await Future.delayed(const Duration(seconds: 3), () {});
    // print("delay stop");
    controller.reset();
  }

  _getStampList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');

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
                " " +
                jsonResponse['data']['last_name']);
        preferences.setString(
            'profilePicture', jsonResponse['data']['profilePic']);
        preferences.setString(
            "viewType", jsonResponse['data']['viewType'].toString());
        preferences.setString(
            "watermark", jsonResponse['data']['watermark'].toString());
        //  _getUserInfo();
      });
    } else {
      var jsonResponse = jsonDecode(response.body);

      // ignore: avoid_print

    }
  }

  var data;
  Future _Authkey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // print(passwordController.text);
    // print(emailController.text);
    var url = Uri.parse("https://${Backend.baseurl}/authenticate");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json",
        "client-id": emailController.text,
        "secret-key": passwordController.text,
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
          preferences.setString('name', jsonResponse['data']['name']);
          preferences.setString('token', jsonResponse['data']['token']);
          preferences.setString('clientID', emailController.text);
          preferences.setString('secretId', passwordController.text);
          preferences.setString(
              'profilePicture', jsonResponse['data']['profilePicture']);
          preferences.setString(
              "viewType", jsonResponse['data']['viewType'].toString());
          preferences.setString(
              "watermark", jsonResponse['data']['watermark'].toString());
          //_getUserInfo();
          _getStampList();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Main() //SearchPage()
                  // TabBarDemo(watermark
                  //   selectedPage: 0,
                  //   status: "Login",
                  // ),
                  ));
        });
      } else {
        //  print(response.statusCode);
        var errorMsg = json.decode(response.body);
        //  print(errorMsg["message"]);
        showError(context, errorMsg["message"]);
      }
    });
  }

  void _requestFocus(node) {
    setState(() {
      FocusScope.of(context).requestFocus(node);
    });
  }

  FocusNode FocusNode1 = new FocusNode();
  FocusNode FocusNode2 = new FocusNode();
  // ignore: unused_element
  _login(text1, text2, text3) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Login",
                    style: TextStyle(
                        color: Color(0xFF0D0F12), // Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                const Text(
                  "Continue using bStamp",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  // style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20.0),

                TextFormField(
                  onTap: () {
                    _requestFocus(FocusNode1);
                  },
                  focusNode: FocusNode1,
                  controller: emailController,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8),
                        decoration: const BoxDecoration(
                            border: Border(
                                left:
                                    BorderSide(width: 1, color: Colors.grey))),
                        child: const Icon(Icons.person,
                            color: Colors.grey // Color(0xFF073D83)
                            ),
                      ),
                    ),
                    // suffixIcon:
                    //     const Icon(Icons.person, color: Color(0xFF073D83)),
                    enabled: true,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xFF073D83),
                    )),

                    //focusedBorder: OutlineInputBorder( borderSide: new BorderSide(color: Colors.grey)),
                    labelText: "$text1",
                    labelStyle: TextStyle(
                        color: FocusNode1.hasFocus
                            ? Color(0xFF073D83)
                            : Colors.grey
                        //  )
//color: Color(0xFF073D83),
                        ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid $text1';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20.0),
                // const SizedBox(height: 10.0),
                TextFormField(
                  onTap: () {
                    _requestFocus(FocusNode2);
                  },
                  focusNode: FocusNode2,
                  controller: passwordController,
                  decoration: InputDecoration(
                    // suffixIcon: IconButton(
                    //     onPressed: () {
                    //       setState(() {
                    //         val == false ? val = true : val = false;
                    //       });
                    //     },
                    //     icon: val
                    //         ? const Icon(
                    //             Icons.remove_red_eye,
                    //             color: Color(0xFF073D83),
                    //           )
                    //         : const Icon(
                    //             Icons.visibility_off_outlined,
                    //             color: Color(0xFF073D83),
                    //           )),

                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8),
                        decoration: const BoxDecoration(
                            border: Border(
                                left:
                                    BorderSide(width: 1, color: Colors.grey))),
                        child: const Icon(Icons.lock,
                            color: Colors.grey // Color(0xFF073D83)
                            ),
                      ),
                    ),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xFF073D83),
                    )),
                    labelText: "$text2",
                    labelStyle: TextStyle(
                        color: FocusNode2.hasFocus
                            ? Color(0xFF073D83)
                            : Colors.grey
                        //  color: Color(0xFF073D83),
                        ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid $text2';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                // Row(
                //   children: const [
                //     Checkbox(
                //       value: false,
                //       onChanged: null,
                //     ),
                //     Text(
                //       "Remember Me",
                //       style: TextStyle(
                //           color: Colors.grey, fontWeight: FontWeight.w500),
                //     ),
                //     Spacer(
                //       flex: 2,
                //     ),
                //     Text(
                //       "Forgot Password?",
                //       style: TextStyle(
                //         color: Color(0xFF073D83),
                //       ),
                //     )
                //   ],
                // ),
                const SizedBox(height: 20.0),
                // ignore: sized_box_for_whitespace
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 50,
                  child: ProgressButton(
                    color: const Color(0xFF073D83),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    strokeWidth: 2,
                    child: Text(
                      "$text3",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: (AnimationController controller) async {
                      if (_formKey.currentState.validate()) {
                        _Authkey();
                        httpJob(controller);
                      } else {}
                    },
                  ),
                ),
                //  const SizedBox(height: 10.0),
                // _divider(),
                // const SizedBox(height: 10.0),
                //  _edexalogin(),
                // OutlinedButton.icon(

                //  const SizedBox(height: 10.0),
                // ListTile(
                //     title: RichText(
                //   textAlign: TextAlign.center,
                //   text: TextSpan(
                //       text: 'Don\'t  have an account',
                //       style: //GoogleFonts.portLligatSans(
                //           const TextStyle(fontSize: 14, color: Colors.grey
                //               //Color(0xffe46b10),
                //               ),
                //       children: [
                //         TextSpan(
                //           text: ' ? ',
                //           style: const TextStyle(
                //               // fontWeight: FontWeight.w900,
                //               color: Color(0xFF073D83),
                //               fontSize: 14),
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               launch('https://edexa.com/en/privacy-policy/');
                //             },
                //         ),
                //         TextSpan(
                //           text: 'Sign Up',
                //           style: const TextStyle(
                //               fontWeight: FontWeight.w400,
                //               color: Color(0xFF073D83),
                //               // Color(0xffe46b10),
                //               fontSize: 14),
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               launch('https://edexa.com/en/privacy-policy/');
                //             },
                //         ),
                //       ]),
                // )),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  var focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   title: Image.asset(
        //     "assets/images/edexa_new.png",
        //   ),
        // ),
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/Images/loginBGImge.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  // "assets/images/bStamp_new.png",
                  "assets/Images/edexa_new.png",
                  height: 50, color: Colors.white,
                  filterQuality: FilterQuality.medium,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                ),
                // SizedBox(
                //   // height: 100,
                //   width: 600,
                //   child: Card(
                //       color: Colors.white,
                //       elevation: 20,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(15.0),
                //       ),
                //       child: ListTile(
                //           leading: const Icon(Icons.search),
                //           title: RawKeyboardListener(
                //             focusNode: focusNode,
                //             onKey: (event) {
                //               if (event
                //                   .isKeyPressed(LogicalKeyboardKey.enter)) {
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (context) => StampedDocument(
                //                               id: searchbar.text,
                //                             ) // LoginPage(),
                //                         ));
                //               }
                //             },
                //             child: TextFormField(
                //               onChanged: (g) {
                //                 print(g);
                //               },
                //               onSaved: (f) {
                //                 print(f);
                //               },
                //               controller: searchbar,
                //               decoration: const InputDecoration(
                //                   hintText: "Search  here",
                //                   border: InputBorder.none),
                //               onEditingComplete: () {
                //                 print("jjjjjjjjjjjj");
                //               },
                //               textInputAction: TextInputAction.search,
                //             ),
                //           ))),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width / 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
//Spacer(),
              MediaQuery.of(context).size.width == 500
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width / 4,
                              left: 100),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              "Building the future ecosystem based on",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30)),
                                      TextSpan(
                                          text: " trust, security",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      TextSpan(
                                          text: " and ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30)),
                                      TextSpan(
                                          text: "transparency",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))
                                    ],
                                  ),
                                ),
                                // const Text(
                                //   "Building the future ecosystem based on trust, security, and transparency",
                                //   //"Building the future ecosystem based on TRUST, SECURITY and TRANSPARENCY ",
                                //   style: TextStyle(
                                //       color: Colors.white, fontSize: 30),
                                // ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "edeXa Universe is the advanced next-generation of networks. We make it simple for innovative businesses to adopt blockchain technology.",
                                  //"It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters",
                                  style: TextStyle(
                                      color: Colors.grey[300], fontSize: 16),
                                ),
                                // const Text(
                                //   "Building the future ecosystem based on TRUST, SECURITY and TRANSPARENCY ",
                                //   style: TextStyle(
                                //       color: Colors.white, fontSize: 30),
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                // Text(
                                //   "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters",
                                //   style: TextStyle(
                                //       color: Colors.grey[300], fontSize: 16),
                                // ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 100, bottom: 50, right: 100),
                    child: Center(
                      // color: Colors.white,
                      child: Container(
                        height: 365,
                        // MediaQuery.of(context).size.height / 2, //500,
                        width: MediaQuery.of(context).size.height / 2,
//400, // MediaQuery.of(context).size.width / 4,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        child: _login("ClientId", "Secret Key", "Authenticate"),
                        // child: DefaultTabController(
                        //   initialIndex: 0,
                        //   length: 2,
                        //   child: Column(
                        //     // children: [
                        //     //   TabBar(
                        //     //     indicator: BoxDecoration(
                        //     //         borderRadius: const BorderRadius.only(
                        //     //             topLeft: Radius.circular(10)),
                        //     //         color: Colors.grey[200]),
                        //     //     labelColor: Colors.grey,
                        //     //     tabs: const [
                        //     //       Tab(
                        //     //         text: "Login with ClientId",
                        //     //       ),
                        //     //       Tab(
                        //     //         text: "Login",
                        //     //       ),
                        //     //     ],
                        //     //   ),
                        //       Expanded(
                        //         child: TabBarView(
                        //           children: [
                        //             _login("ClientId", "SecretId",
                        //                 "Authenticate"),
                        //             // const Center(
                        //             //   child: Text("Comming Soon..."),
                        //             // ),
                        //             _login("Email", "Password", "Login"),
                        //           ],
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // )) // _login(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ));
  }

  Widget _edexalogin() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 0.2),
        //  color: Colors.blue[50],
      ),
      child: Center(
        child: ListTile(
          leading: Image.asset(
            'assets/images/google.png',
            width: 100,
            filterQuality: FilterQuality.medium,
          ),
          title: const Text(
            "Login with Google",
            style: TextStyle(fontSize: 16),
          ),
          dense: true,
        ),
      ),
    );
  }

  //Divider line
  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or Connect With'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  void showSuccess(BuildContext context, String message,
      {bool shouldDismiss = true}) {
    Timer.run(() => _showAlert(
        context,
        message,
        // Colors.blue,
        const Color(0xFFE2F8FF),
        CupertinoIcons.check_mark_circled_solid,
        const Color(0xffff073D83),
        //Color.fromRGBO(91, 180, 107, 1),
        shouldDismiss));
  }

  void showInfo(BuildContext context, String message,
      {bool shouldDismiss = true}) {
    Timer.run(() => _showAlert(context, message, Color(0xFFE7EDFB),
        Icons.info_outline, Color.fromRGBO(54, 105, 214, 1), shouldDismiss));
  }

  void showError(BuildContext context, String message,
      {bool shouldDismiss = true}) {
    Timer.run(() => _showAlert(context, message, const Color(0xFFFDE2E1),
        Icons.error_outline, Colors.red, shouldDismiss));
  }

  void _showAlert(BuildContext context, String message, Color color,
      IconData icon, Color iconColor, bool shouldDismiss) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          if (shouldDismiss) {
            Future.delayed(const Duration(seconds: 4), () {
              Navigator.of(context, rootNavigator: true).pop();
            });
          }
          return Material(
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
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.height / 10,
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
          );
        });
  }
}
