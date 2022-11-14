// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_get_it.dart';
import 'package:ourdoctor/helpers/fcm.dart';
import 'package:ourdoctor/pages/splash/splash.dart';
import 'package:ourdoctor/provider/global_provider.dart';
import 'package:ourdoctor/provider/old_food_list_provider.dart';
import 'package:ourdoctor/provider/convert_score_provider.dart';
import 'package:provider/provider.dart';

import 'language/language_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  initFcm();
  initKakao();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ConvertScoreProvider()),
      ChangeNotifierProvider(create: (_) => OldFoodListProvider()),
      ChangeNotifierProvider(create: (_) => GlobalProvider()),
      // ChangeNotifierProvider(create: (_) => ChildQuizProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LanguageService.setLanguage('ko');

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light), // Or Brightness.dark
    );
    return MaterialApp(
      builder: (ctx, child) {
        return MediaQuery(
          data: MediaQuery.of(ctx).copyWith(textScaleFactor: 1),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'OurDoctor',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        CupertinoLocalisationsDelegate(),
      ],
      supportedLocales: const [
        Locale('ko', 'KO'),
      ],
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          highlightColor: AppColor_Primary),
      // home: ComponentsPage(),
      home: SplashPage(),
    );
  }
}

void initKakao() async {
  await KakaoSdk.init(
      nativeAppKey: '66bed5a0bb50d14d57e723a72ec24ce8',
      javaScriptAppKey: 'ad0b797bd5112488cbd498ec3c9f6ce1');
}

class CupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const CupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(CupertinoLocalisationsDelegateold) => false;
}
