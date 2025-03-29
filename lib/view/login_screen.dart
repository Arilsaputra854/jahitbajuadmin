import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jahit_baju_admin/controller/login_controller.dart';
import 'package:jahit_baju_admin/util/token_storage.dart';
import 'package:jahit_baju_admin/view/dashboard_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Transform.scale(
                    scale: 1.3,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          image: AssetImage("assets/background/bg.png"),
                          fit: BoxFit.cover,
                          opacity: 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 450.h,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: 100.w,
                            height: 100.w,
                            child: Image.asset(
                              "assets/logo/jahit_baju_logo.png",
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text("Masuk sebagai Admin"),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Kolom ini tidak boleh kosong!";
                                    }
                                    return null;
                                  },
                                  onChanged: controller.setEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    errorStyle: TextStyle(color: Colors.black),
                                    hintText: "john@gmail.com",
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Kolom ini tidak boleh kosong!";
                                    }
                                    return null;
                                  },
                                  onChanged: controller.setPassword,
                                  obscureText: !controller.hidePassword,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    errorStyle: TextStyle(color: Colors.black),
                                    hintText: "********",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        controller.setHidePassword();
                                      },
                                      icon: Icon(
                                        controller.hidePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 320.w,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                controller.login().then((token) async {
                                  if(controller.errorMsg != null){
                                    Fluttertoast.showToast(msg: controller.errorMsg!);
                                  }
                                  if(token != null){
                                    await SecureStorage.saveToken(token).then((_){
                                      Fluttertoast.showToast( msg: "Login Berhasil!");
                                      goToDashboardScreen();
                                    });
                                  }
                                });
                              }
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void goToDashboardScreen() {
    Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()));
  }
}
