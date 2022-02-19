import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dijlah_store_ibtechiq/firebase_service/local_notification.dart';
import 'package:dijlah_store_ibtechiq/service/bLoC.dart';
import 'package:dijlah_store_ibtechiq/languages/material_localization_delegate.dart';
import 'package:dijlah_store_ibtechiq/languages/widget_localization_delegate.dart';
import 'package:dijlah_store_ibtechiq/screens/on_boarder.dart';
import 'package:dijlah_store_ibtechiq/screens/redirect_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:dijlah_store_ibtechiq/languages/localization.dart';
import 'languages//language_constants.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final BLoC bLoC = new BLoC();
  LocalNotification.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  bLoC.loadingData();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');
  var phone = preferences.getString('phone');
  var skip = preferences.getString('skipLogin');
  var seeBoarding = preferences.getBool('seeBoarding');
  runApp(MyApp(
    email: email,
    phone: phone,
    skipLogin: skip,
    seeBoarding: seeBoarding,
    bLoC: bLoC,
  ));
}

class MyApp extends StatefulWidget {
  final email;
  final phone;
  final skipLogin;
  final seeBoarding;
  final BLoC bLoC;
  MyApp({Key key, this.email, this.skipLogin, this.seeBoarding, this.bLoC, this.phone})
      : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[400])),
        ),
      );
    } else {
      return Sizer(builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'sans',
            primaryColor: Colors.teal[200],
            accentColor: Colors.teal[400],
          ),
          locale: _locale,
          supportedLocales: [
            Locale("ar", "SA"),
            Locale("en", "US"),
           // Locale("ku", 'KU'),
          ],
          localizationsDelegates: [
            Localization.delegate,
            // CkbWidgetLocalizations.delegate,
            // CkbMaterialLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home:AnimatedSplashScreen(
            splash: 'assets/logo.png',
            nextScreen: widget.seeBoarding == null
                ? OnboardingScreen(
              bLoC: widget.bLoC,
            ) : RedirectHome(
              bLoC: widget.bLoC,
            ),
            splashIconSize: 110,
            centered: true,
            backgroundColor: Colors.white,
            duration: 4000,
            splashTransition: SplashTransition.scaleTransition,
          )
        );
      });
    }
  }
}
