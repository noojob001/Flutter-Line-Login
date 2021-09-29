// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import 'main_profiel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Flutter Line Login Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void startLineLogin() async{
   try {
    final result = await LineSDK.instance.login(scopes: ["profile"]);
    print(result.toString());
     var accesstoken = await getAccessToken();
     var displayname = result.userProfile.displayName;
     var statusmessage = result.userProfile.statusMessage;
     var imgUrl = result.userProfile.pictureUrl;
     var userId = result.userProfile.userId;

     print("AccessToken> " + accesstoken);
     print("DisplayName> " + displayname);
     print("StatusMessage> " + statusmessage);
     print("ProfileURL> " + imgUrl);
     print("userId> " + userId);

     Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(
       puserId: userId, 
       paccessToken: accesstoken, 
       pdisplayName: displayname, 
       pimgUrl: imgUrl, 
       pstatusMessage: statusmessage,)));
      
  } on PlatformException catch (e) {
    print(e);
    switch (e.code.toString()){
      case "CANCEL":
          showDialogBox("Cancel Login", "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
          print("User Cancel the login");
          break;
      case "AUTHENTICATION_AGENT_ERROR":
          showDialogBox("You do not have permission to Login", "เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
          print("User decline the login");
          break;
      default:
          showDialogBox("Something went wrong", "เกิดข้อผิดพลาดไม่ทราบสาเหตุ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
          print("Unknown but failed to login");
          break;
    }
  }
  }
  Future getAccessToken() async{
    try {
      final result = await LineSDK.instance.currentAccessToken;
      return result.value;
    }  on PlatformException catch (e) {
      print(e.message);
    }
  }
  void showDialogBox(String title, String body) async{
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[
              Text(body)
            ],),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],);
        }
    );
  }

void lineSDKInit() async{
    await LineSDK.instance.setup("1656476002").then((_){
      print("LineSDK is Prepared");
    });
  }
  @override
  void initState() {
    lineSDKInit();
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 60,top:80),
                child: Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/2/2e/LINE_New_App_Icon_%282020-12%29.png', 
                                    width: 100, height: 100,),
              ),
              Text("Welcome To Flutter Line App", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),),
              Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Text("Please Login", style: TextStyle(fontSize: 18,)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  children: <Widget>[
                    

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 10, right: 20, left: 10),
                        child: RaisedButton(
                          color: Color.fromRGBO(0, 185, 0, 1),
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(3),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/messagingapitutorial.appspot.com/o/line_logo.png?alt=media&token=80b41ee6-9d77-45da-9744-2033e15f52b2', 
                                    width: 50, height: 50,),
                                  Container(
                                    color: Colors.black12,
                                    width: 2,
                                    height: 40,
                                  ),
                                  Expanded(
                                    child: Center(child: Text("Login With LINE", style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold)))
                                    ,)
                                  ]
                                  )
                                ],
                              ),
                          onPressed: (){
                            startLineLogin();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          ),
                        ),
                      ),                  
                  ]
                ),
              ),
            ],
          ),
        ),
    );
  }
}
