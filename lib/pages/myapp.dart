import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meuappcep/pages/cep_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
            color: Colors.red,),
          colorScheme: const ColorScheme.light(primary: Colors.red,secondary: Colors.white),
          textTheme: GoogleFonts.robotoTextTheme(),
    ),
      home: const CepPage(),
    );
  }
}