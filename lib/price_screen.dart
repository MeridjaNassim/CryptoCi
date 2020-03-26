import 'package:bitcoin_ticker/utils/coin_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'coin_data.dart' as coinData;
class PriceScreen extends StatefulWidget {
  final CoinManager coinManager;
  PriceScreen(this.coinManager);
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> with TickerProviderStateMixin {
  String selectedCurrency ;
  bool loading =false;
  Map<String,double> displayData = {
      'BTC' : null,
      'ETH' : null,
      'LTC' : null
    }; 
  @override
  void initState() {
    super.initState();
    selectedCurrency ='USD';
    ()async {await widget.coinManager.populateData(currency : selectedCurrency ,placeholder : displayData);}();
   
  }
  Widget getPlatformSpecificDropDown() {
    return Theme.of(context).platform == TargetPlatform.android ? DropdownButton<String>(
              value: selectedCurrency,
             items:coinData.currenciesList.map<DropdownMenuItem<String>>((item){
               return DropdownMenuItem<String>(value: item , child: Center(child : Text(item)),);
             }).toList(),
             onChanged: (item) async{
               setState(() {
                 selectedCurrency= item;
                 loading = true ;
               });
               await widget.coinManager.populateData(currency : selectedCurrency , placeholder : displayData);
               setState(() {
                 loading = false ; 
               });
             }) : CupertinoPicker(
              backgroundColor: Colors.teal.shade800,
            
              itemExtent: 32.0, onSelectedItemChanged: (index) async{
                setState(() {
                    selectedCurrency = coinData.currenciesList[index];
                     loading = true ;
                });
                await widget.coinManager.populateData(currency : selectedCurrency , placeholder : displayData);
                setState(() {
                   loading = false ; 
                });
              },
            children: coinData.currenciesList.map((item)=> Text(item,style: TextStyle(color : Colors.white),)).toList(),
            );
  }
  Column getCurrencies() {

    return Column (
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children : coinData.cryptoList.map((item){
        return Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.teal.shade900,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $item = ${displayData[item]} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );},).toList() );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          (){
            return Expanded(flex : 3 , child : loading ? Center(
              child: SpinKitFoldingCube(
                color: Colors.teal,
                size : 50,
                 controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
              ),
            ) :  getCurrencies()) ;
          }(),
          Expanded(
                      child: Container(
              height: 150.0,
              alignment: Alignment.center,
              
              color: Colors.teal.shade800,
              child: getPlatformSpecificDropDown()
            ),
          ),
        ],
      ),
    );
  }
}