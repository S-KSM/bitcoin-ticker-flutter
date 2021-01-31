import 'dart:convert' as convert;
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String coinName = 'ETH';
  String exchangeRate = '?';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData(coinName, selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        selectedCurrency = pickerItems[selectedIndex] as String;
        getData(coinName, selectedCurrency);
      },
      children: pickerItems,
    );
  }
// Creating the coinSelector DropDown

  DropdownButton<String> androidCryptoDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String crypto in cryptoList) {
      var newItem = DropdownMenuItem(
        child: Text(crypto),
        value: crypto,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: coinName,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          coinName = value;
          getData(coinName, selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iOSCryptoPicker() {
    List<Text> pickerItems = [];
    for (String crypto in cryptoList) {
      pickerItems.add(Text(crypto));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        coinName = pickerItems[selectedIndex] as String;
        getData(coinName, selectedCurrency);
      },
      children: pickerItems,
    );
  }

  //TODO: Create a method here called getData() to get the coin data from coin_data.dart
  Future<int> getData(coinName, selectedCurrency) async {
    // kUrlMain ;
    String _apiKey = 'A8DCEB8B-09DD-4CC2-9641-734DB50F3FB4';
    String urlExchange =
        '$kUrlMain/v1/exchangerate/$coinName/$selectedCurrency';
    http.Response response = await http.get(
      urlExchange,
      headers: {'X-CoinAPI-Key': _apiKey},
    );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);

      setState(() {
        exchangeRate = jsonResponse['rate'].toStringAsFixed(0);
      });
    } else {
      print(urlExchange);
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    //TODO: Call getData() when the screen loads up.
    getData(coinName, selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  //TODO: Update the Text Widget with the live bitcoin data here.
                  '1 $coinName = $exchangeRate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.lightBlue,
                child: Platform.isIOS ? iOSPicker() : androidDropdown(),
              ),
              Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.lightBlue,
                child: Platform.isIOS
                    ? iOSCryptoPicker()
                    : androidCryptoDropdown(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
