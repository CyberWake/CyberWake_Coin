import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberWake Coin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Client httpclient;
  //Web3Client ethClient;
  bool data = false;
  int myAmount = 0;
  double _slider = 0.0;
  //final myAddress = '0xcbe8Ff8F3424959e2d08b948A7c862b6a82D0904';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZStack([
        VxBox()
            .blue600
            .size(context.screenWidth,context.percentHeight*30)
            .make(),
        VStack([
          (context.percentHeight*10).heightBox,
          "CyberWake Coin".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight*5).heightBox,
          VxBox(child: VStack([
            "Balance".text.gray700.xl2.semiBold.makeCentered(),
            10.heightBox,
            data?
            "\$1".text.bold.xl6.makeCentered():
            CupertinoActivityIndicator(
              radius: 25,
            ).centered()
          ]))
              .p16
              .white
              .size(context.screenWidth,context.percentHeight*18)
              .rounded
              .shadowXl
              .make()
              .p16(),
          30.heightBox,
          VxBox(
            child: FluidSlider(
              value: _slider,
              onChanged: (double value){
                _slider = value;
                myAmount = value.round() * 100;
                setState(() {});
              },
              min: 0,
              max: 100,
            ),)
              .size(context.screenWidth-80,context.percentHeight*8)
              .make()
              .centered().p16(),
          HStack([
            FlatButton.icon(
                onPressed:(){},
                color: Colors.blue,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                label: "Refresh".text.white.make()
            ).h(50),
            FlatButton.icon(
                onPressed:(){},
                color: Colors.red,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.call_made,
                  color: Colors.white,
                ),
                label: "Withdraw".text.white.make()
            ).h(50),
            FlatButton.icon(
                onPressed:(){},
                color: Colors.green,
                shape: Vx.roundedSm,
                icon: Icon(
                  Icons.call_received,
                  color: Colors.white,
                ),
                label: "Deposite".text.white.make()
            ).h(50),
          ],
            axisSize: MainAxisSize.max,
            alignment: MainAxisAlignment.spaceAround,
          )
        ])
      ]),
    );
  }
}
