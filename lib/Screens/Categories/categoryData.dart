import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laigo/data/constant.dart';

class CategoryOptionsData extends StatefulWidget {
  final nameOfCategory;
  final docid;
  CategoryOptionsData({this.nameOfCategory, this.docid});
  @override
  _CategoryOptionsDataState createState() => _CategoryOptionsDataState();
}

class _CategoryOptionsDataState extends State<CategoryOptionsData> {
  final db = FirebaseFirestore.instance;
  String categoryName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(140.0),
            child: CustomAppBar(
              height: 120,
              name: widget.nameOfCategory,
              contextcome: context,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection('openersCategories')
                        .doc(widget.docid)
                        .collection('openersData')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return CategoryOptionsdata(
                                        name: widget.nameOfCategory,
                                        index: index,
                                        docid: widget.docid,
                                      );
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                          title: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                            "${snapshot.data.docs[index].data()['openersLine'].toString()}",
                                            style: GoogleFonts.raleway(
                                                color: Colors.black,
                                                fontSize: 22)),
                                      )),
                                      Divider(color: Colors.grey),
                                    ],
                                  )),
                            );
                          });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryOptionsdata extends StatefulWidget {
  final String name;
  final int index;
  final docid;
  CategoryOptionsdata({this.name, this.index, this.docid});
  @override
  _CategoryOptionsdataState createState() => _CategoryOptionsdataState();
}

String data;

int lengthOfsentences;
int indexValue1 = 0;

class _CategoryOptionsdataState extends State<CategoryOptionsdata> {
  @override
  void initState() {
    super.initState();
    setIndex();
  }

  void setIndex() {
    setState(() {
      indexValue1 = widget.index;
    });
  }

  void increase() {
    print(indexValue1);

    setState(() {
      if (indexValue1 >= 0) {
        if (indexValue1 + 1 < lengthOfsentences) {
          indexValue1++;
        }
      }
    });
  }

  void decrease() {
    setState(() {
      if (indexValue1 > 0) {
        if (indexValue1 + 1 <= lengthOfsentences) {
          if (indexValue1 < 0) {
            return;
          } else {
            indexValue1--;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffeeeeee),
        appBar: CustomAppBar2(
          name: "Sentence",
          height: 120,
          contextcome: context,
          dataofClipboard: data,
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder(
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data == null) {
                            return Center(child: CircularProgressIndicator());
                          }
                          data = snapshot.data.docs[widget.index]
                              .data()['openersLine']
                              .toString();
                          lengthOfsentences = snapshot.data.docs.length;
                          return Container(
                            margin: EdgeInsets.only(left: 60),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(
                                  '${snapshot.data.docs[indexValue1].data()['openersLine'].toString()}',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20)),
                                color: Color(0XFF369AFA),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xfff6f5f5),
                                      blurRadius: 10,
                                      offset: Offset(0, 3))
                                ]),
                            height: 180,
                            width: double.infinity,
                          );
                        },
                        stream: FirebaseFirestore.instance
                            .collection("openersCategories")
                            .doc(widget.docid)
                            .collection('openersData')
                            .snapshots()),
                    SizedBox(height: 60),
                    StreamBuilder(
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data == null) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Container(
                            margin: EdgeInsets.only(right: 60),
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Usage:",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      Text(
                                          ' \n${snapshot.data.docs[indexValue1].data()['openersExplanation'].toString()}',
                                          style: GoogleFonts.quicksand(
                                              fontSize: 18,
                                              color: Colors.black)),
                                    ],
                                  ),
                                )),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20)),
                                color: Color(0xffE2E2E2),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xfff6f5f5),
                                      blurRadius: 10,
                                      offset: Offset(0, 3))
                                ]),
                            height: 250,
                            width: double.infinity,
                          );
                        },
                        stream: FirebaseFirestore.instance
                            .collection("openersCategories")
                            .doc(widget.docid)
                            .collection('openersData')
                            .snapshots()),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            decrease();
                          },
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            size: 40,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              increase();
                            },
                            child: Icon(Icons.arrow_forward_ios_outlined,
                                size: 40))
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomAppBar2 extends PreferredSize {
  final double height;
  String name;
  BuildContext contextcome;
  final dataofClipboard;

  CustomAppBar2(
      {this.height = kToolbarHeight,
      this.name,
      this.contextcome,
      this.dataofClipboard});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kAppbarColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(contextcome).pop();
                  },
                  child: Icon(Icons.arrow_back_ios_outlined,
                      size: 40, color: Colors.grey),
                ),
              ),
              SizedBox(width: 100),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  BuildAppbarItems2(name1: name),
                ],
              ),
             SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              InkWell(
                onTap: () {
                  Clipboard.setData(new ClipboardData(text: data ?? "wait"));
                  Get.snackbar(
                    "ClipBoard",
                    "Text Copied",
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 30,
                    child: Icon(
                      Icons.copy,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class BuildAppbarItems2 extends StatelessWidget {
  BuildAppbarItems2({Key key, this.name1}) : super(key: key);
  final name1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: [
              Text("${name1.toString()}",
                  style: TextStyle(
                      fontSize: 30,
                      color: Color(0xff427FA4),
                      fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends PreferredSize {
  final double height;
  String name;
  BuildContext contextcome;

  CustomAppBar({this.height = kToolbarHeight, this.name, this.contextcome});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kAppbarColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(contextcome).pop();
                  },
                  child: Icon(Icons.arrow_back_ios_outlined,
                      size: 40, color: Colors.grey),
                ),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  BuildAppbarItems(name1: name),
                ],
              ),
            ],
          ),
        ));
  }
}

class BuildAppbarItems extends StatelessWidget {
  BuildAppbarItems({Key key, this.name1}) : super(key: key);
  final name1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Text("${name1.toString()}",
                    style: TextStyle(
            fontSize: 28,
            color: Color(0xff427FA4),
            fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
