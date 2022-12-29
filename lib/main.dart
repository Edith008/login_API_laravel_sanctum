import 'dart:convert';

//import 'package:appturorialapi/view/login.dart';
import 'package:hhrr_movil3/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HHRR",
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      theme: ThemeData(
        accentColor: Colors.white70
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const LoginPage()), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recursos Humanos", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const LoginPage()), (Route<dynamic> route) => false);
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: const Center(child: Text("home.........")),
      drawer: Drawer(
        child: ListView(
              children: const <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text('persona'),
                  accountEmail:Text('persona@gmail.com'),
                  //accountEmail:Text(),   // email de la persona logueada

                  decoration: BoxDecoration(
                     image: DecorationImage(
                       fit: BoxFit.fill,
                      image: AssetImage("assets/imagenes/panel2.jpg"),
                     )
                  ),
                 

                ),
                Divider(),
                // new ListTile(
                //   title: new Text("Add data"),
                //   trailing: new Icon(Icons.fitness_center),
                //   onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                //     builder: (BuildContext context) => AddData(),
                //   )),
                // ),
                // new Divider(),
                // new ListTile(
                //   title: new Text("Mostrar listado"),
                //   trailing: new Icon(Icons.help),
                //   onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                //     builder: (BuildContext context) => ShowData(),
                //   )),
                // ),
              ],
            ),
      ),
    );
  }
}