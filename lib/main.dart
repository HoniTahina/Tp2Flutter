import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tp2/page/ajout_tache.dart';
import 'package:tp2/page/home.dart';
import 'package:tp2/page/signin.dart';
import 'package:tp2/page/signup.dart';
import 'package:tp2/services/auth-service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final String oneSignalAppId = "b34d1ff4-7ac1-4f5e-ba02-5e60b103bdad";
  //firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  Widget currentPage = Login();
  Service authClass = Service();
  @override
  void initState() {
    checkLogin();
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      currentPage = HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: MyApp.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: Color.fromARGB(255, 241, 1, 141),
                ),
                scaffoldBackgroundColor: Color.fromARGB(255, 233, 1, 202),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: Color.fromARGB(255, 179, 4, 135))),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            debugShowCheckedModeBanner: false,
            home: currentPage,
          );
        });
  }
}
