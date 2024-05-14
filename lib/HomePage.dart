import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ColorConstants.dart';
import 'EmptyPage.dart';
import 'ProfileSheet.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? t = null;
  var data = <Object>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.pageColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Contacts",
                      style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.black)),
                  Expanded(flex: 1, child: Container()),
                  IconButton(
                    icon: Image.asset('assets/images/add.png'),
                    color: Colors.blue,
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext bc) {
                            return Wrap(children: <Widget>[
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(25.0),
                                          topRight:
                                              const Radius.circular(25.0))),
                                  child: ProfileSheet(),
                                ),
                              )
                            ]);
                          });
                    },
                  )
                ],
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10.0),
                    Icon(
                      Icons.search,
                      color: ColorConstants.grey,
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search by name',
                            hintStyle: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: ColorConstants.grey)),
                        onChanged: (str) {
                          print(str);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: data.isEmpty ? EmptyPage() : Placeholder(),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    setState(() {
      t = "Muhittin";
    });
  }

  void update(int id, String name) {
    setState(() {
      // update data here
    });
  }
}
