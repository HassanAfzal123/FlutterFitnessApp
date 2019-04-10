import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}


class _LoginPageState extends State<Login> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();

  void sendData() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    Map data = {"email": email, "password" : password};
    await http.post("http://192.168.42.106:3008/user/signin",
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept' : 'application/json'
        },
        body: data
    ).then((response){
      if(response.statusCode == 200){
        setState((){
          Navigator.of(context).pushNamed("");
        });

      }
      else {
        showDialog(context: context, child:
        new AlertDialog(
          title: new Text("Login"),
          content: new Text(response.body),
        )
        );
      }
    }
    );
  }



  @override
  Widget build(BuildContext context){

    final logo_img = new CircleAvatar(
      radius: 80.0,
      backgroundColor: Colors.black,
      child:Container(
        decoration: BoxDecoration(color: Colors.transparent,
          image: new DecorationImage(image:
          new AssetImage(
              "assets/splashscreen.png"
          ),
          ),
        ),
      ),
    );

    final email = new Theme(
        data: new ThemeData(
          primaryColor: Colors.blue,
          primaryColorDark: Colors.white,
          hintColor: Colors.white,
        ),
      child: TextFormField(
        style: new TextStyle(color: Colors.white),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: "ID",
        contentPadding: EdgeInsets.fromLTRB(15.0,20.0,15.0,20.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0)
        )
      ),
      )
    );

      final password = new Theme(

          data: new ThemeData(
            primaryColor: Colors.blue,
            primaryColorDark: Colors.white,
            hintColor: Colors.white,
          ),
      child: TextFormField(
        style: new TextStyle(color: Colors.white),
        controller: _passwordController,
        autofocus: false,
        obscureText: true,
        decoration: InputDecoration(
            hintText: "Password",
            contentPadding: EdgeInsets.fromLTRB(15.0,20.0,15.0,20.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)
            )
        ),
      )
      );
      final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.black87,
          elevation: 5.0,
          color: Colors.cyan,
          child: MaterialButton(
              onPressed: sendData,

            child: Text("Login",style: TextStyle(color: Colors.black),),
              )
        ),
      );
      final registrationText = MaterialButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/registration");
        },
        child: Text("New User? Register Here",
          style: new TextStyle(color: Colors.white)
        ),
      );

      return new Scaffold(
            body:
        new Stack(
          children: <Widget>[Container(
            decoration: new BoxDecoration(
              color: Colors.black87,
              image: new DecorationImage(image: AssetImage('assets/splashscreen.jpg'),fit: BoxFit.fill)
            ),
    ),
    new Center(
                child: new Form(
                  key: _formKey,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  shrinkWrap: true,
                  children: <Widget>[logo_img,SizedBox(height: 50,),email,SizedBox(height: 30,), password,SizedBox(height: 30,),loginButton,SizedBox(height: 30,),registrationText],
                )
                )
              )
    ]
            )


      );


  }

}