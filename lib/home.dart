import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSwitched = false;
  bool _isSwitched2 = false;

  Future<List<dynamic>> fetchData() async {
    var url = Uri.parse(
        'https://api.thingspeak.com/channels/2107815/feeds.json?results=2');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data['feeds']);

      return data['feeds'];
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    // _loadData();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Energy Metering & Smart Grid',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Manual', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 20),
                  Switch(
                    value: _isSwitched,
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreen,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Automatic', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 20),
                  Switch(
                    value: _isSwitched2,
                    onChanged: (value) {
                      setState(() {
                        _isSwitched2 = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreen,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Energy Metering',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              FutureBuilder<dynamic>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // return Text(snapshot.data[0]['field1']);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Content_widget(
                                  text: "Grid Power: ",
                                  value: snapshot.data[0]['field1']),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Content_widget(
                              text: "Load Power: ",
                              value: snapshot.data[0]['field1']),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  }),
              const SizedBox(height: 20),
              Image.asset('assets/images/solar-image.jpg'),
            ],
          ),
        ));
  }
}

class Content_widget extends StatelessWidget {
  final String text;
  final String value;
  const Content_widget({
    super.key,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 20)),
      ],
    );
  }
}
