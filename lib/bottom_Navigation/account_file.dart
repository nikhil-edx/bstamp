// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print
import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:bStamp/bottom_Navigation/dialog_toast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend.dart';

class Account extends StatefulWidget {
  const Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  void initState() {
    super.initState();

    _getStampList();
    _getUserInfo();
  }

  // ignore: non_constant_identifier_names
  var data, data1, count, token, Dirpath;

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
    // ignore: unused_local_variable
    var jsonResponse = convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = convert.jsonDecode(response.body);

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
        preferences.setString(
            "align", jsonResponse['data']['align'].toString());
        _getUserInfo();
      });
    } else {
      // ignore: unused_local_variable
      var jsonResponse = convert.jsonDecode(response.body);
    }
  }

  int viewtypeindex, watermarPositionIndex;
  var username,
      email,
      clientID,
      secretKey,
      viewType,
      watermarkPosition,
      watermarkk,
      directorypath;
  // ignore: unused_field
  bool _switchValue = false;
  var dir1, dir2, dir3, dir;
  _getUserInfo() async {
    dir = (await getDownloadsDirectory()).path;
    directorypath = dir.replaceAll(r'\', r'/');
    dir1 = (await getApplicationDocumentsDirectory()).path;
    dir2 = (await getApplicationSupportDirectory()).path;
    dir3 = (await getTemporaryDirectory()).path;
    // directorypath = dir.replaceAll(r'\', r'/');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    viewType = preferences.getString('viewType');
    watermarkk = preferences.getString('watermark');
    watermarkPosition = preferences.getString('align');

    setState(() {
      watermarkk == "0" ? _switchValue = false : _switchValue = true;
    });

    watermarkPosition == "top"
        ? watermarPositionIndex = 0
        : watermarkPosition == "bottom"
            ? watermarPositionIndex = 1
            : watermarPositionIndex = 2;
    viewtypeindex = int.parse(viewType);
    email = preferences.getString(
      'email',
    );
    username = preferences.getString(
      'name',
    );

    clientID = preferences.getString(
      'clientID',
    );
    secretKey = preferences.getString(
      'secretId',
    );
    Dirpath = preferences.getString(
      'Dir',
    );

    setState(() {
      emailController.text = email;
      clientController.text = clientID;
      secretkeyController.text = secretKey;
      nameController.text = username;
    });

    companyController.text = " ";
    currencyController.text = " ";
  }

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final currencyController = TextEditingController();
  final clientController = TextEditingController();
  final secretkeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // ignore: unused_element
  _saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("token");
      preferences.setString('clientID', clientController.text);
      preferences.setString('secretId', secretkeyController.text);
    });
  }

  var myData;
  updateAlbum(id, text) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    var url = Uri.https(
        // ignore: unnecessary_string_interpolations
        '${Backend.baseurl}',
        // ignore: unnecessary_string_interpolations
        '${Backend.download}',
        {'q': '{https}'});
    // ignore: unused_local_variable
    final http.Response response = await http
        .put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: token
      },
      body: jsonEncode({
        "viewType": id,
        "align": text == null || text == "" ? watermarkPosition : text
      }),
      // ignore: missing_return
    )
        // ignore: missing_return
        .then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();

        setState(() {
          myData = json.decode(response.body);

          preferences.setString(
              "viewType", myData['data']['viewType'].toString());

          preferences.setString("align", myData["data"]["align"].toString());

          Dailog_toast().showSuccess(context, myData["message"]);
        });
      } else {
        myData = json.decode(response.body);
      }
    });
  }

  _updateWatermarkStatus(
    id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    var view = preferences.getString('viewType');
    var url = Uri.https(
        // ignore: unnecessary_string_interpolations
        '${Backend.baseurl}',
        // ignore: unnecessary_string_interpolations
        '${Backend.download}',
        {'q': '{https}'});
    // ignore: unused_local_variable
    final http.Response response = await http
        .put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: token
      },
      body: jsonEncode({
        // ignore: unnecessary_string_interpolations
        "viewType": "$view",
        "watermark": "$id",
      }),
      // ignore: missing_return
    )
        // ignore: missing_return
        .then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          myData = json.decode(response.body);

          Dailog_toast().showSuccess(context, myData["message"]);
          preferences.setString(
              'watermark', myData["data"]["watermark"].toString());
        });
      } else {
        myData = json.decode(response.body);
      }
    });
  }

  // ignore: unused_element
  _title(name) {
    return Text(
      name,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black),
    );
  }

  void httpJob(AnimationController controller) async {
    controller.forward();

    await Future.delayed(const Duration(seconds: 4), () {});

    controller.reset();
  }

  // ignore: non_constant_identifier_names
  _AddMetadataField(name, controller, value, text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10, left: 1, right: 1),
      child: Column(
        children: [
          TextFormField(
            readOnly: true,
            style: const TextStyle(color: Color(0xFFFf868686)),
            controller: controller,
            decoration: InputDecoration(
              fillColor: Colors.grey[100],
              filled: value,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400], width: 0.5)),
              suffixIcon: value == true
                  ? IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: controller.text));
                        showSuccess(context, " Copied! ");
                      },
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.grey,
                      ),
                      hoverColor: Colors.transparent,
                    )
                  : SizedBox(),
              prefix: const Text("      "),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400], width: 0.5)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
              // enabled: value,
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey[400],
              )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey[400], //Color(0xffff073D83),
              )),
              labelStyle: const TextStyle(color: Colors.grey

                  /// Color(0xffff073D83),
                  ),
            ),
            enabled: value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter valid $text';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  String radioItem = 'Mango';

  // Group Value for Radio Button.
  int id = 0;

  List<DataList> fList = [
    DataList(
      index: 0,
      name: "PDF",
    ),
    DataList(
      index: 1,
      name: "JSON",
    ),
    DataList(
      index: 2,
      name: "none",
    ),
  ];
  setpath(value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("Dir", value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                const Text(
                  "Your account",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    setState(() {
                      launch("https://accounts.edexa.com/profile"); //live url
                      //launch("https://accounts.io-world.com/profile"); //betaurl
                    });
                  },
                  child: const Text(
                    "Edit Account Information",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        // ignore: use_full_hex_values_for_flutter_colors
                        color: Color(0xffff073D83)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // _title("Your account"),

            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Expanded(
                      child: Text(
                    "Full Name",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Text("Email",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)))
                ],
              ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            Row(
              children: [
                Flexible(
                  child: _AddMetadataField(
                      'Full Name', nameController, false, "Name"),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: _AddMetadataField(
                      'Email', emailController, false, "Email"),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            //Hide company field for sometime
            // Padding(
            //   padding: const EdgeInsets.only(left: 15.0),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: const [
            //       // Expanded(
            //       //     child: Text("Company",
            //       //         style: TextStyle(
            //       //             fontSize: 14, fontWeight: FontWeight.bold))),
            //       Expanded(
            //           child: Text("Preferred Currency",
            //               style: TextStyle(
            //                   fontSize: 14, fontWeight: FontWeight.bold)))
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            //hide row for now
            // Row(
            //   children: [
            //     //hide company field for now
            //     // Flexible(
            //     //   child:
            //     //    _AddMetadataField(
            //     //       'Company', companyController, false, "Company Name"),
            //     // ),
            //     Flexible(
            //       flex: 1,
            //       child: _AddMetadataField('Preferred Currency',
            //           currencyController, false, "Currency"),
            //     ),
            //     Flexible(child: SizedBox()),
            //   ],
            // ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text("Certificate  Blockchain setting",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    )),
                              ),
                              IconButton(
                                hoverColor: Colors.transparent,
                                tooltip:
                                    "choose the type of setting to view the certificate info",
                                // "You need to enable this option if you want to add watermark to PDF file. It  will only work with PDF file"
                                icon: const Icon(
                                  Icons.info,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                                color: Colors.blue[200],
                              ),
                              const SizedBox(
                                width: 250,
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 0.0),
                              //   child: Padding(
                              //       padding: const EdgeInsets.only(top: 4.0),
                              //       child: SizedBox(
                              //         width: 400,
                              //         child: Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.start,
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.start,
                              //           children: [
                              //             Row(
                              //               children: [
                              //                 Text(
                              //                   "PDF signature watermark",
                              //                   style: TextStyle(
                              //                     fontSize: 22,
                              //                     fontWeight: FontWeight.w900,
                              //                   ),
                              //                 ),
                              //                 IconButton(
                              //                   hoverColor: Colors.transparent,
                              //                   tooltip:
                              //                       "You need to enable this option if you want to add watermark to PDF file. It  will only work with PDF file",
                              //                   icon: const Icon(
                              //                     Icons.info,
                              //                     color: Colors.grey,
                              //                   ),
                              //                   onPressed: () {},
                              //                   color: Colors.blue[200],
                              //                 ),
                              //               ],
                              //             ),
                              //             Text(
                              //                 "Note: The file stamp features will be enabled for any type of file"),
                              //           ],
                              //         ),
                              //       )),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                hoverColor: Colors.transparent,
                                activeColor: Colors.grey,
                                value: 0,
                                groupValue: viewtypeindex, // id,
                                onChanged: (val) {
                                  setState(() {
                                    //  radioButtonItem = 'ONE';
                                    Dailog_toast().showAlertDialog(context);

                                    viewtypeindex = 0;
                                    updateAlbum(viewtypeindex, "");
                                  });
                                },
                              ),
                              const Text(
                                'PDF',
                                style: TextStyle(fontSize: 17.0),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Radio(
                                hoverColor: Colors.transparent,
                                activeColor: Colors.grey,
                                value: 1,
                                groupValue: viewtypeindex, // id,
                                onChanged: (val) {
                                  setState(() {
                                    Dailog_toast().showAlertDialog(context);

                                    //  radioButtonItem = 'TWO';
                                    viewtypeindex = 1;
                                    updateAlbum(viewtypeindex, "");
                                  });
                                },
                              ),
                              const Text(
                                'JSON',
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Radio(
                                hoverColor: Colors.transparent,
                                activeColor: Colors.grey,
                                value: 2,
                                groupValue: viewtypeindex, //id,
                                onChanged: (val) {
                                  setState(() {
                                    Dailog_toast().showAlertDialog(context);

                                    //  radioButtonItem = 'THREE';
                                    viewtypeindex = 2;
                                    updateAlbum(viewtypeindex, "");
                                  });
                                },
                              ),
                              const Text(
                                'None',
                                style: TextStyle(fontSize: 17.0),
                              ),
                              const SizedBox(
                                width: 340,
                              ),
                              // Switch(
                              //   hoverColor: Colors.transparent,
                              //   value: _switchValue,
                              //   onChanged: (value) {
                              //     setState(() {
                              //       _switchValue = value;
                              //       Dailog_toast().showAlertDialog(context);
                              //       value == false
                              //           ? _updateWatermarkStatus(0)
                              //           : _updateWatermarkStatus(1);
                              //     });
                              //   },
                              //   activeTrackColor:
                              //       const Color(0xffff073D83).withOpacity(0.5),
                              //   activeColor: const Color(0xffff073D83),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        // _switchValue
                        //     ?
                        Wrap(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text(
                                    "Watermark PDF Download Directory Path",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    )),
                              ),
                            ),
                            const SizedBox(
                              width: 170,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Text("Watermark Position",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  )),
                            ),
                            IconButton(
                              hoverColor: Colors.transparent,

                              tooltip:
                                  "choose the type of position for PDf Watermark",
                              // "You need to enable this option if you want to add watermark to PDF file. It  will only work with PDF file"
                              icon: const Icon(
                                Icons.info,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                              color: Colors.blue[200],
                            ),
                          ],
                        ),
                        // : Container(),
                        // _switchValue
                        //     ?
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            Flexible(
                              fit: FlexFit.loose,
                              //   flex: 0,
                              child: SizedBox(
                                width: 300,
                                child: DropdownButton<String>(
                                  elevation: 10,

                                  // ignore: prefer_if_null_operators
                                  value: Dirpath == null ? dir : Dirpath,
                                  items: <String>[
                                    '$dir',
                                    '$dir1',
                                    // '$dir2',
                                    // '$dir3'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      Dirpath = value;
                                    });
                                    setpath(value);
                                  },
                                ),
                              ),
                            ),
                            // Spacer(),
                            SizedBox(
                              width: 280,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Radio(
                                      hoverColor: Colors.transparent,
                                      activeColor: Colors.grey,
                                      value: 0,
                                      groupValue: watermarPositionIndex, // id,
                                      onChanged: (val) {
                                        setState(() {
                                          //  radioButtonItem = 'ONE';
                                          Dailog_toast()
                                              .showAlertDialog(context);
                                          watermarPositionIndex = 0;
                                          updateAlbum(viewtypeindex, "top");
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Top',
                                      style: TextStyle(fontSize: 17.0),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Radio(
                                      hoverColor: Colors.transparent,
                                      activeColor: Colors.grey,
                                      value: 1,
                                      groupValue: watermarPositionIndex, // id,
                                      onChanged: (val) {
                                        setState(() {
                                          Dailog_toast()
                                              .showAlertDialog(context);

                                          //  radioButtonItem = 'TWO';
                                          watermarPositionIndex = 1;
                                          updateAlbum(viewtypeindex, "bottom");
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Bottom',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Radio(
                                      hoverColor: Colors.transparent,
                                      activeColor: Colors.grey,
                                      value: 2,
                                      groupValue: watermarPositionIndex, //id,
                                      onChanged: (val) {
                                        setState(() {
                                          Dailog_toast()
                                              .showAlertDialog(context);
                                          watermarPositionIndex = 2;

                                          updateAlbum(viewtypeindex, "none");
                                        });
                                      },
                                    ),
                                    const Text(
                                      'None',
                                      style: TextStyle(fontSize: 17.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        //  : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 40,
            ),
            const Text(
              "API",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),

            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            // 'In order to use Our API, you will need the following credentials.',
                            "You will need the following credentials in order to use Our API. Please visit the complete document .",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextSpan(
                        text: ' Click here',
                        style: const TextStyle(
                          // ignore: use_full_hex_values_for_flutter_colors
                          color: Color(0xffff073D83),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch("https://portal.edexa.com/apis");
                            // "https://portal.edexa.com/apis/api-detail/api-explorer/38");
                            //launch("https://accounts.io-world.com/profile");//betaurl
                          },
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 25,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Expanded(
                      child: Text("Client ID",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold))),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Text("Secret Key",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)))
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Flexible(
                  child: _AddMetadataField(
                      'Client ID', clientController, true, "Client ID"),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: _AddMetadataField(
                      'Secret Key', secretkeyController, true, "Secret Key"),
                )
              ],
            ),

            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            const Text(
                "If you would like to modify your profile information (or) security settings (or) and other personalization settings, then please click on Edit account information"
                // "Use the following credentials in Deleting your account will cause all your data to be erased. You will still be able to retrieve your certificates as long as you backup the files that you stamped",
                ,
                style: TextStyle(color: Colors.grey, fontSize: 16)),

// savedata button
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: SizedBox(
            //     height: 40,
            //     width: 200,
            //     child: ProgressButton(
            //       // ignore: use_full_hex_values_for_flutter_colors
            //       color: const Color(0xffff073D83),
            //       borderRadius: const BorderRadius.all(Radius.circular(5)),
            //       strokeWidth: 2,
            //       child: const Text(
            //         "Save Data",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 14,
            //         ),
            //       ),
            //       onPressed: (AnimationController controller) async {
            //         if (_formKey.currentState.validate()) {
            //           _saveData();
            //           // updateAlbum();

            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => const TabBarDemo(status: "wLogin",)));
            //           httpJob(controller);
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             const SnackBar(content: Text('Processing Data...')),
            //           );
            //         } else {}
            //       },
            //     ),
            //   ),
            // ),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
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
        transitionDuration: const Duration(milliseconds: 10),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          if (shouldDismiss) {
            Future.delayed(const Duration(seconds: 1), () {
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
                      width: MediaQuery.of(context).size.width / 12,
                      height: MediaQuery.of(context).size.height / 16,
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            icon,
                            size: 30,
                            color: iconColor,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Text(
                              message,
                              style: const TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 16,
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

class DataList {
  String name;
  int index;
  DataList({this.name, this.index});
}
