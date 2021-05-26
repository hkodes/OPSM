
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'carousel_slider.dart';
import 'speed_dial.dart';
import 'speed_dial_child.dart';

var _isClickedMessage = false;
Color _themecolor = Colors.black;
var _appbarText = Text(
  "Social Media",
  style: TextStyle(color: Colors.black),
);

void main() {
  runApp(SocialMedia());
}

class SocialMedia extends StatefulWidget {
  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Social Media",
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: _appbarText),
        floatingActionButton: SpeedDial(
          openCloseDial: isDialOpen,
          icon: Icons.add,
          backgroundColor: Colors.green,
          activeBackgroundColor: Colors.red,
          iconTheme: IconThemeData(color: Colors.white),
          activeIcon: Icons.remove,
          children: [
            SpeedDialChild(
                backgroundColor: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    (Icons.message),
                    color: Colors.white,
                  ),
                ),
                label: "Message",
                labelStyle: TextStyle(
                  fontSize: 18,
                ),
                onTap: () {
                  setState(() {
                    _isClickedMessage = true;
                  });
                }),
          ],
        ),
        body: Stack(
          children: [
            Container(
              child: WillPopScope(
                onWillPop: () async {
                  if (isDialOpen.value) {
                    isDialOpen.value = false;
                    return false;
                  }
                  return true;
                },
                child: Container(),
              ),
            ),
            _isClickedMessage
                ? WillPopScope(
                    onWillPop: () async {
                      setState(() {
                        _appbarText = Text(
                          "Social Media",
                          style: TextStyle(color: Colors.black),
                        );
                        _isClickedMessage = false;
                      });
                      return await false;
                    },
                    child: _Message())
                : Container(),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatefulWidget {
  @override
  __MessageState createState() => __MessageState();
}

class __MessageState extends State<_Message> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: [
          getListView(Colors.deepPurple),
          getListView(Colors.orange),
          getListView(Colors.brown),
          getListView(Colors.pink)
        ],
        options: CarouselOptions(
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            viewportFraction: 0.7,
            height: MediaQuery.of(context).size.height,
            scrollDirection: Axis.horizontal));
  }

  List<Widget> getListItems() {
    List<List<String>> _list = [
      ["Akash", "1234567890"],
      ["Abhinav", "0987654321"],
      ["Hishore", "0111111111"],
      ["Yash", "0222222222"]
    ];
    List<Widget> _finallist = [];
    for (var _listdata in _list) {
      _finallist.add(Card(
        child: ListTile(
          leading: Icon(
            Icons.face,
            size: 35,
            color: _themecolor,
          ),
          title: Text(
            _listdata[0],
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: _themecolor),
          ),
          subtitle: Text(
            _listdata[1],
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w400, color: _themecolor),
          ),
        ),
      ));
    }
    return _finallist;
  }

  getListView(Color color) {
    setState(() {
      _themecolor = color;
    });
    return AlertDialog(
      backgroundColor:_themecolor,
      contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      content: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        height: MediaQuery.of(context).size.height - 500,
        child: Container(
            child: Container(
                padding: EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: getListItems(),
                  ),
                ))),
      ),
    );
  }
}
