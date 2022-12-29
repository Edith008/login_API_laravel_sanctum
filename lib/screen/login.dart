import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;
  // bool get authenticated => _isLoading;

  //Para ver/ocultar password
  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              //colors: [Colors.blue, Colors.teal],
              //colors: [Colors.blue, Color.fromARGB(255, 30, 27, 106)],
              colors: [Colors.blue, Color.fromARGB(255, 18, 16, 81)],
              //colors: [ Color.fromARGB(255, 65, 126, 176),Color.fromARGB(255, 23, 171, 182)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      //'email': email,
      //'password': pass
      'usuario': email,
      'contrasena': pass
    };
    var jsonResponse = null;

    //(NAVEGADOR CHROME)En el Api de Laravel: php artisan serve 
    var response = await http.post(Uri.parse("http://127.0.0.1:8000/api/login"), body: data);
    
    //(CELULAR FISICO)En el Api de Laravel: php artisan serve --host 0.0.0.0 --port 9000
    //var response = await http.post(Uri.parse("http://192.168.0.7:9000/api/login"), body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['access_token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const MainPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      margin: const EdgeInsets.only(top: 15.0),
      child:ElevatedButton(
        onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
          //onPressed: emailAndPasswordSupplied() == false ? null : () {
          setState(() {
            _isLoading = true;
          });
          signIn(emailController.text, passwordController.text);
        },
        style: ElevatedButton.styleFrom(
        elevation: 0.0,  
        primary: Colors.purple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        child: const Text("Iniciar sesion", style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController =TextEditingController();

  //
  static const _minEmailLength = 5;
  static const _minPasswordLength = 3;
  /* Esta variable indica si los campos de texto de nombre y contraseña eran válidos
     longitud (o no) antes de la pulsación de tecla actual. Esto nos impide llamar
     setState() cada vez que se agrega una pulsación de tecla más allá del mínimo.  */
  bool emailAndPasswordValidBefore = false;

  bool emailAndPasswordSupplied() {
    // ¿Ambos campos son válidos en este momento?
    bool fieldsValid = emailController.text.length >= _minEmailLength &&
        passwordController.text.length >= _minPasswordLength;
    if (fieldsValid ^ emailAndPasswordValidBefore) {
      // El estado ha cambiado
      setState(() {});
    }
    emailAndPasswordValidBefore = fieldsValid; //actualizacion del estado de validacion
    return emailAndPasswordValidBefore;
  }
  //


  Container textSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,

            style: const TextStyle(color: Colors.white70),
            decoration: const InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
            //
            onChanged: (newText) {
              emailAndPasswordSupplied();
            },
            //
          ),
          const SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true, 
            style: const TextStyle(color: Colors.white70),
            decoration: const InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
            //
            onChanged: (newText) {
              emailAndPasswordSupplied();
            },
            //
          ),
        ],
      ),
    );
  }

Container headerSection() {
    return Container(
      margin: const EdgeInsets.only(top: 50.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: const Text("         LOGIN",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }

}//