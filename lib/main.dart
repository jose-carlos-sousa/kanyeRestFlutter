import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Quote> fetchKanyeQuote() async {
  final response = await http.get(Uri.parse('https://api.kanye.rest'));

  if (response.statusCode == 200) {
    return Quote.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load quote');
  }
}

class Quote {
  final String quote;

  Quote({
    required this.quote,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['quote'] as String,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Quote> futureQuote;

  @override
  void initState() {
    super.initState();
    futureQuote = fetchKanyeQuote();
  }

  Future<void> refreshQuote() async {
    setState(() {
      futureQuote = fetchKanyeQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanye Rest',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kanye Rest'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/kanye.jpeg', // Corrected path
                width: 200, // specify width
                height: 200, // specify height
                fit: BoxFit.cover, // adjust how the image should be inscribed into the box
              ),
              SizedBox(height: 20),
              FutureBuilder<Quote>(
                future: futureQuote,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!.quote,
                      style: TextStyle(fontSize: 24), // set text size to 24
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: TextStyle(fontSize: 24), // set text size to 24
                    );
                  }

                  return CircularProgressIndicator();
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: refreshQuote,
                child: Text('Generate New Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
