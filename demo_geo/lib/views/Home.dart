import 'package:demo_geo/controller/bloc/HomeBloc.dart';
import 'package:demo_geo/controller/event/HomeEvent.dart';
import 'package:demo_geo/entities/GeoLocEntity.dart';
import 'package:demo_geo/entities/PlaceEntity.dart';
import 'package:demo_geo/utils/PermissionHelper.dart';
import 'package:demo_geo/utils/StyleConst.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> with HomeEvent {
  final HomeBloc bloc = new HomeBloc();
  PermissionHelper permissionHelper;

  @override
  HomeState actionState() => this;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    permissionHelper = new PermissionHelper(this);
    eventFirstLoad();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.black,
        elevation: 3,
        titleSpacing: 0.0,
        title: header(),
      ),
      body: body(),
    );
  }

  Widget header() {
    return new Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.blue,
      child: new StreamBuilder<GeoLocEntity>(
        stream: bloc.geoLocEntitySc?.stream,
        builder: (BuildContext context, AsyncSnapshot<GeoLocEntity> snapshot) {
          if (snapshot.hasData) {
            GeoLocEntity glEntity = snapshot.data;
            Position loc = glEntity.position;
            Placemark pm = glEntity.placemark;
            return new Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new Text(
                      '${pm?.thoroughfare ?? '--'} , ${pm?.subLocality ?? '--'}',
                      style: TextStyleConst.b14(Colors.white),
                    ),
                  ),
                  new Center(
                    child: new FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () => {},
                        child: new Text(
                          'Detail',
                          style: TextStyleConst.b14(Colors.white),
                        )),
                  )
                ],
              ),
            );
          } else {
            return new Center(
              child: new Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                width: 20,
                height: 20,
                child: new CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget body() {
    return new Container(
      color: Colors.white,
      child: new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: new Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: new Column(
            children: <Widget>[
              //LABEL 1000 meters
              new Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 15,
                        ),
                        new Text(
                          '1000 \u00b1 Meters',
                          style: TextStyleConst.b14(Colors.black),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          'Show all ',
                          style: TextStyleConst.b14(Colors.black),
                        ),
                        new Icon(
                          Icons.fullscreen,
                          color: Colors.black,
                          size: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Place List
              new Container(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
                child: new StreamBuilder<List<PlaceEntity>>(
                  stream: bloc?.placeEntitySc?.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PlaceEntity>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return new ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            const root = 'assets/ic/menu/'; // ASSETS
                            PlaceEntity place = snapshot.data[index];
                            AssetImage asImg;
                            String title;
                            bool useMeters = place.distance < 300;

                            if (place.type == 1) {
                              asImg = new AssetImage('${root}ic_masjid.png');
                              title = 'R.Ibadah';
                            }
                            if (place.type == 2) {
                              asImg =
                                  new AssetImage('${root}ic_minimarket.png');
                              title = 'M.Market';
                            }
                            if (place.type == 3) {
                              asImg = new AssetImage('${root}ic_bengkel.png');
                              title = 'Bengkel';
                            }
                            if (place.type == 4) {
                              asImg = new AssetImage('${root}ic_bensin.png');
                              title = 'Bensin';
                            }
                            if (place.type == 5) {
                              asImg = new AssetImage('${root}ic_warung.png');
                              title = 'Warung';
                            }
                            if (place.type == 6) {
                              asImg = new AssetImage('${root}ic_warnet.png');
                              title = 'Warnet';
                            }
                            if (place.type == 7) {
                              asImg = new AssetImage('${root}ic_ftcopy.png');
                              title = 'Ft.Copy';
                            }
                            if (place.type == 8) {
                              asImg = new AssetImage('${root}ic_makanan.png');
                              title = 'Makanan';
                            }
                            if (place.type == 9) {
                              asImg = new AssetImage('${root}ic_ojek.png');
                              title = 'Ojek';
                            }
                            if (place.type == 10) {
                              asImg = new AssetImage('${root}ic_becak.png');
                              title = 'Becak';
                            }
                            if (place.type == 11) {
                              asImg =
                                  new AssetImage('${root}ic_minimarket.png');
                              title = 'Pasar';
                            }
                            if (place.type == 12) {
                              asImg = new AssetImage('${root}ic_taman.png');
                              title = 'Taman';
                            }

                            return new Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    width: 60,
                                    height: 60,
                                    decoration: new BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: IconButton(
                                        icon: new ImageIcon(
                                          asImg,
                                          color: Colors.black,
                                          size: 40,
                                        ),
                                        onPressed: null),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          '${place.name}',
                                          style:
                                              TextStyleConst.b14(Colors.black),
                                        ),
                                        new Divider(
                                          height: 5,
                                        ),
                                        new Text(
                                          useMeters
                                              ? '${place.distance.ceil()} m'
                                              : '${(place.distance / 1000).toStringAsFixed(2)} km',
                                          style:
                                              TextStyleConst.b32(Colors.black),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return new Text(
                          'No Result',
                          style: TextStyleConst.b14(Colors.black),
                        );
                      }
                    } else {
                      return new Center(
                        child: new Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          width: 20,
                          height: 20,
                          child: new CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
