import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:legal_links_app/src/base/view/pages/dashboard.dart/vm/home_vm.dart';
import 'package:legal_links_app/src/base/view/pages/settings/vm/settings_vm.dart';
import 'package:legal_links_app/src/base/vm/base_vm.dart';
import 'package:legal_links_app/src/landing_page/view/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'src/auth/vm/auth_vm.dart';
import 'src/base/view/pages/appointment/vm/appointment_vm.dart';
import 'src/lawyer_base/view/pages/dashboard/vm/lawyer_vm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBVkgTpnBblEAXrSDhAhOcpKpkrckyzSAw",
          authDomain: "legallinks640.firebaseapp.com",
          projectId: "legallinks640",
          storageBucket: "legallinks640.appspot.com",
          messagingSenderId: "823762151327",
          appId: "1:823762151327:web:a26305ae6f2b5b013c7faa",
          measurementId: "G-QRES51SW63"),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthVM()),
        ChangeNotifierProvider(create: (context) => HomeVM()),
        ChangeNotifierProvider(create: (context) => BaseVM()),
        ChangeNotifierProvider(create: (context) => AppointmentVM()),
        ChangeNotifierProvider(create: (context) => SettingsVM()),
        ChangeNotifierProvider(create: (context) => LawyerVM()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: GetMaterialApp(
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          title: 'Legal Links',
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.route,
          getPages: AppPages.pages,
        ),
      );
    });
  }
}
