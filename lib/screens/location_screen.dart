import 'package:flutter/material.dart';
import 'package:test_clima_flutter/screens/city_screen.dart';
import 'package:test_clima_flutter/services/networking.dart';
import 'package:test_clima_flutter/utilities/constants.dart';
import 'dart:convert';
import 'package:test_clima_flutter/services/weather.dart';
import 'package:test_clima_flutter/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen(this.data,{super.key});
  String data;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  double temp=0;
  String city = '',info='',weathericon='',weathermessage='', update='';
  int ID = 0;
  bool error = false;

  @override
  void initState() {
    super.initState();
    print(widget.data);
    info = widget.data;
    updateUI();
  }

  void updateUI(){
    print(info);
    temp = jsonDecode(info)['main']['temp'];
    city = jsonDecode(info)['name'];
    ID = jsonDecode(info)['weather'][0]['id'];
    print(city);
    print(temp);
    print(ID);

    WeatherModel weatherModel = new WeatherModel();
    weathericon = weatherModel.getWeatherIcon(ID);
    weathermessage = weatherModel.getMessage(temp.toInt());

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/skybg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async{
                      Networking netting = new Networking();
                      update = await netting.getData(city);
                      setState(() {
                        info = update;
                        updateUI();
                        error = false;
                      });
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      String newCity;
                      newCity = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return const CityScreen();
                          }));
                      Networking networking = new Networking();

                      try {
                        update = await networking.GetCity(newCity);

                        setState(() {
                          info = update;
                          updateUI();
                          error = false;
                        });

                      }

                      catch (e) {
                        setState(() {
                          weathermessage = e.toString();
                          city = " ";
                          error = true;
                        });
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),

                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      temp.toStringAsFixed(0)+'°',
                      style: kTempTextStyle,
                    ),
                    Text(
                    weathericon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weathermessage in $city",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




