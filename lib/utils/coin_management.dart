import '../coin_data.dart';
import 'data_fetching.dart';

const String base_api_url ='https://apiv2.bitcoinaverage.com/indices/global/ticker';
  class CoinManager {
  static bool _dataloaded =false  ; 
  static Map<String,Map<String,double>> loadedData = {};
  CoinManager() {
   /// lazy loading
  }
  Future<dynamic> _getLiveData(String coin , String currency) async{
    dynamic data ;
    try{
      data = await DataFetcher(url : '$base_api_url/$coin$currency').getData();
      return data ;
    }catch(e) {
      print("Could'nt get hold of data");
      return null;
    }
  }
  Future<void> _fetchAllData() async{
      for(String coin in cryptoList) {
        var map = loadedData.putIfAbsent(coin,()=>  new Map<String,double>() );
        for(String currency in currenciesList){
            dynamic data = await _getLiveData(coin, currency);
            map.putIfAbsent(currency, ()=>data['last'] );
        }
      }
      _dataloaded = true;
  }
  Future<void> loadData() async {
     /// do not load all data ... load USD only; 
     if(!_dataloaded){
       await _loadUSD();
     }
  }
  
  
  Future<double> _getValue({String coin , String currency})async{
    if(loadedData[coin] ==null || loadedData[coin][currency] == null) return await _getDataFor(coin : coin , currency : currency);
    return loadedData[coin][currency];
  }
  Future<dynamic> _getDataFor({String coin,String currency}) async {
    dynamic data ;
    if(coin != null && currency !=null) {
      data = loadedData[coin];
      if(data != null) {
        var value = data[currency];
        if(value != null) return value;
        else {
          data = await _getLiveData(coin, currency);
          return data.putIfAbsent(currency, ()=>data['last']);
        }
      }else {
        var map = loadedData.putIfAbsent(coin, ()=>Map<String,double>());
        data = await _getLiveData(coin, currency);
        return map.putIfAbsent(currency, ()=>data['last']);
      }
    }
    return null;
  }
  Future<void> _loadUSD() async{
    await _getDataFor(coin : 'BTC' , currency :'USD');
    await _getDataFor(coin : 'ETH' , currency :'USD');
    await _getDataFor(coin : 'LTC' , currency :'USD');
  }

  Future<void> populateData({String currency , Map<String,double> placeholder}) async{
    for(String coin in cryptoList) {
      var map = loadedData[coin];
      if(map !=null) {
        var value = map[currency];
        if(value != null ) placeholder[coin] = value;
        else {
          value = await _getValue(currency: currency,coin : coin);
          map[currency] = value ;
          placeholder[coin] = value ;
        }
      } 
    }
  }
}

