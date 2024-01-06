import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mafiagame/constants/dark_theme.dart';
import 'package:mafiagame/generated/l10n.dart';
import 'package:mafiagame/pages/home/home.dart';
import 'package:mafiagame/widgets/init_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCqfQvUZrYd4Nx_ZLPEh-ScULo8Fm4NarA",
        authDomain: "mafia-game1.firebaseapp.com",
        projectId: "mafia-game1",
        storageBucket: "mafia-game1.appspot.com",
        messagingSenderId: "1013856136438",
        appId: "1:1013856136438:web:eab1e5c8bc79c6e490d0d7",
        measurementId: "G-X334N0FTX8"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return InitWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mafia Game',
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('en'),
        theme: darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
