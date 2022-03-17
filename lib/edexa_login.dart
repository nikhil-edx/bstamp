import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
//import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'backend.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  var myData;
  bool val = true;

  void httpJob(AnimationController controller) async {
    controller.forward();

    await Future.delayed(Duration(seconds: 3), () {});

    controller.reset();
  }

  Future<bool> saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString('token', myData['data']["app_token"]);
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

  updateAlbum() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = Uri.parse("https://apiaccounts.io-world.com/auth/login");
    final http.Response response = await http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        //"platformrole": "user"
      },
      body: jsonEncode({
        "email": emailController.text.toString(),
        "password": passwordController.text.toString(),
        "clientApp": "bStamp"
      }),
      // ignore: missing_return
    )
        // ignore: missing_return
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          myData = json.decode(response.body);

          preferences.setString('token', myData['data']['token']);
          preferences.setString(
              'username', myData['data']['user_info']['username']);
          preferences.setString('email', myData['data']['user_info']['email']);
          _getStampList();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TabBarDemo(
                  status: "Login",
                ),
              ));
          // val = false;
        });
      } else {
        val = false;

        /// print(response.statusCode);
        Fluttertoast.showToast(
            msg: "incorrect username or password",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            // timeInSecForIosWeb: 10,
            backgroundColor: Colors.redAccent[300],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  var data;
  Future _Authkey() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var url = Uri.parse("https://apibstamp.io-world.com/authenticate");
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
          //  print("main$data");
          // int ab =
          //     int.parse(int.parse(jsonResponse['data']['viewType']).toString());
          //   preferences.setString("viewType", ab.toString());
          preferences.setString('email', jsonResponse['data']['email']);
          preferences.setString('username', jsonResponse['data']['username']);
          preferences.setString('token', jsonResponse['data']['token']);
          preferences.setString('clientID', emailController.text);
          preferences.setString('secretId', passwordController.text);
          preferences.setString(
              'profilePicture', jsonResponse['data']['profilePicture']);

          //_getUserInfo();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TabBarDemo(
                  selectedPage: 0,
                  status: "Login",
                ),
              ));
        });
      } else {
        // print(response.statusCode);
        var errorMsg = json.decode(response.body);
        // print(errorMsg["message"]);
        showError(context, errorMsg["message"]);
      }
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.grey.shade300,
        child: Stack(
          children: [
            Scaffold(
                backgroundColor:
                    const Color(0xffff073D83), //Colors.transparent,
                body: Column(
                  children: [
                    Flexible(
                        flex: 0,
                        child: Center(
                          child: SizedBox(
                            width: 200,
                            height: 220,
                            child: Image.asset(
                              'assets/Images/bstamp_logo.png',
                              filterQuality: FilterQuality.medium,
                              // 'assets/images/edeXa_new.png',
                              color: Colors.white,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        )),
                    Flexible(
                      flex: 0,
                      child: Center(
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height / 1.5,
                            width: MediaQuery.of(context).size.height / 1.5,
                            child: Padding(
                                padding: EdgeInsets.all(0), child: _login())),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  //Divider line
  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
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
          Text('or'),
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

  // ignore: unused_element
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 150,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: InkWell(
        onTap: () {
          //Navigator.pop(context);
        },
      ),
      title: SizedBox(
        width: 220,
        height: 80,
        child: Image.asset(
          'assets/Images/edeXa_new.png',
          // color: Colors.white,
        ),
      ),
    );
  }

  _login() {
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
                const Text("Login with ClientId",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
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
                  controller: emailController,
                  decoration: const InputDecoration(
                    enabled: true,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF073D83) //Colors.grey
                                )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFF073D83) //Color(0xffff073D83),
                            )),
                    //focusedBorder: OutlineInputBorder( borderSide: new BorderSide(color: Colors.grey)),
                    labelText: "Client Id ",
                    labelStyle:
                        TextStyle(color: Colors.grey // Color(0xFF073D83),
                            ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid Client Id';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    // suffixIcon: Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     padding: EdgeInsets.only(left: 8),
                    //     decoration: const BoxDecoration(
                    //         border: Border(
                    //             left:
                    //                 BorderSide(width: 1, color: Colors.grey))),
                    //     child: const Icon(Icons.person,
                    //         color: Colors.grey // Color(0xFF073D83),
                    //         ),
                    //   ),
                    // ),

                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF073D83) //Colors.grey
                                )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xFF073D83),
                    )),
                    labelText: "Secret Key",
                    labelStyle:
                        TextStyle(color: Colors.grey //Color(0xFF073D83),
                            ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: 50,
                  child: ProgressButton(
                    color: const Color(0xFF073D83),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    strokeWidth: 2,
                    child: const Text(
                      "Authenticate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: (AnimationController controller) async {
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        //updateAlbum();
                        _Authkey();
                        httpJob(controller);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data...')),
                        );
                      } else {}
                    },
                  ),
                ),
                //   _divider(),
                //    Container(
                //     width: MediaQuery.of(context).size.width * 1,
                //     height: 50,
                //     child: ProgressButton(
                //       color: Color(0xffff073D83),
                //       borderRadius: BorderRadius.all(Radius.circular(5)),
                //       strokeWidth: 2,
                //       child:const Text(
                //         "Continue without login",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 14,
                //         ),
                //       ),
                //       onPressed: (AnimationController controller) async {

                //           Navigator.pushReplacement(
                // context,
                // MaterialPageRoute(
                //   builder: (context) => TabBarDemo(status: "wLogin",),
                // ));

                //       },
                //     ),
                //   ),
                const SizedBox(height: 10.0),
                ListTile(
                    title: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'By Signing In you are agreeing to our ',
                      style: //GoogleFonts.portLligatSans(
                          const TextStyle(fontSize: 14, color: Colors.grey
                              //Color(0xffe46b10),
                              ),
                      children: [
                        TextSpan(
                          text: ' Terms of service',
                          style: const TextStyle(
                              // fontWeight: FontWeight.w900,
                              color: Color(0xffff073D83),
                              fontSize: 14),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://edexa.com/en/terms-and-conditions/');
                            },
                        ),
                        const TextSpan(
                          text: ' and ',
                          style: TextStyle(
                              color: Colors.grey,
                              // Color(0xffe46b10),
                              fontSize: 14),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xffff073D83),
                              // Color(0xffe46b10),
                              fontSize: 14),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://edexa.com/en/privacy-policy/');
                            },
                        ),
                      ]),
                )),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ],
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
