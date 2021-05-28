import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'carousel_slider.dart';
import 'speed_dial.dart';
import 'speed_dial_child.dart';

var _isClickedMessage = false;
var _isPost = false;
var _isCall = false;
var _isVideoCall = false;
Color _themecolor = Colors.black;
var _appbarText = Text(
  "Social Media",
  style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
);

List<Messages> messages = [];// Class Messages is at the end of the code
List<String> people = [];
String names="";
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_performance_channel",
    "high_important_notification",
    "This channel is used for sending important notification",
    groupId: "com.example.notification_app",
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
new FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  var initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("Message retrived");

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    messages.add(new Messages(notification!.title!, notification.body!));

    for (int i = 0; i < messages.length; i++) {
      people.add(messages[i].getTitle());
    }

    if (notification != null && android != null && messages.length - 1 == 0) {
      flutterLocalNotificationsPlugin.show(
          0,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  groupKey: "com.example.notification_app",
                  color: Colors.blue,
                  playSound: true,
                  setAsGroupSummary: true,
                  icon: '@mipmap/ic_launcher')));
    }
    else {
      print("Peoples: ${people.length}");

      if(people.length==2){
        names+=people[0]+" and "+people[1]+" messaged you.";
      }
      else{
        names+=people[0]+", "+people[1]+"and ${people.length-2} other messaged you.";

      }
      InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
          people,
          contentTitle: '${people.length} messages',
          summaryText: '');
      AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          channel.id, channel.name, channel.description,
          styleInformation: inboxStyleInformation,
          setAsGroupSummary: true,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher');
      NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, 'Attention', names, platformChannelSpecifics);
    }
  });
  //
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(SocialMedia());
}

class SocialMedia extends StatefulWidget {
  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("token: $token");
  }

  @override
  void initState() {
    
    super.initState();

    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Message retrived");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      messages.add(new Messages(notification!.title!, notification.body!));

      for (int i = 0; i < messages.length; i++) {
        people.add(messages[i].getTitle());
      }

      if (notification != null && android != null && messages.length - 1 == 0) {
        flutterLocalNotificationsPlugin.show(
            0,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    groupKey: "com.example.notification_app",
                    color: Colors.blue,
                    playSound: true,
                    setAsGroupSummary: true,
                    icon: '@mipmap/ic_launcher')));
      }
      else {
        print("Peoples: ${people.length}");

        if(people.length==2){
          names+=people[0]+" and "+people[1]+" messaged you.";
        }
        else{
          names+=people[0]+", "+people[1]+" and ${people.length-2} other messaged you.";

        }
        InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
            people,
            contentTitle: '${people.length} messages',
            summaryText: '');
        AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            styleInformation: inboxStyleInformation,
            setAsGroupSummary: true,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher');
        NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0, 'Attention', names, platformChannelSpecifics);
      }
    });
    getToken();
    //
  }

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
            centerTitle: true,
            backgroundColor: Colors.white,
            title: _appbarText),
        floatingActionButton: SpeedDial(
          openCloseDial: isDialOpen,
          icon: Icons.menu,
          backgroundColor: Colors.green,
          activeBackgroundColor: Colors.red,
          overlayColor: Colors.yellow.shade100,
          iconTheme: IconThemeData(color: Colors.white),
          activeIcon: Icons.remove,
          children: [
            SpeedDialChild(
                backgroundColor: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    (Icons.add),
                    color: Colors.white,
                  ),
                ),
                label: "Add Post",
                labelStyle: TextStyle(fontSize: 18, color: Colors.white),
                onTap: () {
                  setState(() {
                    _isPost = true;
                  });
                }),
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
                labelStyle: TextStyle(fontSize: 18, color: Colors.white),
                onTap: () {
                  setState(() {
                    _isClickedMessage = true;
                  });
                }),
            SpeedDialChild(
                backgroundColor: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    (Icons.call),
                    color: Colors.white,
                  ),
                ),
                label: "Call",
                labelStyle: TextStyle(fontSize: 18, color: Colors.white),
                onTap: () {
                  setState(() {
                    _isCall = true;
                  });
                }),
            SpeedDialChild(
                backgroundColor: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    (Icons.video_call),
                    color: Colors.white,
                  ),
                ),
                label: "Video Call",
                labelStyle: TextStyle(fontSize: 18, color: Colors.white),
                onTap: () {
                  setState(() {
                    _isVideoCall = true;
                  });
                }),
          ],
        ),
        body: ListView(
          children: [
            Column(
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
            )
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
    return Column(
      children: [
        CarouselSlider(
            items: [
              getListView(Colors.deepPurple),
              getListView(Colors.orange),
              getListView(Colors.brown),
              getListView(Colors.pink)
            ],
            options: CarouselOptions(
                // enlargeStrategy: CenterPageEnlargeStrategy.scale,
                enlargeCenterPage: true,
                viewportFraction: 0.7,
                height: MediaQuery.of(context).size.height - 250,
                scrollDirection: Axis.horizontal)),
        Container(
          child: ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(10)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: Text(
              ' Download ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  List<Widget> getListItems() {
    List<List<String>> _list = [
      ["Raj", "1234567890"],
      ["King", "1234567890"],
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
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Container(
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: _themecolor,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            Text(
                              "Message",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                            Icon(
                              (Icons.notifications),
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          autofocus: true,
                          showCursor: true,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            hintText: 'Search for a friend.',
                          ),
                        )
                      ],
                    ),
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: _themecolor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,),
                      child: Text(
                        "All Contacts",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: _themecolor,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        "Message Users",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  // decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.all(Radius.circular(25))),
                  height: MediaQuery.of(context).size.height - 593,
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
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: _themecolor,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.contact_page,
                      size: 35,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.message,
                      size: 35,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.group_work,
                      size: 35,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}


class Messages {
  String title = "", body = "";
  Messages(String title, String body) {
    this.title = title;
    this.body = body;
  }
  String getTitle() {
    return this.title;
  }

  String getBody() {
    return this.body;
  }
}