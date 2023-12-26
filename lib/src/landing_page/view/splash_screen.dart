import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:legal_links_app/resources/resources.dart';
import 'package:legal_links_app/services/sp_helper.dart';
import 'package:legal_links_app/src/auth/vm/auth_vm.dart';
import 'package:legal_links_app/src/base/view/pages/settings/vm/settings_vm.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/hights_widths.dart';
import '../../auth/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static String route = "/splashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Future<void> startTimer() async {
    await Future.delayed(const Duration(seconds: 2)); // Delay for text animation
    await controller.forward(); // Start the text animation
    await Future.delayed(const Duration(seconds: 3)); // Delay before starting image animation
    Get.offAllNamed(LoginScreen.route);
  }

  late AnimationController controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var vm = Provider.of<SettingsVM>(context, listen: false);
      var avm = Provider.of<AuthVM>(context, listen: false);
      // Map? m = await HiveStorage.getHive();
      // if (m != null) {
      //   String e = m["email"];
      //   String p = m["email"];
      // Retrieve data
      Map<String, String> userData = await SharedPreferencesHelper.getUserData();
      debugPrint("Email: ${userData["email"]}}");
      if (userData["email"] != null && userData["pass"] != null) {
        await avm.signIn(userData["email"]!, userData["pass"]!);
      }
      // }

      await vm.getData();
      vm.update();
    });
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimationConfiguration.staggeredList(
                position: 0,
                duration: const Duration(seconds: 5),
                child: SlideAnimation(
                  verticalOffset: -MediaQuery.of(context).size.height,
                  child: FadeInAnimation(
                    child: Image.asset(R.images.logo, scale: 4), // Replace with your logo asset
                  ),
                ),
              ),
              h1,
              AnimationConfiguration.staggeredList(
                position: 1,
                duration: const Duration(seconds: 2),
                child: SlideAnimation(
                  verticalOffset: -MediaQuery.of(context).size.height,
                  child: FadeInAnimation(
                    child: Text(
                      "LEGAL LINKS",
                      style: R.textStyles.poppinsBold().copyWith(
                            color: R.colors.primary,
                            fontSize: 16.sp,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
