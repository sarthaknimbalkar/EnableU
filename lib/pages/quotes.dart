import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MotivationalQuotesApp());
}

class MotivationalQuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Motivational Quotes',
      theme: ThemeData(
        primaryColor: Colors.black45,
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: QuotePage(),
    );
  }
}

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String quote = 'Loading...';
  String author = '';
  String backgroundImage = 'https://picsum.photos/800/600';

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    const quoteUrl = 'https://zenquotes.io/api/random';
    try {
      final response = await http.get(Uri.parse(quoteUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)[0];
        setState(() {
          quote = data['q'];
          author = data['a'] ?? 'Unknown';
          backgroundImage =
          'https://picsum.photos/800/600?random=${DateTime.now().millisecondsSinceEpoch}';
        });
      } else {
        setState(() {
          quote = 'Failed to load quote. Please try again later.';
          author = '';
        });
      }
    } catch (e) {
      setState(() {
        quote = 'Failed to load quote. Check your internet connection.';
        author = '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Motivational Quote'),
        backgroundColor: Colors.blueAccent[400],
        elevation: 10.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(backgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              quote,
              style: TextStyle(
                fontSize: 24,
                fontStyle: FontStyle.italic,
                color: Colors.yellowAccent,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              author.isNotEmpty ? '- $author' : '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: fetchQuote,
              child: Text(
                'New Quote',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent[700],
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shadowColor: Colors.black,
                elevation: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
