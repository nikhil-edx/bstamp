import 'package:bStamp/sectioned_list_view.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicator_button/progress_button.dart';

class MetaFile extends StatefulWidget {
  const MetaFile({Key key}) : super(key: key);

  @override
  _MetaFileState createState() => _MetaFileState();
}

class _MetaFileState extends State<MetaFile> {
  int i = 3;
  List name1 = [];
  List a1 = [];
  int count = 0;
  List<TextEditingController> labelController = [];
  List<TextEditingController> descriptionController = [];
  TextEditingController c = TextEditingController();
  TextEditingController c1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2, // 1.3,
            height: 500, // MediaQuery.of(context).size.width / 2,
            child: Wrap(
              children: [
                Row(
                  children: [
                    const Text(
                      "Stamp MetaData",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Spacer(),
                    IconButton(
                        hoverColor: Colors.transparent,
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pop();
                        },
                        icon: const Icon(Icons.cancel_outlined))
                  ],
                ),
                const Divider(),
                SizedBox(
                    width: MediaQuery.of(context).size.width, // 1.3,
                    height: 2 > 1
                        ? MediaQuery.of(context).size.width * 0.2
                        : MediaQuery.of(context).size.height / 4.6,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: FlutterSectionListView(
                          numberOfRowsInSection: (int section) {
                        return i; // a1[section]; //items[section].length;
                      }, numberOfSection: () {
                        return i; //indexx; //selectedUserss.length;
                      }, rowWidget: (int section, int row) {
                        return GestureDetector(
                          child:
                              //  ListView.builder(
                              //     itemCount: count, //arr.length,
                              //     //selectedUserss.length,
                              //     itemBuilder: (context, index) {
                              // descriptionController
                              //     .add(TextEditingController());
                              // labelController.add(TextEditingController());

                              Column(
                            children: [
                              Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: TextFormField(
                                            controller:
                                                c, // labelController[0],

                                            //  Controller,
                                            onChanged: (v) {
                                              // setState(() {
                                              // String a = Controller.text;

                                              // var labeltext = a.trim();
                                              // label.add(labeltext); //Controller.text;
                                              //  });
                                            },
                                            decoration: InputDecoration(
                                              isDense: true,
                                              enabled:
                                                  section == 0 || section == 1
                                                      ? false
                                                      : true,
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 2,
                                                          color: Colors
                                                              .grey // Color(0xffff073D83),
                                                          )),
                                              hintText: "Label ",
                                              labelStyle: const TextStyle(
                                                  color: Colors
                                                      .grey // Color(0xffff073D83),
                                                  ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter valid Label';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: TextFormField(
                                            controller:
                                                c1, // descriptionController[0], // Controller1,
                                            onChanged: (v) {
                                              //  setState(() {
                                              // String a = Controller1.text;
                                              // var desctext = a.trim();
                                              // desc.add(desctext); //Controller.text;
                                              //  });
                                            },
                                            decoration: InputDecoration(
                                              isDense: true,
                                              enabled:
                                                  section == 0 || section == 1
                                                      ? false
                                                      : true,
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 2,
                                                          // ignore: use_full_hex_values_for_flutter_colors
                                                          color: Colors
                                                              .grey //Color(0xffff073D83),
                                                          )),
                                              hintText: "Description ",
                                              labelStyle: const TextStyle(
                                                  color: Colors
                                                      .grey // Color(0xffff073D83),
                                                  ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter valid Description';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: MouseRegion(
                                            onEnter: (event) {
                                              setState(() {
                                                section == 0 || section == 1
                                                    ? print("")
                                                    : name1.add(section);
                                                //  a = true;
                                              });
                                            }, //_incrementEnter,
                                            onExit: (event) {
                                              setState(() {
                                                section == 0 || section == 1
                                                    ? print("")
                                                    : name1.remove(section);
                                                //a = false;
                                              });
                                            }, //_incrementEnterr,
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  i--;

                                                  count--;
                                                });
                                              },
                                              icon: Image.asset(
                                                "assets/Images/delete.png",
                                                filterQuality:
                                                    FilterQuality.medium,
                                                color: name1.contains(0)
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          //  }),
                          onTap: () {
                            setState(() {
                              // items[section][row] =
                              //     items[section][row] == '0' ? '1' : '0';
                              // selectedSection = section;
                              // selectedIndex = row;
                            });
                          },
                        );
                      }, sectionWidget: (int section) {
                        return Row(
                          children: [
                            const Text(
                              "mgbhcghkjn",

                              ///    indexx == 1 ? filename : filenameList[section],
                              //"${filenameList[index]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const Spacer(),
                            InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  i++;
                                  count += 1;
                                  a1[section] = count;
                                });
                              },
                              child: MouseRegion(
                                onEnter: (e) {
                                  setState(() {
                                    //  color = Color(0xffff005397);
                                  });
                                },
                                onExit: (e) {
                                  setState(() {
                                    //   color = Color(0xffff073d83);
                                  });
                                },
                                child: Text(count != 7 ? "Add Metadata" : "",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        // ignore: use_full_hex_values_for_flutter_colors
                                        color: // filename == null
                                            // ?
                                            Colors.grey
                                        // : color //Color(0xffff005397)
                                        )),
                              ),
                            ),
                          ],
                        );
                      }
                          // },
                          ),
                    )),
                // SizedBox(
                //   height: 80,
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                // const SizedBox(
                //   width: 20,
                // ),
                // SizedBox(
                //   height: 60,
                //   width: 130,
                //   child: IgnorePointer(
                //       ignoring:false,// filename == null

                //  ||
                //         labeltext == '' ||
                //         desctext == '' ||
                //         desctext == null ||
                //         labeltext == null ||
                //         uri == null
                // ? true
                // : false,
                //       child: ProgressButton(
                //           color: filename == null ||
                //                   labelController.isEmpty ||
                //                   descriptionController.isEmpty
                //               // ||
                //               //         labeltext == '' ||
                //               //         desctext == '' ||
                //               //         desctext == null ||
                //               //         labeltext == null ||
                //               //         uri == null
                //               ? Colors.grey
                //               : Color(0xffff073d83),
                //           borderRadius: BorderRadius.all(Radius.circular(5)),
                //           strokeWidth: 2,
                //           child: Text(
                //             "Stamp".toUpperCase(),
                //             style: const TextStyle(
                //               fontWeight: FontWeight.w600,
                //               color: Colors.white,
                //               fontSize: 16,
                //             ),
                //           ),
                //           onPressed: (v) {
                //             // Navigator.pop(context);

                //             if (_formKey2.currentState.validate()) {
                //               //  submitdata = true;
                //               for (int i = 0; i < arr.length; i++) {
                //                 label.addAll({labelController[i].text});
                //                 desc.addAll({descriptionController[i].text});
                //               }

                //             }
                //           })),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
