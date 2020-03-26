import '../coin_data.dart';
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
  Future<void> _fetchData() async{
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
     if(!_dataloaded) await _fetchData();
  }
  double getValue(String coin , String currency){
    return loadedData[coin][currency];
  }
}

