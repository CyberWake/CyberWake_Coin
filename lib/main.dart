import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Client httpclient;
  Web3Client ethClient;
  bool data = false;
  int myAmount = 0;
  double _slider = 0.0;
  final myAddress = '0xcbe8Ff8F3424959e2d08b948A7c862b6a82D0904';
  var myData;

  Future<DeployedContract> loadContract()async{
    String abi = await rootBundle.loadString('assets/abi.json');
    String contractAddress = '0x103012FD95f8A95b7ad983B81eb7D7A9D52987A0';
    final contract = DeployedContract(ContractAbi.fromJson(abi, 'CyberWakeCoin'),EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionName,List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(contract: contract,function: ethFunction,params: args);
    return result;
  }

  Future<String> submit(String functionName,List<dynamic>args)async{
    EthPrivateKey credentials =EthPrivateKey.fromHex('f358454d326610a1dddcbf8de1e26d116fef2fe995f2de8313e69b6bcbd937e1');
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials, Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args),fetchChainIdFromNetworkId: true);
    return result;
  }

  Future<String> withdrawCoin()async{
    var bigAmount = BigInt.from(myAmount);
    var response = await submit('withdrawBalance',[bigAmount]);
    print('WithDrawn');
    return response;
  }
  Future<String> sendCoin()async{
    var bigAmount = BigInt.from(myAmount);
    var response = await submit('depositBalance',[bigAmount]);
    print('Deposited');
    return response;
  }
  Future<void> getBalance(String targetAddress) async {
    //EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query('getBalance',[]);
    myData = result[0];
    data = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    httpclient = Client();
    ethClient = Web3Client('https://rinkeby.infura.io/v3/b07d3a5ee9cb43febf9a55b5b8e9f912',httpclient);
    getBalance(myAddress);
  }
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
              "$myData".text.bold.xl6.makeCentered().shimmer():
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
                  myAmount = value.round();
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
                  onPressed:(){
                    getBalance(myAddress);
                  },
                  color: Colors.blue,
                  shape: Vx.roundedSm,
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: "Refresh".text.white.make()
              ).h(50),
              FlatButton.icon(
                  onPressed:(){
                    sendCoin();
                  },
                  color: Colors.green,
                  shape: Vx.roundedSm,
                  icon: Icon(
                    Icons.call_made,
                    color: Colors.white,
                  ),
                  label: "Deposite".text.white.make()
              ).h(50),
              FlatButton.icon(
                  onPressed:(){
                    withdrawCoin();
                  },
                  color: Colors.red,
                  shape: Vx.roundedSm,
                  icon: Icon(
                    Icons.call_received,
                    color: Colors.white,
                  ),
                  label: "Withdraw".text.white.make()
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
