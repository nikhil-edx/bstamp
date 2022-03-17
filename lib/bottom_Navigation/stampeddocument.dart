import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:progress_indicator_button/progress_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../backend.dart';

class StampedDocument extends StatefulWidget {
  final String id;

  const StampedDocument({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _StampedDocumentState createState() => _StampedDocumentState();
}

class _StampedDocumentState extends State<StampedDocument> {
  @override
  void initState() {
    super.initState();
    _viewDocument();
  }

  // ignore: prefer_typing_uninitialized_variables
  var data, metadata;
  List meta = [];
  String formattedDate;
  bool val = false;
  List<String> _metaList1 = List<String>.empty(growable: true);
  List<String> _metaList2 = List<String>.empty(growable: true);
  String suffix = 'th';
  _viewDocument() async {
    setState(() {
      val = true;
    });

    // ignore: unused_local_variable
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var url = Uri.parse("https://${Backend.baseurl}/hash?id=${widget.id}");

    var response = await http.get(
      url,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        val = false;
        var jsonResponse = convert.jsonDecode(response.body);

        data = jsonResponse['data'];

        meta = data['metaData'];

        meta.length == 0 ? print("") : _metadata();

        DateTime time1 = DateTime.parse("${data["timestamp"]}");
        var c = time1.toLocal();
        String month = DateFormat('MMMM').format(c);
       
        formattedDate = DateFormat('MMMM dd, yyyy  |  h:mm:ss a').format(c);
        var f = formattedDate.split(",");
       
        ordinal_suffix_of(c.day, month, f[1]);
        // DateFormat('EEE,  dd  MMM  yyyy  |  h:mm:ss a').format(c);
      });
    } else {
      setState(() {
        val = false;
      });

      var jsonResponse = convert.jsonDecode(response.body);
      errormsg = jsonResponse['message'];
    }
  }

  ordinal_suffix_of(i, month, f) {
    var j = i % 10, k = i % 100;
    if (j == 1 && k != 11) {
      return {formattedDate = month + " " + "$i" + "st" + ", " + f,"$i"+"st"};
    }
    if (j == 2 && k != 12) {
      return {formattedDate = month + " " + "$i" + "nd" + ", " + f, "$i"+ "nd"};
    }
    if (j == 3 && k != 13) {
      return {formattedDate = month + " " + "$i" + "rd" + ", " + f, "$i"+ "rd"};
    }
    return {
      formattedDate = month + " " + "$i$suffix" + ", " + f,
     
    };
  }

  _metadata() {
    meta = data['metaData'];
    var a;
    a = meta[0];

    Map map = a;

    map.forEach((k, v) {});

    map.entries.forEach((e) {
      _metaList1.add(e.key.toString());
      _metaList2.add(e.value.toString());
    });
  }

