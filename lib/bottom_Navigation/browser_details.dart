// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bStamp/bottom_Navigation/dialog_toast.dart';

import '../edexa_login.dart';
import 'stampeddocument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../backend.dart';
import '../userdatalist.dart';

class DataTableExample extends StatefulWidget {
  const DataTableExample({Key key}) : super(key: key);

  @override
  _DataTableExampleState createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
  @override
  void initState() {
    super.initState();
    _getStampList();
    _checkPlatform();
  }

  var platform;
  _checkPlatform() {
    if (Platform.isLinux) {
      platform = Platform.isLinux;
      // Android-specific code
    } else if (Platform.isIOS) {
      // iOS-specific code
    }
  }

  List<userlist> _userDetails = [];
  String token;

  Future<Null> showAlertDialog(BuildContext context) async {
    return await showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        });
  }

  Future downloadCertificate(id, name, context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');

    var url = Uri.parse("https://${Backend.baseurl}/download");

    // ignore: unused_local_variable
    final http.Response response = await http
        .post(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: token
      },
      body: jsonEncode({
        "id": id,
      }),

      // ignore: missing_return
    )
        // ignore: missing_return
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
//Navigator.of(context).pop();
          Navigator.of(context, rootNavigator: true).pop();
          // ignore: unused_local_variable
          var jsonResponse = json.decode(response.body);

          var a = name.split(".");

          _createFileFromString(jsonResponse["data"], a[0]);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File downloading...'),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong please try again'),
          ),
        );
      }
    });
  }

  var aa = {
    "name": "Screenshot (1).png",
    "txId": "8591ec53b24af25eceed2b87b25950f9dee57ea27932ae94a9ea592572c91ef6",
    "hash": "e4de1e0982be7d2a59bd6e4fd42c15e24dac4fe59b74a4d1e32ebe482e37a9fa",
    "createdAt": "hhvhjhffh"
  };
  Future<String> _createFileFromString(filee, name) async {
    final encodedStr = "$filee";
    Uint8List bytes = base64.decode(encodedStr);
    //String dir = (await getApplicationDocumentsDirectory()).path;
    final dir = (await getApplicationDocumentsDirectory()).path;

    var Filepath = Uri.file(
      dir,
      windows: true,
    );

    File file = File("$dir/" + "$name" + ".pdf");
    String dirpath = Filepath.toString();
    //_makeCall("${dirpath.replaceAll("%20", " ")}");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xffff073D83),
        content: Row(
          children: [
            Expanded(
              child: Text('File Saved Successfully on directory path :$file'),
            ),
            ButtonBar(
              children: [
                platform == null
                    ? OutlinedButton(
                        onPressed: () {
                          _makeCall("${dirpath.replaceAll("%20", " ")}/" +
                              "$name" +
                              ".pdf");
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        child: const Text("Open File"))
                    : SizedBox(),
                OutlinedButton(
                    onPressed: () {
                      //Navigator.pop(context);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Text("Dismiss"))
              ],
            )
          ],
        ), //

        duration: const Duration(seconds: 10),
      ),
    );
    await file.writeAsBytes(bytes);
    return file.path;
  }

// _makeCall(
  //   "https://unix.stackexchange.com/questions/36380/how-to-properly-and-easy-configure-xdg-open-without-any-environment",
  // );
  //  "xdg-open file:///home/edexa/Documents/bStampCertificate.pdf");
  Future<void> _makeCall(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        enableDomStorage: true,
        // forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  // String _searchResult = '';
  var data, data1, count, viewType;
  bool val = true;
  _getStampList() async {
    // ignore: unused_local_variable
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    viewType = preferences.getString('viewType');

    final params = {"page": "1", "limit": "10000"};
    var url = Uri.https(
      // 'https://apibstamp.io-world.com'
      // ignore: unnecessary_string_interpolations
      '${Backend.baseurl}',
      // ignore: unnecessary_string_interpolations
      '${Backend.getstamplist}', params,
//{'q': '{https}'}, params,
    );

    var response = await http.get(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: token
      },
    );
    if (response.statusCode == 200) {
      val = false;
      setState(() {
        val = false;
        var jsonResponse = convert.jsonDecode(response.body);

        data = jsonResponse['data']["files"];
        count = jsonResponse['data']['count'];
        data1 = convert.jsonEncode(jsonResponse['data']["files"]);
        setState(() {
          for (Map user in data) {
            _userDetails.add(userlist.fromJson(user));
          }
        });
      });
    } else {
      val = false;
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.name.toUpperCase().contains(text.toUpperCase()))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }

  List<userlist> _searchResult = [];

  TextEditingController controller = new TextEditingController();
  // ignore: prefer_final_fields, unused_field
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Wrap(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding:
                EdgeInsets.only(right: 20.0, bottom: 20, left: 00, top: 50),
            child: Text(
              "Browse stamps ",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
          ),
          Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Color(0xFFDADCE0) // Colors.grey[300],
                  ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ListTile(
                            title: TextFormField(
                              controller: controller,
                              onChanged: onSearchTextChanged,
//
                              decoration: const InputDecoration(
                                  isDense: true,
                                  hintText: "Search file",
                                  hintStyle: TextStyle(fontSize: 14),
                                  border: InputBorder.none),
                              onTap: () {},
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                // cityNameController.clear();
                              },
                            ),
                          ),
                        )),
                  ),

                  // kTableColumns
                ],
              )),
          // Container(
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 25.0, right: 45.0),
          //     child: Row(
          //       children: const [
          //         SizedBox(
          //           width: 300,
          //           child: Text(
          //             'FILENAME',
          //             style: TextStyle(
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w900,
          //                 color: Colors.black),
          //           ),
          //         ),
          //         SizedBox(
          //           width: 45,
          //         ),
          //         // Spacer(),
          //         Text('CATEGORY',
          //             style: TextStyle(
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w900,
          //                 color: Colors.black)),

          //         SizedBox(
          //           width: 50,
          //         ),
          //         Text('STATUS',
          //             style: TextStyle(
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w900,
          //                 color: Colors.black)),
          //         SizedBox(
          //           width: 60,
          //         ),
          //         //    Spacer(),
          //         Text('TIMESTAMP (GMT)',
          //             style: TextStyle(
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w900,
          //                 color: Colors.black)),
          //         // numeric: true,
          //         SizedBox(
          //           width: 120,
          //         ),
          //         Padding(
          //           padding: EdgeInsets.only(left: 20.0),
          //           child: Text('SHORT CODE',
          //               style: TextStyle(
          //                   fontSize: 13,
          //                   fontWeight: FontWeight.w900,
          //                   color: Colors.black)),
          //         ),
          //         // numeric: true,
          //         Spacer(),
          //         Padding(
          //           padding: EdgeInsets.only(left: 18.0),
          //           child: Text('ACTIONS',
          //               style: TextStyle(
          //                   fontSize: 13,
          //                   fontWeight: FontWeight.w900,
          //                   color: Colors.black)),
          //         ),
          //         //numeric: true,
          //       ],
          //     ),
          //   ),
          //   height: 60,
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.grey.shade300, width: 1),
          //     borderRadius: const BorderRadius.only(
          //         bottomLeft: Radius.circular(0),
          //         bottomRight: Radius.circular(0)),
          //   ),
          // ),
          data == null || data.length == 0
              ? Container(
                  // height: MediaQuery.of(context).size.height / 2,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: val
                        ? Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Center(child: CircularProgressIndicator()),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(child: Text("Loading..."))
                              ],
                            ),
                          )
                        : const Center(
                            child: Text("No data found..."),
                          ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Wrap(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 1.9,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0)),
                        ),
                        child: SingleChildScrollView(
                          child: _searchResult.length != 0 ||
                                  controller.text.isNotEmpty
                              ? FutureBuilder(builder: (context, snapshot) {
                                  return _searchResult.length == 0
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Center(
                                                child: Text("No data found..."),
                                              ),
                                            ],
                                          ),
                                        )
                                      : DataTable(
                                          showBottomBorder: true,
                                          dataRowHeight: 60,
                                          columnSpacing: 20,
                                          columns: kTableColumns,
                                          rows: List.generate(
                                              _searchResult.length, (index) {
                                            // ignore: unused_local_variable
                                            var type = data[index]["type"];
                                            int status =
                                                int.parse(data[index]["type"]);

                                            // ignore: non_constant_identifier_names
                                            List<dynamic> Category = [
                                              "API",
                                              "Web",
                                              "Mobile",
                                              "Desktop",
                                              "Extension"
                                            ];
                                            List<dynamic> certificate = [
                                              "Download Certificate",
                                              "JSON View",
                                              " "
                                            ];

                                            List<dynamic> certificateIcon = [
                                              "assets/Images/download-icon.png",
                                              "assets/Images/json.png",
                                              // "assets/Images/json-viewer.png"

                                              ""
                                            ];
                                            // List<dynamic> certificateIcon = [
                                            //   Icons.picture_as_pdf,
                                            //   Icons.code_outlined,
                                            //   // "assets/Images/Downloadpdf.png",
                                            //   // "assets/Images/json.png",
                                            //   ""
                                            // ];
                                            int viewtypeindex =
                                                int.parse(viewType);
                                            DateTime time1 = DateTime.parse(
                                                "${_searchResult[index].createdAt}");
                                            var c = time1.toLocal();
                                            String formattedDate = DateFormat(
                                                    ' dd/MM/yyyy  |  h:mm:ss a'
                                                    //  'EEE,  dd  MMM  yyyy  |  h:mm a'
                                                    )
                                                .format(c);

                                            aa = {
                                              "name":
                                                  " ${_searchResult[index].name}",
                                              "txId":
                                                  "${_searchResult[index].txId}",
                                              "hash": "${data[index]["hash"]}",
                                              "createdAt": "$formattedDate"
                                            };

                                            return DataRow(cells: <DataCell>[
                                              DataCell(
                                                SizedBox(
                                                  width: 300,
                                                  child: Text(
                                                    _searchResult[index].name,
                                                    // data[index]['name'],
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                              DataCell(Text(
                                                  //'N/A',
                                                  Category[status],
                                                  style: const TextStyle(
                                                      fontSize: 15))),
                                              DataCell(Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: _searchResult[index]
                                                                .hash ==
                                                            _searchResult[index]
                                                                .originalDocHash
                                                        ? Colors.green
                                                        : Color.fromARGB(
                                                            232, 53, 136, 245)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0,
                                                          right: 5.0,
                                                          top: 5.0,
                                                          bottom: 5.0),
                                                  child: Text(
                                                    _searchResult[index].hash ==
                                                            _searchResult[index]
                                                                .originalDocHash
                                                        ? "STAMPED"
                                                        : "Signed & stamped"
                                                            .toUpperCase(),

                                                    // "STAMPED",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11),
                                                  ),
                                                ),
                                              )),
                                              // ignore: unnecessary_string_interpolations
                                              DataCell(Text('$formattedDate',
                                                  style: const TextStyle(
                                                      fontSize: 15))),
                                              DataCell(Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    _searchResult[index].code ==
                                                            null
                                                        ? ""
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  StampedDocument(
                                                                id: data[index]
                                                                    ["code"],
                                                              ),
                                                            ));
                                                  },
                                                  child: Text(
                                                      _searchResult[index]
                                                              .code ??
                                                          "--",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Color(
                                                              0xffff073D83))),
                                                ),
                                              )),
                                              DataCell(
                                                Center(
                                                  child: Wrap(
                                                    children: [
                                                      InkWell(
                                                        child: const Icon(
                                                          Icons
                                                              .visibility_outlined,
                                                          // size: 20,
                                                        ),
                                                        //  const Text("View",
                                                        //     style: TextStyle(
                                                        //         fontSize: 15,
                                                        //         // ignore: use_full_hex_values_for_flutter_colors
                                                        //         color: Color(
                                                        //             0xffff073D83))),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        StampedDocument(
                                                                  id: data[
                                                                          index]
                                                                      ["hash"],
                                                                ),
                                                              ));
                                                        },
                                                      ),
                                                      viewtypeindex == 2
                                                          ? SizedBox()
                                                          : const Text(" | "),
                                                      viewtypeindex == 2
                                                          ? SizedBox()
                                                          : InkWell(
                                                              child: Padding(
                                                                padding: viewtypeindex ==
                                                                        0
                                                                    ? const EdgeInsets
                                                                            .only(
                                                                        top: 3)
                                                                    : const EdgeInsets
                                                                            .only(
                                                                        top: 0),
                                                                child: viewtypeindex ==
                                                                        0
                                                                    ? Image
                                                                        .asset(
                                                                        certificateIcon[
                                                                            viewtypeindex],
                                                                        filterQuality:
                                                                            FilterQuality.high,
                                                                        cacheHeight:
                                                                            20,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .code_outlined,
                                                                      ),
                                                              ),
                                                              onTap: () {
                                                                viewtypeindex ==
                                                                        0
                                                                    ? setState(
                                                                        () {
                                                                        showAlertDialog(
                                                                            context);
                                                                        downloadCertificate(
                                                                            data[index]["_id"],
                                                                            _searchResult[index].name,
                                                                            context);
                                                                      })
                                                                    : showDialog<
                                                                        String>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                Dialog(
                                                                          shape:
                                                                              const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                750,
                                                                            child:
                                                                                Wrap(
                                                                              children: [
                                                                                Wrap(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(10.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          const Text(
                                                                                            "JSON View",
                                                                                            style: TextStyle(
                                                                                              fontSize: 25,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                          const Spacer(),
                                                                                          IconButton(onPressed: () => Navigator.pop(context, 'Cancel'), icon: Icon(Icons.cancel))
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(15.0),
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.all(10),
                                                                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Row(
                                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                                              children: [
                                                                                                IconButton(
                                                                                                  onPressed: () {
                                                                                                    Clipboard.setData(ClipboardData(text: aa.toString()));
                                                                                                    showSuccess(context, "data copied");
                                                                                                  },
                                                                                                  icon: const Icon(Icons.copy),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                            const SizedBox(),
                                                                                            // Text(json.encode(aa)),

                                                                                            const Text(
                                                                                              "{",
                                                                                              style: TextStyle(color: Color(0xFFe83e8c)),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.only(left: 20),
                                                                                              child: Wrap(children: [
                                                                                                Text("\"name\" : " "\"${data[index]["name"]}\"", style: const TextStyle(color: Color(0xFFe83e8c))),
                                                                                                Text("\"txId\" : " "\"${data[index]["txId"]}\"", style: const TextStyle(color: Color(0xFFe83e8c))),
                                                                                                Text("\"hash\" : " "\" ${data[index]["hash"]},\"", style: const TextStyle(color: Color(0xFFe83e8c))),
                                                                                                Text("\"createdAt\" : " "\"${formattedDate}\"", style: const TextStyle(color: Color(0xFFe83e8c))),
                                                                                                //data[index]["createdAt"]
                                                                                              ]),
                                                                                            ),

                                                                                            const Text("}", style: TextStyle(color: Color(0xFFe83e8c))),
                                                                                            const SizedBox(
                                                                                              height: 20,
                                                                                            )
                                                                                            // Text(data)
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    //  const Divider(),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                              },
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              // const DataCell(Text("view | Certificate",
                                              //     style: const TextStyle(fontSize: 11))),
                                            ]);
                                          }));
                                })
                              : FutureBuilder(builder: (context, snapshot) {
                                  return DataTable(
                                      dataRowHeight: 60,
                                      columnSpacing: 25,
                                      columns: kTableColumns,
                                      rows: List.generate(_userDetails.length,
                                          (index) {
                                        // ignore: unused_local_variable
                                        var type = data[index]["type"];
                                        int status =
                                            int.parse(data[index]["type"]);

                                        // ignore: non_constant_identifier_names
                                        List<dynamic> Category = [
                                          "API",
                                          "Web",
                                          "Mobile",
                                          "Desktop",
                                          "Extension"
                                        ];

                                        List<dynamic> certificate = [
                                          "Download Certificate",
                                          "JSON View",
                                          " "
                                        ];
                                        List<dynamic> certificateIcon = [
                                          "assets/Images/download-icon.png",
                                          "assets/Images/json.png",
                                          // "assets/Images/json-viewer.png"

                                          ""
                                        ];
                                        // List<dynamic> certificateIcon = [
                                        //   Icons.picture_as_pdf,
                                        //   Icons.code_outlined,
                                        //   ""
                                        // ];
                                        int viewtypeindex = int.parse(viewType);
                                        DateTime time1 = DateTime.parse(
                                            "${data[index]["createdAt"]}");
                                        var c = time1.toLocal();
                                        String formattedDate = DateFormat(
                                                ' dd/MM/yyyy  |  h:mm:ss a'
                                                // 'EEE,  dd  MMM  yyyy  |  h:mm a'
                                                )
                                            .format(c);

                                        return DataRow(cells: <DataCell>[
                                          DataCell(
                                            SizedBox(
                                              width: 300,
                                              child: Text(
                                                _userDetails[index].name,
                                                // data[index]['name'],
                                                style: const TextStyle(
                                                  overflow: TextOverflow.fade,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(
                                              //'N/A',
                                              Category[status],
                                              style: const TextStyle(
                                                  fontSize: 15))),
                                          DataCell(Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color:
                                                    _userDetails[index].hash ==
                                                            _userDetails[index]
                                                                .originalDocHash
                                                        ? Colors.green
                                                        : Color.fromARGB(
                                                            232, 53, 136, 245)),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 6.0,
                                                  right: 6,
                                                  top: 2,
                                                  bottom: 3),
                                              child: Text(
                                                _userDetails[index].hash ==
                                                        _userDetails[index]
                                                            .originalDocHash
                                                    ? "STAMPED"
                                                    : "Signed & stamped"
                                                        .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                              ),
                                            ),
                                          )),
                                          // ignore: unnecessary_string_interpolations
                                          DataCell(Text('$formattedDate',
                                              style: const TextStyle(
                                                  fontSize: 15))),
                                          DataCell(
                                            InkWell(
                                              hoverColor: Colors.transparent,
                                              onTap: () {
                                                _userDetails[index].code == null
                                                    ? ""
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StampedDocument(
                                                            id: data[index]
                                                                ["code"],
                                                          ),
                                                        ));
                                              },
                                              child: Center(
                                                child: Text(
                                                    _userDetails[index].code ??
                                                        "--",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color(
                                                            0xffff073D83))),
                                              ),
                                            ),
                                          ),
                                          DataCell(Center(
                                            child: Wrap(
                                              children: [
                                                Tooltip(
                                                  message: "View",
                                                  child: InkWell(
                                                    hoverColor:
                                                        Colors.transparent,
                                                    child: const Icon(
                                                      Icons.visibility_outlined,
                                                      size: 22,
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                StampedDocument(
                                                              id: data[index]
                                                                  ["hash"],
                                                            ),
                                                          ));
                                                    },
                                                  ),
                                                ),
                                                viewtypeindex == 2
                                                    ? SizedBox()
                                                    : const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 3.0,
                                                                right: 3.0),
                                                        child: Text(" | "),
                                                      ),
                                                viewtypeindex == 2
                                                    ? SizedBox()
                                                    : Tooltip(
                                                        message: certificate[
                                                            viewtypeindex], //"Download Certificate",
                                                        child: InkWell(
                                                          hoverColor: Colors
                                                              .transparent,
                                                          child: Padding(
                                                            padding: viewtypeindex ==
                                                                    0
                                                                ? const EdgeInsets
                                                                        .only(
                                                                    top: 3)
                                                                : const EdgeInsets
                                                                        .only(
                                                                    top: 0),
                                                            child:
                                                                viewtypeindex ==
                                                                        0
                                                                    ? Image
                                                                        .asset(
                                                                        certificateIcon[
                                                                            viewtypeindex],
                                                                        filterQuality:
                                                                            FilterQuality.high,
                                                                        cacheHeight:
                                                                            20,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .code_outlined,
                                                                      ),
                                                          ),
                                                          onTap: () {
                                                            viewtypeindex == 0
                                                                ? setState(() {
                                                                    showAlertDialog(
                                                                        context);
                                                                    downloadCertificate(
                                                                        data[index]
                                                                            [
                                                                            "_id"],
                                                                        _userDetails[index]
                                                                            .name,
                                                                        context);
                                                                  })
                                                                : showDialog<
                                                                    String>(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        Dialog(
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10.0))),
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            750,
                                                                        child:
                                                                            Wrap(
                                                                          children: [
                                                                            Wrap(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(10.0),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      const Text(
                                                                                        "JSON View",
                                                                                        style: TextStyle(
                                                                                          fontSize: 25,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                      const Spacer(),
                                                                                      IconButton(onPressed: () => Navigator.pop(context, 'Cancel'), icon: Icon(Icons.cancel))
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(15.0),
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.all(10),
                                                                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                                          children: [
                                                                                            IconButton(
                                                                                              onPressed: () {
                                                                                                Clipboard.setData(ClipboardData(text: aa.toString()));
                                                                                                //Dailog_toast().showSuccess(context, "data copied");
                                                                                                showSuccess(context, "data copied");
                                                                                              },
                                                                                              icon: Icon(Icons.copy),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                        const SizedBox(),
                                                                                        // Text(json.encode(aa)),

                                                                                        const Text(
                                                                                          "{",
                                                                                          style: TextStyle(color: Color(0xFFe83e8c)),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(left: 20),
                                                                                          child: Wrap(children: [
                                                                                            Text("\"name\" : " "\"${data[index]["name"]}\"", style: const TextStyle(color: Color(0xFFe83e8c))),
                                                                                            Text("\"txId\" : " "\"${data[index]["txId"]}\"", style: const TextStyle(color: Color(0xFFe83e8c))),
                                                                                            Text("\"hash\" : " "\" ${data[index]["hash"]},\"", style: const TextStyle(color: Color(0xFFe83e8c))),
                                                                                            Text("\"createdAt\" : " "\"${data[index]["createdAt"]}\"", style: const TextStyle(color: Color(0xFFe83e8c))),
                                                                                          ]),
                                                                                        ),

                                                                                        const Text("}", style: TextStyle(color: Color(0xFFe83e8c))),
                                                                                        const SizedBox(
                                                                                          height: 20,
                                                                                        )
                                                                                        // Text(data)
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                //  const Divider(),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                          },
                                                        ),
                                                      )
                                              ],
                                            ),
                                          ))
                                          // const DataCell(Text("view | Certificate",
                                          //     style: const TextStyle(fontSize: 11))),
                                        ]);
                                      }));
                                }),
                        ),
                      ),
                    ],
                  ),
                ),
          ListTile(
            dense: true,
            trailing: Text(
                "Displaying a total of  ${count == null ? "0" : count}  stamps"),
          )
        ],
        // ),
        // )
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

////// Columns in table.
const kTableColumns = <DataColumn>[
  DataColumn(
    label: Text(
      'FILENAME',
      style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black),
    ),
  ),
  DataColumn(
    label: Text('CATEGORY',
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black)),

    //numeric: true,
  ),
  DataColumn(
    label: Text('STATUS',
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black)),
    // numeric: true,
  ),
  DataColumn(
    label: Text('TIMESTAMP (GMT)',
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black)),
    // numeric: true,
  ),
  DataColumn(
    //numeric: true,
    label: Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Text('SHORT CODE',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black)),
    ),
    // numeric: true,
  ),
  DataColumn(
    label: Padding(
      padding: EdgeInsets.only(left: 18.0),
      child: Text('ACTIONS',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black)),
    ),
    //numeric: true,
  ),
];

////// Data class.
class Dessert {
  Dessert(
    this.filename,
    this.Category,
    this.stamped,
    this.date,
    this.action,
  );
  final String filename;
  // ignore: non_constant_identifier_names,
  var Category, stamped, date, action;

  bool selected = false;
}
