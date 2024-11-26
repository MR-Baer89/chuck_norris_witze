import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chuck Norris Joke',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Chuck Norris Joke'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentJoke = '';
  String _errorMessage = '';

  Future<void> getChuckNorrisJoke() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/chucknorris/dad'),
        headers: {
          'X-Api-Key': 'Fg1eV7NHdzj3Wp/VQx5AfQ==7coi7tcvw0zADpLu',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _currentJoke = data['joke'];
          _errorMessage = '';
        });
      } else {
        setState(() {
          _errorMessage =
              'Fehler beim Abrufen des Witzes: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Ein unerwarteter Fehler ist aufgetreten: $error';
      });
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
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
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
