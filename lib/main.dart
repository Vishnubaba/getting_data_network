import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<Stick> fetchStick() async {
  final response =
  await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Stick.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Post');
  }
}

class Stick {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Stick(
      {required this.id,
        required this.userId,
        required this.title,
        required this.body});

  factory Stick.fromJson(Map<String, dynamic> json) {
    return Stick(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Stick> futureStick;

  @override
  void initState() {
    super.initState();
    futureStick = fetchStick();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кейс 3.2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Получение данных из сети,\n и отображение на экране'),
        ),
        body: Center(
          child: FutureBuilder<Stick>(
            future: futureStick,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PostCardWidget(
                    title: snapshot.data!.title, body: snapshot.data!.body);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class PostCardWidget extends StatelessWidget {
  final String title;
  final String body;
  const PostCardWidget({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: InkWell(
            onTap: () {
              //debugPrint('Card tapped.');
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.left),
                const Divider(),
                Text(body,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.left),
              ],
            ),
          ),
        ),
      ),
    );
  }
}