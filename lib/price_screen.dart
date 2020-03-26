import 'package:bitcoin_ticker/utils/coin_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart' as coinData;
class PriceScreen extends StatefulWidget {
  final CoinManager coinManager;
  PriceScreen(this.coinManager);
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency ;
  
  bool loading ;
  @override
  void initState() {
    super.initState();
    loading = true ;
    selectedCurrency =coinData.currenciesList[0] ?? 'NONE';
   
  }
  Widget getPlatformSpecificDropDown() {
    return Theme.of(context).platform == TargetPlatform.android ? DropdownButton<String>(
              value: selectedCurrency,
             items:coinData.currenciesList.map<DropdownMenuItem<String>>((item){
               return DropdownMenuItem<String>(value: item , child: Center(child : Text(item)),);
             }).toList(),
             onChanged: (item) {
               setState(() {
                 selectedCurrency= item;
               });
             }) : CupertinoPicker(
              backgroundColor: Colors.teal.shade800,
            
              itemExtent: 32.0, onSelectedItemChanged: (index){
                setState(() {
                  selectedCurrency = coinData.currenciesList[index];
                });
              },
            children: coinData.currenciesList.map((item)=> Text(item,style: TextStyle(color : Colors.white),)).toList(),
            );
  }
  Column Currencies() {
    return Column (
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children : coinData.cryptoList.map((item)=>  Padding(
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
                  '1 $item = ${widget.coinManager.getValue(item, selectedCurrency)} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),).toList() );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Currencies(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            
            color: Colors.teal.shade800,
            child: getPlatformSpecificDropDown()
          ),
        ],
      ),
    );
  }
}
// DropdownButton<String>(
//               value: selectedCurrency,
//              items:coinData.currenciesList.map<DropdownMenuItem<String>>((item){
//                return DropdownMenuItem<String>(value: item , child: Center(child : Text(item)),);
//              }).toList(),
//              onChanged: (item) {
//                setState(() {
//                  selectedCurrency= item;
//                });
//              })