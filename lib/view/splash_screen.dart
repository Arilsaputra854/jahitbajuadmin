import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jahit_baju_admin/view/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
   var version = "1.0.0";
   Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
   return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFF57AFF9),
              Color(0xFF8BE0E5),
              Color(0xFFDFCFAF),
              Color(0xFFFDCA8A),
              Color(0xFFFEAEA9),
            ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200.w,
                    height: 200.w,
                    child: Image.asset("assets/logo/jahit_baju_logo.png")),
                    SizedBox(height: 50.h,),
                Text(
                  "v${version ?? "0.0.0"}",
                  style: TextStyle(fontSize: 12.sp),
                )
              ],
            )));
  }
}