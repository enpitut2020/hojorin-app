import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//         // This makes the visual density adapt to the platform that you run
//         // the app on. For desktop platforms, the controls will be smaller and
//         // closer together (more dense) than on mobile platforms.
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
// class MyCard extends Card{
//   margin = const EdgeInsets.all(5.0);
//   child: Container(
//   margin: const EdgeInsets.all(1.0),
//   width: 300,
//   height: 100,
//   child: Text(
//   'メニュー2',
//   style: TextStyle(fontSize: 30),
//   )
//   )
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('話題リスト'),
//         ),
//         body: ListView(
//             children: [
//               // _menuItem("メニュー1", Icon(Icons.settings)),
//               // Card(
//               //     child: Container(
//               //         margin: const EdgeInsets.all(1.0),
//               //         width: 300,
//               //         height: 100,
//               //         child: Column(
//               //         children:[
//               //           Text(
//               //           'バイトとかしてる？',
//               //           style: TextStyle(fontSize: 30),
//               //         ),
//               //           Wrap(children: _chips)
//               //         ]
//               //     )
//               //     )
//               // ),
//               Card(
//               child: Container(
//                   margin: const EdgeInsets.all(1.0),
//                   width: 300,
//                   height: 100,
//                   child: Text(
//                     'バイトとかしてる？\n<初対面, 学生>',
//                     style: TextStyle(fontSize: 30),
//                   )
//                 )
//               ),
//               Card(
//                   margin: const EdgeInsets.all(5.0),
//                   child: Container(
//                       margin: const EdgeInsets.all(1.0),
//                       width: 300,
//                       height: 100,
//                       child: Text(
//                         '研究室決めた？\n<筑波大学3年生、10月>',
//                         style: TextStyle(fontSize: 30),
//                       )
//                   )
//               ),
//               Card(
//                   margin: const EdgeInsets.all(5.0),
//                   child: Container(
//                       margin: const EdgeInsets.all(1.0),
//                       width: 300,
//                       height: 100,
//                       child: Text(
//                         'その服似合ってるね\n<ご機嫌取り>',
//                         style: TextStyle(fontSize: 30),
//                       )
//                   )
//               ),
//               Card(
//                   margin: const EdgeInsets.all(5.0),
//                   child: Container(
//                       margin: const EdgeInsets.all(1.0),
//                       width: 300,
//                       height: 150,
//                       child: Text(
//                         '今日ちょっと可愛くない？（or かっこよくない？）\n<ご機嫌取り>',
//                         style: TextStyle(fontSize: 30),
//                       )
//                   )
//               ),
//               Card(
//                   margin: const EdgeInsets.all(5.0),
//                   child: Container(
//                       margin: const EdgeInsets.all(1.0),
//                       width: 300,
//                       height: 100,
//                       child: Text(
//                         '体育何選択した？\n<ご機嫌取り>',
//                         style: TextStyle(fontSize: 30),
//                       )
//                   )
//               ),
//               Card(
//                   margin: const EdgeInsets.all(5.0),
//                   child: Container(
//                       margin: const EdgeInsets.all(1.0),
//                       width: 300,
//                       height: 100,
//                       child: Text(
//                         '最近寒くなってきたよね\n<秋>',
//                         style: TextStyle(fontSize: 30),
//                       )
//                   )
//               ),
//               Card(
//                   margin: const EdgeInsets.all(5.0),
//                   child: Container(
//                       margin: const EdgeInsets.all(1.0),
//                       width: 300,
//                       height: 100,
//                       child: Text(
//                         'TOEICの勉強とかしてる？',
//                         style: TextStyle(fontSize: 30),
//                       )
//                   )
//               )
//               // _menuItem("メニュー2", Icon(Icons.map)),
//               // _menuItem("メニュー3", Icon(Icons.room)),
//               // _menuItem("メニュー4", Icon(Icons.local_shipping)),
//               // _menuItem("メニュー5", Icon(Icons.airplanemode_active)),
//             ]
//         ),
//         //   body: Card(
//         //     margin: const EdgeInsets.all(50.0),
//         //     child: Container(
//         //         margin: const EdgeInsets.all(10.0),
//         //         width: 300,
//         //         height: 100,
//         //         child: Text(
//         //           'Card',
//         //           style: TextStyle(fontSize: 30),
//         //         )
//         //     ),
//         //   )
//       ),
//     );
//   }
//
//   Widget _menuItem(String title, Icon icon) {
//     return GestureDetector(
//       child:Container(
//           padding: EdgeInsets.all(8.0),
//           decoration: new BoxDecoration(
//               border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
//           ),
//           child: Row(
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.all(10.0),
//                 child:icon,
//               ),
//               Text(
//                 title,
//                 style: TextStyle(
//                     color:Colors.black,
//                     fontSize: 18.0
//                 ),
//               ),
//             ],
//           )
//       ),
//       onTap: () {
//         print("onTap called.");
//       },
//     );
//   }
// }

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<MyApp> {
  var _controller = TextEditingController();
  var _text = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // title: Text('話題リスト'),
          title: Text('検索'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              // TextField(
              //   controller: _testController
              // ),
          Padding(
          padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.blueAccent,
              ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  prefixIcon: Icon(Icons.search),
                  hintText: "Enter tag",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 32.0),
                      borderRadius: BorderRadius.circular(25.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 32.0),
                      borderRadius: BorderRadius.circular(25.0)))),
              ),
              RaisedButton(
                child: Text('Submit'),
                  onPressed: () => setState(
                    () {
                    _text = _controller.text;
                  },
                 ),
              ),
              // Text('入力内容(debug): '+_controller.text)
              Text('入力内容(debug): '+ _text),
            //   (_text == 'a') ? ListView(
            //     children: [
            //       Card(
            //         child: Container(
            //           margin: const EdgeInsets.all(1.0),
            //           width: 300,
            //           height: 100,
            //           child: Column(
            //           children:[
            //             Text(
            //               'バイトとかしてる？',
            //               style: TextStyle(fontSize: 30),
            //             ),
            //             // Wrap(children: _chips)
            //           ]
            //           )
            //         )
            //       ),
            //       Card(
            //         child: Container(
            //           margin: const EdgeInsets.all(1.0),
            //           width: 300,
            //           height: 100,
            //           child: Text(
            //             'バイトとかしてる？\n<初対面, 学生>',
            //             style: TextStyle(fontSize: 30),
            //           )
            //         )
            //       )
            //     ]
            //   )
            // ]
          ]
        )
      )
      )
    );
  }

  Widget _menuItem(String title, Icon icon) {
    return GestureDetector(
      child:Container(
          padding: EdgeInsets.all(8.0),
          decoration: new BoxDecoration(
              border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
          ),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                child:icon,
              ),
              Text(
                title,
                style: TextStyle(
                    color:Colors.black,
                    fontSize: 18.0
                ),
              ),
            ],
          )
      ),
      onTap: () {
        print("onTap called.");
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
