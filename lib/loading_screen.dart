import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'price_screen.dart';
import 'utils/coin_management.dart';
class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin{
  CoinManager coinManager ;
  @override
  void initState() {
    super.initState();
    coinManager = CoinManager();
    () async {
      await coinManager.loadData();
      var pushed =Navigator.push(context, CupertinoPageRoute(builder: (context)=> PriceScreen(coinManager)));
     
    }();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children : <Widget>[
        Expanded(child: 
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitFoldingCube(
              color: Colors.teal,
              size : 50,
               controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
            ),
          ],
        ),))
      ]
    );
  }
}