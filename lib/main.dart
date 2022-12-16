import 'package:flutter/material.dart';
import 'package:tv_series_app/core/routes/route_generator.dart';
import 'package:tv_series_app/core/styles/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:tv_series_app/features/auth/controller/pin_controller.dart';
import 'package:tv_series_app/features/auth/controller/fingerprint_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tv_series_app/features/series/controller/serie_controller.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  String initialValue = "/";

  var fingerprint = await FlutterSecureStorage().read(key: 'fingerprint');

  if (fingerprint == "1" || await PinController().isPinCreated()) {
    initialValue = "/login";
  } else {
    initialValue = "/home";
  }

  runApp(MyApp(
    initialScreen: initialValue,
  ));
}

class MyApp extends StatelessWidget {
  String initialScreen;

  MyApp({super.key, required this.initialScreen});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PinController()),
        ChangeNotifierProvider(create: (context) => SerieController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TV SERIES APP',
        theme: AppTheme.theme,
        initialRoute: initialScreen,
        onGenerateRoute: RouteGenerator().generateRoute,
      ),
    );
  }
}