  var errormsg;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        // fontFamily: 'Lato',
        textTheme: GoogleFonts.latoTextTheme(
          // headline1: GoogleFonts.lato(textStyle: textTheme.headline1),
          Theme.of(context).textTheme,
        ),
      ),
      home: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 200, top: 50, right: 200),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  bottomOpacity: 2,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: Container(
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 12,
                    ),
                    child: BackButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  title: const Center(
                      child: Text(
                    "Stamped Document",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  )),
                ),
                body: SingleChildScrollView(
                  child: data == null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 250.0),
                          child: val == true
                              ? const Center(child: CircularProgressIndicator())
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent[700],
                                        size: 50,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Center(
                                        child: Text(
                                      //  errormsg,
                                      "Stamp is Invalid",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black),
                                    )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Your stamp is invalid. Please recheck the Hash/File or the shortcode which you have searched.",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                ),
                        )
                      // ignore: avoid_unnecessary_containers
                      : Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child: Column(
                            children: [
                              // const SizedBox(
                              //   height: 30,
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: const [
                              //     Text(
                              //       "Stamped Document",
                              //       style: TextStyle(
                              //           fontSize: 25,
                              //           fontWeight: FontWeight.w900,
                              //           color: Colors.black),
                              //     )
                              //   ],
                              // ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 0,
                                      child: Wrap(
                                        children: [
                                          Container(
                                            height: 160,
                                            decoration: BoxDecoration(

                                                // color: Color(0xffff073D83) ,
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: PrettyQr(
                                                // typeNumber: 3,
                                                size: 140,
                                                errorCorrectLevel:
                                                    QrErrorCorrectLevel.M,
                                                roundEdges: true,
                                                data:
                                                    "https://bstamp.edexa.com/${data['hash']}",
                                                // "https://bstampweb.io-world.com/stamp/${data['hash']}",https://bstamp.edexa.com/
                                                image: const AssetImage(
                                                  "assets/Images/bStamp.png",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListTile(
                                          // leading: Wrap(
                                          //   children: [
                                          //     Container(
                                          //       // height: 140,
                                          //       decoration: BoxDecoration(

                                          //           // color: Color(0xffff073D83) ,
                                          //           border: Border.all(
                                          //               color: Colors.grey, width: 1),
                                          //           borderRadius:
                                          //               const BorderRadius.all(
                                          //                   Radius.circular(10))),
                                          //       child: Padding(
                                          //         padding: const EdgeInsets.all(10.0),
                                          //         // child:
                                          //         child: PrettyQr(
                                          //           // typeNumber: 3,
                                          //           size: 120,

                                          //           errorCorrectLevel:
                                          //               QrErrorCorrectLevel.L,
                                          //           roundEdges: true,

                                          //           data:
                                          //               "https://bstampweb.io-world.com/stamp/${data['hash']}" //""data['hash'],
                                          //           ,

                                          //           // image: const AssetImage(
                                          //           //   "assets/Images/bStamp.png",
                                          //           // ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          title: const Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text("Document Hash Imprint",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.black)),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffff073D83),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: Center(
                                                    child: ListTile(
                                                      title: Text(data['hash'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16,
                                                                  // fontWeight: FontWeight.w900,
                                                                  color: Colors
                                                                      .white)),
                                                      trailing: IconButton(
                                                        // tooltip: "data copied",
                                                        icon: const Icon(
                                                          Icons.copy,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          Clipboard.setData(
                                                              ClipboardData(
                                                                  text: data[
                                                                      'hash']));

                                                          showSuccess(context,
                                                              " Copied! ");
                                                        },
                                                        color: Colors.blue[200],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Text(
                                                  "A document named ${data['filename']} has been stamped via our service on the Blockchain.",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                          isThreeLine: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              const ListTile(
                                leading: Text(
                                  " File Information",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                  width: 250,
                                                  child: Text(
                                                      "short code"
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color:
                                                              Colors.black))),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 30.0),
                                              child: SizedBox(
                                                  // width: MediaQuery.of(context)
                                                  //         .size
                                                  //         .width /
                                                  //     3,
                                                  // flex: 2,
                                                  child: Text(
                                                data['code'],
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    overflow:
                                                        TextOverflow.visible),
                                              )),
                                            ),
                                            Spacer(),
                                            IconButton(
                                              // tooltip: "data copied",
                                              icon: const Icon(
                                                Icons.copy,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: data['code']));

                                                showSuccess(context, "Copied!");
                                              },
                                              color: Colors.blue[200],
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        //
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                  width: 250,
                                                  child: Text(
                                                      "Transaction ID"
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color:
                                                              Colors.black))),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0.0),
                                              child: Text(
                                                data['txid'],
                                                //  softWrap: false,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    overflow:
                                                        TextOverflow.visible),
                                              ),
                                            ),
                                            //  ),
                                            Spacer(),
                                            IconButton(
                                              // tooltip: "data copied",
                                              icon: const Icon(
                                                Icons.copy,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: data['txid']));

                                                showSuccess(context, "Copied!");
                                              },
                                              color: Colors.blue[200],
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        //Hide Transaction information details for sometime
                                        // Row(
                                        //   children: [
                                        //     Padding(
                                        //       padding:
                                        //           const EdgeInsets.all(10.0),
                                        //       child: Container(
                                        //           width: 250,
                                        //           child: Text(
                                        //               "Transaction Information"
                                        //                   .toUpperCase(),
                                        //               style: const TextStyle(
                                        //                   fontWeight:
                                        //                       FontWeight.w900,
                                        //                   color:
                                        //                       Colors.black))),
                                        //     ),
                                        //     const SizedBox(
                                        //       width: 20,
                                        //     ),
                                        //     SizedBox(
                                        //         //  flex: 2,
                                        //         child: RichText(
                                        //       text: const TextSpan(
                                        //           text:
                                        //               "explorer.edexa.com (coming soon)",
                                        //           style: TextStyle(
                                        //             color: Color(0xffff073D83),
                                        //             decoration: TextDecoration
                                        //                 .underline,
                                        //           )),
                                        //     ))
                                        //   ],
                                        // ),
                                        // const Divider(),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                  width: 250,
                                                  child: Text(
                                                      "TimeStamp".toUpperCase(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color:
                                                              Colors.black))),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Flexible(
                                                //  flex: 2,
                                                child: Text(
                                              "$formattedDate",
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ))
                                          ],
                                        ),

                                        const Divider(),

                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                  width: 250,
                                                  child: Text(
                                                      "Status".toUpperCase(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color:
                                                              Colors.black))),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              // flex: 2,
                                              child: data['hash'] ==
                                                      data['originalDocHash']
                                                  ? Text(
                                                      "Stamped",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  : Text(
                                                      "Signed & Stamped",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                  width: 250,
                                                  child: Text(
                                                      "Validate Transaction"
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color:
                                                              Colors.black))),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                                //  flex: 2,
                                                child: InkWell(
                                              onTap: () {
                                                launch(
                                                    'https://explorer.edexa.com/search/${data['txid']}');
                                              },
                                              child: const Text(
                                                  "https://explorer.edexa.com/",
                                                  style: TextStyle(
                                                      color: Colors.green)),
                                            ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              meta.length == 0
                                  ? Container()
                                  : const ListTile(
                                      leading: Text(
                                        "Meta Information",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black),
                                      ),
                                    ),

                              meta.length == 0
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                // height: 200,
                                                child: ListView.separated(
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            Divider(height: 1),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _metaList1.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Container(
                                                                    width: 250,
                                                                    child: Text(
                                                                        "${_metaList1[index]}"
                                                                            .toUpperCase(),
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w900,
                                                                            color: Colors.black))),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Flexible(
                                                                  child: Text(
                                                                "${_metaList2[index]}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ))
                                                            ],
                                                          ),
                                                          //  Divider()
                                                        ],
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                              const ListTile(
                                leading: Text(
                                  "Owner Information",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          // height: 200,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                    width: 250,
                                                    child: Text(
                                                        "Owner name"
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color:
                                                                Colors.black))),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              SizedBox(
                                                  child: Text(
                                                data["username"],
                                              )),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              data["userVerify"] == 0
                                                  ? SizedBox()
                                                  : Icon(
                                                      Icons.verified,
                                                      color: Colors.green,
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // const ListTile(
                              //   leading: Text(
                              //     "PDF Certificate",
                              //     style: TextStyle(
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.w900,
                              //         color: Colors.black),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(10.0),
                              //   child: TextFormField(
                              //     // controller: controller,
                              //     decoration: InputDecoration(
                              //       isDense: true, // important line
                              //       //contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              //       suffixIcon: SizedBox(
                              //         width: 200,
                              //         child: ProgressButton(
                              //           color: Color(0xffff073D83),
                              //           borderRadius:
                              //               BorderRadius.all(Radius.circular(5)),
                              //           strokeWidth: 1,
                              //           child: const Text(
                              //             "Download Certificate",
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 14,
                              //             ),
                              //           ),
                              //           onPressed:
                              //               (AnimationController controller) async {
                              //             //  updateAlbum();

                              //             //  httpJob(controller);

                              //             ScaffoldMessenger.of(context).showSnackBar(
                              //               const SnackBar(
                              //                   content: Text('Processing Data...')),
                              //             );
                              //           },
                              //         ),
                              //       ),
                              //       enabled: true,
                              //       border: const OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.grey)),
                              //       focusedBorder: const OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: Colors.grey //Color(0xffff073D83),
                              //               )),
                              //       //focusedBorder: OutlineInputBorder( borderSide: new BorderSide(color: Colors.grey)),
                              //       labelText: "Enter your email",
                              //       labelStyle: const TextStyle(color: Colors.grey

                              //           /// Color(0xffff073D83),
                              //           ),
                              //     ),
                              //     validator: (value) {
                              //       if (value == null || value.isEmpty) {
                              //         return 'Please enter valid Email';
                              //       }
                              //       return null;
                              //     },
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: const [
                              //       Text(
                              //         "Enter your e-mail inorder to unlock your download",
                              //         style:
                              //             TextStyle(color: Colors.grey, fontSize: 10),
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _list(index) {
    return Column(
      children: [
        Container(
          // height: 200,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: index,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              width: 250,
                              child: Text("${_metaList1[index]}".toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black))),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                            //  flex: 2,
                            child: Text(
                          "${_metaList2[index]}",
                          style: TextStyle(color: Colors.grey),
                        ))
                      ],
                    ),
                    Divider()
                  ],
                );
              }),
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

//  meta.length == 0
//                                           ? Container()
//                                           : Wrap(
//                                               children: [
//                                                 _list(_metaList1.length)
//                                               ],
//                                             ),
