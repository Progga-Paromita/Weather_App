import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'secrets.dart';
import 'HourlyFForecast.dart';
import 'additional_info_items.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "London";
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName,&APPID=$openWeatherAPIkey",
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather=getCurrentWeather();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            setState(() {
              weather=getCurrentWeather();
            });
          },
            icon: Icon(Icons.refresh, size: 30,
            ),
          ),
        ],
      ),

      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final humidity = currentWeatherData['main']['humidity'];
          final windSpeed = currentWeatherData['wind']['speed'];
          final pressure = currentWeatherData['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Color(0xFF333338),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp k",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              currentSky == 'Rain' || currentSky == 'Clouds'
                                  ? Icon(Icons.cloud, size: 64)
                                  : Icon(Icons.sunny, size: 64),
                              SizedBox(height: 10),
                              Text(
                                "$currentSky",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 1; i <= 10; i++)
                        HourlyForecast(
                          level: DateFormat.Hm().format(
                            DateTime.parse(data['list'][i]['dt_txt']),
                          ),
                          subLevel: data['list'][i]['main']['temp'].toString(),
                          icon:
                          data['list'][i]['weather'][0]['main']
                              .toString() ==
                              'Clouds' ||
                              data['list'][i]['weather'][0]['main']
                                  .toString() ==
                                  'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                        ),

                      // SizedBox(
                      //   height: 120,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: 5,
                      //     itemBuilder: (context, index) {
                      //       final forecastData = data['list'][index + 1];
                      //       final dt = DateTime.fromMillisecondsSinceEpoch(forecastData['dt'] * 1000);
                      //       final hour = DateFormat.jm().format(dt);
                      //       final sky = forecastData['weather'][0]['main'].toString();
                      //       final temp = forecastData['main']['temp'].toString();
                      //
                      //       return HourlyForecast(
                      //         level: hour,
                      //         subLevel: "$temp °C",
                      //         icon: sky == 'Clouds' || sky == 'Rain' ? Icons.cloud : Icons.sunny,
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Additional_Info_Items(
                      icon: Icons.water_drop,
                      tittle: 'Humidity',
                      subTittle: '$humidity',
                    ),

                    Additional_Info_Items(
                      icon: Icons.air,
                      tittle: 'Wind Speed',
                      subTittle: '$windSpeed',
                    ),

                    Additional_Info_Items(
                      icon: Icons.beach_access,
                      tittle: 'Pressure',
                      subTittle: '$pressure',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
