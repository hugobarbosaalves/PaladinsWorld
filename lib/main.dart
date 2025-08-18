import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'global/variables.dart';
import 'screens/pages/home_page.dart';
import 'utils/functions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UtilsFunctions.createSession();
  runApp(const PaladinsWorld());
}

class PaladinsWorld extends StatelessWidget {
  const PaladinsWorld({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paladins World',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalsVariables.primaryDark,
        brightness: Brightness.dark,
        primaryColor: GlobalsVariables.neonBlue,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
            color: GlobalsVariables.textPrimary,
            fontFamily: 'Montserrat',
          ),
          titleLarge: const TextStyle(
            fontSize: 36.0,
            fontStyle: FontStyle.italic,
            color: GlobalsVariables.textPrimary,
            fontFamily: 'Montserrat',
          ),
          bodyMedium: const TextStyle(
            fontSize: 14.0,
            color: GlobalsVariables.textPrimary,
            fontFamily: 'Montserrat',
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: GlobalsVariables.textPrimary),
          titleTextStyle: TextStyle(
            color: GlobalsVariables.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalsVariables.neonBlue,
            foregroundColor: GlobalsVariables.textPrimary,
            textStyle: const TextStyle(fontFamily: 'Montserrat'),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => I18n(
              child: const HomePage(),
            ),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', "US"),
        Locale('pt', "BR"),
      ],
    );
  }
}
