import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chuck Norris Joke',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Chuck Norris Joke'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentJoke = '';

  Future<void> getChuckNorrisJoke() async {
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/chucknorris'),
      headers: {
        'X-Api-Key': 'Fg1eV7NHdzj3Wp/VQx5AfQ==7coi7tcvw0zADpLu',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _currentJoke = data['joke'];
      });
    } else {
      print('Anforderung fehlgeschlagen mit Status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    getChuckNorrisJoke();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _currentJoke.isEmpty
                    ? 'Noch kein Witz geladen...'
                    : _currentJoke,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: getChuckNorrisJoke,
                child: const Text('Neuer Witz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
