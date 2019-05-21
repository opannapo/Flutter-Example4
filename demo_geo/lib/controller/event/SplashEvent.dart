import 'package:demo_geo/controller/bloc/SplashBloc.dart';
import 'package:demo_geo/views/Home.dart';
import 'package:demo_geo/views/Splash.dart';
import 'package:flutter/material.dart';

abstract class SplashEvent {
  SplashState actionState();

  SplashState get _state => actionState();

  SplashBloc get _bloc => _state.bloc;

  void eventSetupFirebase() {
    _bloc.doFirebaseConfig().then((val) {
      new Future.delayed(Duration(milliseconds: 500)).then((v) {
        Navigator.of(_state.context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new Home()));
      });
    });
  }
}
