import 'package:demo_geo/controller/bloc/SplashBloc.dart';
import 'package:demo_geo/controller/event/SplashEvent.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  State createState() => SplashState();
}

class SplashState extends State<Splash> with SplashEvent {
  final SplashBloc bloc = new SplashBloc();

  @override
  SplashState actionState() => this;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    eventSetupFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.blue,
    );
  }
}
