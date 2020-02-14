import 'package:captions_maker/model/videoProvider.dart';
import 'package:captions_maker/pages/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menubar/menubar.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VideoProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        darkTheme: ThemeData.dark(),
        theme:
            ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
        home: HomePage(),
      ),
    );
  }
}
