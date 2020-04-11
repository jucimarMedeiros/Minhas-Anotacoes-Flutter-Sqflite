import 'dart:async';
import 'package:anotacoes/views/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

 @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 3)).then((_){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
        backgroundColor: Colors.blue,     
        body: Stack(
            
            children: <Widget>[
                Container(
                  color: Colors.blue,  
                ),
                Center(
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                        Image.asset("images/logo.png")
                     ],
                  ),  
                )
            ],
        ),
    );
  }
}